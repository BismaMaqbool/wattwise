import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/bill_record.dart';
import '../services/history_service.dart';
import '../utils/strings.dart';

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

String _label(String monthId) {
  final p = monthId.split('-');
  return '${tr(_months[int.parse(p[1]) - 1])} ${p[0].substring(2)}';
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(tr('Bill history'))),
      body: StreamBuilder<List<BillRecord>>(
        stream: HistoryService.watch(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Text(tr('Something went wrong: {e}', {'e': snap.error!})),
            );
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final all = snap.data!;
          if (all.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  tr(
                    'No saved bills yet.\nTap "Save bill" on the home screen to add this month.',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final shown = all.length > 6 ? all.sublist(all.length - 6) : all;
          final maxY =
              shown.map((e) => e.total).reduce((a, b) => a > b ? a : b) * 1.2;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                tr('Monthly bills (Rs.)'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= shown.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _label(shown[i].monthId),
                                style: const TextStyle(fontSize: 11),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (var i = 0; i < shown.length; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: shown[i].total,
                              color: scheme.primary,
                              width: 22,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...all.reversed.map((r) {
                final idx = all.indexOf(r);
                final prev = idx > 0 ? all[idx - 1] : null;
                final diff = prev == null ? null : r.total - prev.total;
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(
                      _label(r.monthId),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      diff == null
                          ? tr('{n} units', {'n': r.units.toStringAsFixed(1)})
                          : tr('{u} units  |  {d} vs previous month', {
                              'u': r.units.toStringAsFixed(1),
                              'd':
                                  '${diff >= 0 ? '+' : '-'}Rs. ${diff.abs().round()}',
                            }),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Rs. ${r.total.round()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: tr('Delete'),
                          onPressed: () => HistoryService.delete(r.monthId),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
