import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../config/tariff_config.dart';
import '../models/slab.dart';

class TariffService extends ChangeNotifier {
  StreamSubscription<User?>? _authSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _dataSub;

  TariffService() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      _dataSub?.cancel();
      if (user == null) return;
      _dataSub = FirebaseFirestore.instance
          .collection('config')
          .doc('tariff')
          .snapshots()
          .listen((snap) {
            final raw = snap.data()?['json'];
            if (raw is! String) return;
            try {
              _apply(jsonDecode(raw) as Map<String, dynamic>);
              notifyListeners();
            } catch (e) {
              debugPrint('Tariff parse error: $e');
            }
          }, onError: (e) => debugPrint('Tariff load error: $e'));
    });
  }

  List<Slab> _slabs(dynamic list) => (list as List).map((e) {
    final m = e as Map<String, dynamic>;
    return Slab(
      (m['from'] as num).toDouble(),
      m['to'] == null ? double.infinity : (m['to'] as num).toDouble(),
      (m['rate'] as num).toDouble(),
    );
  }).toList();

  void _apply(Map<String, dynamic> d) {
    // Parse everything first, then assign (no half-applied updates)
    final ps = _slabs(d['protectedSlabs']);
    final us = _slabs(d['unprotectedSlabs']);
    final limit = (d['protectedLimit'] as num).toDouble();
    final gst = (d['gstRate'] as num).toDouble();
    final fc = (d['fcSurchargePerUnit'] as num).toDouble();
    final fixed = (d['fixedCharge'] as num).toDouble();
    final note = (d['note'] ?? 'Cloud rates') as String;
    final window = (d['protectedWindowMonths'] as num?)?.toInt() ?? 6;

    TariffConfig.protectedSlabs = ps;
    TariffConfig.unprotectedSlabs = us;
    TariffConfig.protectedLimit = limit;
    TariffConfig.gstRate = gst;
    TariffConfig.fcSurchargePerUnit = fc;
    TariffConfig.fixedCharge = fixed;
    TariffConfig.note = note;
    TariffConfig.protectedWindowMonths = window;
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _dataSub?.cancel();
    super.dispose();
  }
}
