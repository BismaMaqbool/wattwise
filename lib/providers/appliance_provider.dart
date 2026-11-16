import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/appliance.dart';

class ApplianceProvider extends ChangeNotifier {
  List<Appliance> _items = [];
  List<Appliance> get items => List.unmodifiable(_items);

  String? error;
  String? _uid;
  StreamSubscription<User?>? _authSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _dataSub;

  ApplianceProvider() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
  }

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('users')
      .doc(_uid)
      .collection('appliances');

  void _onAuthChanged(User? user) {
    _dataSub?.cancel();
    _uid = user?.uid;
    _items = [];
    error = null;

    if (_uid == null) {
      notifyListeners();
      return;
    }

    _dataSub = _col.snapshots().listen(
      (snap) {
        _items = snap.docs
            .map((d) => Appliance.fromMap(d.id, d.data()))
            .toList();
        error = null;
        notifyListeners();
      },
      onError: (e) {
        error = 'Data load nahi hua: $e';
        notifyListeners();
      },
    );
  }

  double get totalUnits => _items.fold(0, (sum, a) => sum + a.monthlyUnits);

  Future<void> add(Appliance a) async {
    if (_uid == null) return;
    try {
      await _col.doc(a.id).set(a.toMap());
    } catch (e) {
      error = 'Save nahi hua: $e';
      notifyListeners();
    }
  }

  Future<void> update(Appliance a) async {
    if (_uid == null) return;
    try {
      await _col.doc(a.id).set(a.toMap());
    } catch (e) {
      error = 'Update nahi hua: $e';
      notifyListeners();
    }
  }

  Future<void> remove(String id) async {
    if (_uid == null) return;
    try {
      await _col.doc(id).delete();
    } catch (e) {
      error = 'Delete nahi hua: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _dataSub?.cancel();
    super.dispose();
  }
}
