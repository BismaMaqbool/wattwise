import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../config/tariff_config.dart';
import '../models/bill_record.dart';
import 'history_service.dart';

class ProtectedInfo {
  final bool eligible; // saved history allows protected status
  final int savedMonths; // saved months inside the window
  final String? lastExceededMonth; // e.g. 2026-10
  final String? regainMonth; // first month protected again

  const ProtectedInfo({
    required this.eligible,
    required this.savedMonths,
    this.lastExceededMonth,
    this.regainMonth,
  });
}

class ProtectedStatusService extends ChangeNotifier {
  ProtectedInfo info = const ProtectedInfo(eligible: true, savedMonths: 0);

  StreamSubscription<User?>? _authSub;
  StreamSubscription<List<BillRecord>>? _dataSub;

  ProtectedStatusService() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      _dataSub?.cancel();
      if (user == null) {
        _reset();
        return;
      }
      _dataSub = HistoryService.watch().listen(
        _compute,
        onError: (e) => debugPrint('Protected status error: $e'),
      );
    });
  }

  void _reset() {
    info = const ProtectedInfo(eligible: true, savedMonths: 0);
    TariffConfig.protectedEligible = true;
    notifyListeners();
  }

  void _compute(List<BillRecord> records) {
    final now = DateTime.now();
    final n = TariffConfig.protectedWindowMonths;
    final limit = TariffConfig.protectedLimit;

    // The N calendar months before the current one
    final window = <String>{};
    for (var i = 1; i <= n; i++) {
      window.add(HistoryService.monthId(DateTime(now.year, now.month - i, 1)));
    }

    final inWindow = records.where((r) => window.contains(r.monthId)).toList();
    final exceeded = inWindow.where((r) => r.units > limit).toList()
      ..sort((a, b) => a.monthId.compareTo(b.monthId));

    String? last;
    String? regain;
    if (exceeded.isNotEmpty) {
      last = exceeded.last.monthId;
      final p = last.split('-');
      // The exceeding month leaves the window after N more months
      regain = HistoryService.monthId(
        DateTime(int.parse(p[0]), int.parse(p[1]) + n + 1, 1),
      );
    }

    info = ProtectedInfo(
      eligible: exceeded.isEmpty,
      savedMonths: inWindow.length,
      lastExceededMonth: last,
      regainMonth: regain,
    );
    TariffConfig.protectedEligible = exceeded.isEmpty;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _dataSub?.cancel();
    super.dispose();
  }
}
