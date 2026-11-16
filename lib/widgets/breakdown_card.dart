import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/appliance.dart';
import '../utils/strings.dart';

const _colors = [
  Color(0xFFF9A825),
  Color(0xFF42A5F5),
  Color(0xFF66BB6A),
  Color(0xFFEF5350),
  Color(0xFFAB47BC),
  Color(0xFF26C6DA),
  Color(0xFFFF7043),
  Color(0xFF8D6E63),
];

class BreakdownCard extends StatelessWidget {
  final List<Appliance> items;
  final double totalBill;
  const BreakdownCard({
    super.key,
    required this.items,
    required this.totalBill,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (s, a) => s + a.monthlyUnits);
    if (total <= 0) return const SizedBox.shrink();

    final sorted = [...items]
      ..sort((a, b) => b.monthlyUnits.compareTo(a.monthlyUnits));

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('Where your bill goes'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 36,
                  sections: [
                    for (var i = 0; i < sorted.length; i++)
                      PieChartSectionData(
                        value: sorted[i].monthlyUnits,
                        color: _colors[i % _colors.length],
                        radius: 52,
                        title:
                            '${(sorted[i].monthlyUnits / total * 100).toStringAsFixed(0)}%',
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < sorted.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _colors[i % _colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(sorted[i].name)),
                    Text(
                      tr('{u} units  ~Rs. {r}', {
                        'u': sorted[i].monthlyUnits.toStringAsFixed(1),
                        'r': (sorted[i].monthlyUnits / total * totalBill)
                            .round(),
                      }),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
