import 'package:flutter/material.dart';
import '../models/appliance.dart';
import '../services/bill_calculator.dart';
import '../utils/strings.dart';

class WhatIfCard extends StatefulWidget {
  final List<Appliance> items;
  const WhatIfCard({super.key, required this.items});

  @override
  State<WhatIfCard> createState() => _WhatIfCardState();
}

class _WhatIfCardState extends State<WhatIfCard> {
  String? _id;
  double? _hours;

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) return const SizedBox.shrink();

    final selected = items.firstWhere(
      (a) => a.id == _id,
      orElse: () => items.first,
    );
    if (_id != selected.id) {
      _id = selected.id;
      _hours = null;
    }
    final hours = (_hours ?? selected.hoursPerDay).clamp(0.0, 24.0);

    final totalUnits = items.fold<double>(0, (s, a) => s + a.monthlyUnits);
    final newUnits =
        totalUnits -
        selected.monthlyUnits +
        selected.watts * hours * selected.daysPerMonth / 1000;

    final current = estimateBill(totalUnits).total;
    final after = estimateBill(newUnits < 0 ? 0 : newUnits).total;
    final diff = current - after;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('What-if simulator'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              tr('Change daily usage and see how your bill changes.'),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selected.id,
              isExpanded: true,
              items: items
                  .map(
                    (a) => DropdownMenuItem(value: a.id, child: Text(a.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                _id = v;
                _hours = null;
              }),
            ),
            Text(
              tr('{h} hours per day (currently {c})', {
                'h': hours.toStringAsFixed(1),
                'c': selected.hoursPerDay,
              }),
            ),
            Slider(
              value: hours,
              min: 0,
              max: 24,
              divisions: 48,
              onChanged: (v) => setState(() => _hours = v),
            ),
            const SizedBox(height: 4),
            Text(
              tr('New bill: Rs. {n}', {'n': after.round()}),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              diff >= 0
                  ? tr('You save Rs. {n} per month', {'n': diff.round()})
                  : tr('Extra cost: Rs. {n} per month', {'n': (-diff).round()}),
              style: TextStyle(
                color: diff >= 0 ? Colors.green.shade700 : scheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
