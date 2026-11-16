import 'package:flutter/material.dart';
import '../utils/strings.dart';
import '../utils/tips_engine.dart';

class TipsCard extends StatelessWidget {
  final List<Tip> tips;
  const TipsCard({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    if (tips.isEmpty) return const SizedBox.shrink();
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
              tr('Saving tips'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...tips.map(
              (t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(t.icon, size: 20, color: scheme.primary),
                    const SizedBox(width: 10),
                    Expanded(child: Text(t.text)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
