class BillRecord {
  final String monthId; // jaise 2026-11
  final double units;
  final double total;

  BillRecord({required this.monthId, required this.units, required this.total});

  factory BillRecord.fromMap(String id, Map<String, dynamic> m) => BillRecord(
    monthId: id,
    units: (m['units'] as num).toDouble(),
    total: (m['total'] as num).toDouble(),
  );
}
