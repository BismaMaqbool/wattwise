import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/tariff_config.dart';
import '../models/appliance.dart';
import '../services/bill_calculator.dart';
import '../services/protected_status_service.dart';
import '../utils/strings.dart';
import '../utils/tips_engine.dart' show isAlwaysOn;

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _monthLabel(String id) {
  final p = id.split('-');
  return '${tr(_months[int.parse(p[1]) - 1])} ${p[0].substring(2)}';
}

class ProtectedCard extends StatelessWidget {
  final double units;
  final List<Appliance> items;
  const ProtectedCard({super.key, required this.units, required this.items});

  String _savingPath(double limit) {
    final excess = units - limit;
    final sorted = [...items]
      ..sort((a, b) => b.monthlyUnits.compareTo(a.monthlyUnits));
    for (final a in sorted.where((a) => !isAlwaysOn(a))) {
      final perHour = a.watts * a.daysPerMonth / 1000; // units per daily hour
      if (perHour <= 0) continue;
      final hours = (excess / perHour * 10).ceil() / 10;
      if (hours <= a.hoursPerDay) {
        return tr(
          'Use {name} about {h} hours less per day to get back to {limit} units.',
          {
            'name': a.name,
            'h': hours.toStringAsFixed(1),
            'limit': limit.toStringAsFixed(0),
          },
        );
      }
    }
    return tr(
      'Cut about {n} units across your appliances to get back under {limit}.',
      {'n': excess.ceil(), 'limit': limit.toStringAsFixed(0)},
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = context.watch<ProtectedStatusService>().info;
    final scheme = Theme.of(context).colorScheme;
    final limit = TariffConfig.protectedLimit;
    final n = TariffConfig.protectedWindowMonths;
    final limitText = limit.toStringAsFixed(0);

    final overNow = units > limit;
    final isProtected = info.eligible && !overNow;
    final near = !overNow && limit > 0 && units / limit >= 0.9;
    final fraction = limit > 0 ? (units / limit).clamp(0.0, 1.0) : 0.0;
    final left = (limit - units).clamp(0.0, limit);

    final statusColor = isProtected ? Colors.green.shade600 : scheme.error;
    final barColor = overNow
        ? scheme.error
        : near
        ? Colors.orange
        : Colors.green.shade600;

    // Why this status?
    String reason;
    if (overNow) {
      reason = tr(
        "This month's estimate is over {limit} units, so unprotected rates apply.",
        {'limit': limitText},
      );
    } else if (!info.eligible && info.lastExceededMonth != null) {
      reason = tr(
        'You went over {limit} units in {month}. Protected status returns after {n} months at or below {limit} (around {regain}).',
        {
          'limit': limitText,
          'month': _monthLabel(info.lastExceededMonth!),
          'n': n,
          'regain': _monthLabel(info.regainMonth!),
        },
      );
    } else if (info.savedMonths == 0) {
      reason = tr(
        'No saved history yet. Save your bill each month so WattWise can track this.',
      );
    } else {
      reason = tr(
        'None of your last {k} saved months went over {limit} units.',
        {'k': info.savedMonths, 'limit': limitText},
      );
    }

    // Cliff simulator
    final atLimit = estimateBillAs(limit, true).total;
    final above = estimateBillAs(limit + 1, false).total;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    tr('Protected status'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isProtected ? tr('Protected') : tr('Unprotected'),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(reason),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: fraction,
              minHeight: 10,
              color: barColor,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 6),
            Text(
              overNow
                  ? tr('Over the limit by {n} units', {
                      'n': (units - limit).ceil(),
                    })
                  : tr('{used} of {limit} units used  |  {left} left', {
                      'used': units.toStringAsFixed(0),
                      'limit': limitText,
                      'left': left.toStringAsFixed(0),
                    }),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (near) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber,
                    size: 20,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tr(
                        'You are close to the {limit}-unit limit. A few more units will change your tariff.',
                        {'limit': limitText},
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (overNow && items.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 20,
                    color: scheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_savingPath(limit))),
                ],
              ),
            ],
            const Divider(height: 24),
            Text(
              tr(
                'The cliff: at {limit} units your bill is about Rs. {a}. At {next} units it jumps to about Rs. {b}, which is Rs. {d} more for 1 extra unit.',
                {
                  'limit': limitText,
                  'next': (limit + 1).toStringAsFixed(0),
                  'a': atLimit.round(),
                  'b': above.round(),
                  'd': (above - atLimit).round(),
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tr(
                'Estimates are approximate. Check the exact protected-consumer rule with your DISCO.',
              ),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
