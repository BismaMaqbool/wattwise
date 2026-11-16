import 'package:flutter/material.dart';
import '../config/tariff_config.dart';
import '../models/appliance.dart';
import '../services/bill_calculator.dart';
import 'strings.dart';

class Tip {
  final IconData icon;
  final String text;
  const Tip(this.icon, this.text);
}

// Appliances that run ~all day (fridge, freezer) can't be "used less"
bool isAlwaysOn(Appliance a) => a.hoursPerDay >= 20;

List<Tip> buildTips(List<Appliance> items) {
  if (items.isEmpty) return [];
  final total = items.fold<double>(0, (s, a) => s + a.monthlyUnits);
  if (total <= 0) return [];

  final tips = <Tip>[];
  final sorted = [...items]
    ..sort((a, b) => b.monthlyUnits.compareTo(a.monthlyUnits));

  // 1. Biggest consumer
  final top = sorted.first;
  final share = top.monthlyUnits / total * 100;
  tips.add(
    Tip(
      Icons.local_fire_department,
      tr('{name} uses the most electricity ({pct}% of your units).', {
        'name': top.name,
        'pct': share.toStringAsFixed(0),
      }),
    ),
  );

  if (isAlwaysOn(top)) {
    tips.add(
      Tip(
        Icons.kitchen,
        tr(
          '{name} runs around the clock. Keep it on a medium setting and avoid opening the door often.',
          {'name': top.name},
        ),
      ),
    );
  }

  // 2. Top 3 (not always-on): saving from 1 hour less per day
  final current = estimateBill(total).total;
  final candidates = sorted.where((a) => !isAlwaysOn(a)).take(3);
  for (final a in candidates) {
    if (a.hoursPerDay < 1) continue;
    final savedUnits = a.watts * 1 * a.daysPerMonth / 1000;
    final remaining = total - savedUnits;
    final after = estimateBill(remaining < 0 ? 0 : remaining).total;
    final saving = current - after;
    if (saving >= 1) {
      tips.add(
        Tip(
          Icons.savings,
          tr(
            'Using {name} 1 hour less per day could save about Rs. {amt} per month.',
            {'name': a.name, 'amt': saving.round()},
          ),
        ),
      );
    }
  }

  // 3. Slab alert
  final limit = TariffConfig.protectedLimit;
  if (total <= limit && limit - total <= 20) {
    tips.add(
      Tip(
        Icons.warning_amber,
        tr(
          'You are only {n} units below the {limit}-unit limit. Going over it moves you to a higher tariff.',
          {
            'n': (limit - total).toStringAsFixed(0),
            'limit': limit.toStringAsFixed(0),
          },
        ),
      ),
    );
  } else if (total > limit && total - limit <= 30) {
    tips.add(
      Tip(
        Icons.trending_down,
        tr(
          'Cutting {n} units would bring you under {limit} units (protected status also depends on your last 6 months of usage).',
          {
            'n': (total - limit).toStringAsFixed(0),
            'limit': limit.toStringAsFixed(0),
          },
        ),
      ),
    );
  }

  return tips;
}
