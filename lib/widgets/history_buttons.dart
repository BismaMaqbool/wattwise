import 'package:flutter/material.dart';
import '../screens/history_screen.dart';
import '../services/history_service.dart';
import '../utils/strings.dart';

class HistoryButtons extends StatelessWidget {
  final double units;
  final double total;
  const HistoryButtons({super.key, required this.units, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: units <= 0
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await HistoryService.saveMonth(units, total);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            tr("This month's bill has been saved."),
                          ),
                        ),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(tr('Could not save: {e}', {'e': e})),
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.save_alt),
            label: Text(tr('Save bill')),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HistoryScreen()),
          ),
          icon: const Icon(Icons.bar_chart),
          label: Text(tr('History')),
        ),
      ],
    );
  }
}
