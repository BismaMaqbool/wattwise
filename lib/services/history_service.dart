import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bill_record.dart';

class HistoryService {
  static CollectionReference<Map<String, dynamic>>? get _col {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bills');
  }

  static String monthId(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  // Same mahine dobara save karo to purana record update ho jata hai
  static Future<void> saveMonth(double units, double total) async {
    final col = _col;
    if (col == null) return;
    await col.doc(monthId(DateTime.now())).set({
      'units': units,
      'total': total,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<List<BillRecord>> watch() {
    final col = _col;
    if (col == null) return const Stream.empty();
    return col.snapshots().map((snap) {
      final list = snap.docs
          .map((d) => BillRecord.fromMap(d.id, d.data()))
          .toList();
      list.sort((a, b) => a.monthId.compareTo(b.monthId));
      return list;
    });
  }

  static Future<void> delete(String monthId) async {
    await _col?.doc(monthId).delete();
  }
}
