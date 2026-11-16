import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/tariff_config.dart';
import '../models/appliance.dart';
import '../providers/appliance_provider.dart';
import '../services/auth_service.dart';
import '../services/bill_calculator.dart';
import '../services/language_controller.dart';
import '../services/protected_status_service.dart';
import '../services/tariff_service.dart';
import '../services/theme_controller.dart';
import '../utils/strings.dart';
import '../utils/tips_engine.dart';
import '../widgets/breakdown_card.dart';
import '../widgets/history_buttons.dart';
import '../widgets/protected_card.dart';
import '../widgets/tips_card.dart';
import '../widgets/whatif_card.dart';

class Preset {
  final String name; // English key, translated when shown
  final double watts;
  final double hours;
  final IconData icon;
  const Preset(this.name, this.watts, this.hours, this.icon);
}

const presets = [
  Preset('AC 1.5 ton', 1500, 8, Icons.ac_unit),
  Preset('Fridge', 150, 24, Icons.kitchen),
  Preset('Fan', 75, 10, Icons.air),
  Preset('Iron', 1000, 0.5, Icons.iron),
  Preset('LED bulb', 10, 6, Icons.lightbulb),
  Preset('TV', 100, 4, Icons.tv),
  Preset('Washing machine', 400, 1, Icons.local_laundry_service),
  Preset('Water pump', 750, 0.5, Icons.water_drop),
];

IconData iconFor(String name) {
  final n = name.toLowerCase();
  if (n.contains('pankha')) return Icons.air; // older saved entries
  for (final p in presets) {
    final en = p.name.toLowerCase().split(' ').first;
    final ur = urdu(p.name).split(' ').first;
    if (n.contains(en) || n.contains(ur)) return p.icon;
  }
  return Icons.electrical_services;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showApplianceDialog(
    BuildContext context, {
    Preset? preset,
    Appliance? existing,
  }) {
    final name = TextEditingController(
      text: existing?.name ?? (preset == null ? '' : tr(preset.name)),
    );
    final watts = TextEditingController(
      text: (existing?.watts ?? preset?.watts)?.toString() ?? '',
    );
    final hours = TextEditingController(
      text: (existing?.hoursPerDay ?? preset?.hours)?.toString() ?? '',
    );
    final isEdit = existing != null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? tr('Edit appliance') : tr('Add appliance')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: tr('Appliance name (e.g. AC)'),
              ),
            ),
            TextField(
              controller: watts,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: tr('Power (watts)')),
            ),
            TextField(
              controller: hours,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: tr('Hours used per day')),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('Cancel')),
          ),
          FilledButton(
            onPressed: () {
              final w = double.tryParse(watts.text);
              final h = double.tryParse(hours.text);
              if (name.text.trim().isEmpty || w == null || h == null) return;
              final provider = context.read<ApplianceProvider>();
              final a = Appliance(
                id:
                    existing?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                name: name.text.trim(),
                watts: w,
                hoursPerDay: h,
                daysPerMonth: existing?.daysPerMonth ?? 30,
              );
              isEdit ? provider.update(a) : provider.add(a);
              Navigator.pop(context);
            },
            child: Text(isEdit ? tr('Save') : tr('Add')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ApplianceProvider>();
    context.watch<TariffService>(); // refresh when rates change
    context.watch<ProtectedStatusService>(); // refresh when status changes
    final result = estimateBill(p.totalUnits);
    final bill = result.total;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    final displayName = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.split(' ').first
        : tr('there');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WattWise',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () => context.read<LanguageController>().toggle(),
            child: Text(LanguageController.isUrdu ? 'EN' : 'اردو'),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark
                ? tr('Switch to light mode')
                : tr('Switch to dark mode'),
            onPressed: () => context.read<ThemeController>().toggle(isDark),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: tr('Sign out'),
            onPressed: () => AuthService().logout(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              tr('Hello, {name}!', {'name': displayName}),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8A5A14), Color(0xFFB07A2A)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('Estimated bill this month'),
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  'Rs. ${bill.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      tr('{n} units (kWh)', {
                        'n': p.totalUnits.toStringAsFixed(1),
                      }),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  result.isProtected
                      ? tr('Protected tariff (approx.)')
                      : tr('Unprotected tariff (approx.)'),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  tr('Rates: {note}', {'note': TariffConfig.note}),
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          HistoryButtons(units: p.totalUnits, total: bill),
          const SizedBox(height: 16),
          ProtectedCard(units: p.totalUnits, items: p.items),
          const SizedBox(height: 16),
          if (p.items.isNotEmpty) ...[
            TipsCard(tips: buildTips(p.items)),
            const SizedBox(height: 16),
            WhatIfCard(items: p.items),
            const SizedBox(height: 16),
            BreakdownCard(items: p.items, totalBill: bill),
            const SizedBox(height: 16),
          ],
          Text(
            tr('Quick add'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: presets
                .map(
                  (pr) => ActionChip(
                    avatar: Icon(pr.icon, size: 18),
                    label: Text(tr(pr.name)),
                    onPressed: () => _showApplianceDialog(context, preset: pr),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Text(
            tr('My appliances ({n})', {'n': p.items.length}),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          if (p.items.isNotEmpty)
            Text(
              tr('Tap an appliance to edit it'),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          const SizedBox(height: 8),
          if (p.items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  tr(
                    'No appliances yet.\nTap a chip above or the button below to add one.',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ...p.items.map(
            (a) => Card(
              child: ListTile(
                onTap: () => _showApplianceDialog(context, existing: a),
                leading: CircleAvatar(
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(iconFor(a.name), color: scheme.primary),
                ),
                title: Text(
                  a.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  tr('{w}W x {h} h/day', {'w': a.watts, 'h': a.hoursPerDay}),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tr('{n} units', {'n': a.monthlyUnits.toStringAsFixed(1)}),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: tr('Delete'),
                      onPressed: () => p.remove(a.id),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showApplianceDialog(context),
        icon: const Icon(Icons.add),
        label: Text(tr('Add appliance')),
      ),
    );
  }
}
