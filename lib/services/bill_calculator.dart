import '../config/tariff_config.dart';
import '../models/slab.dart';

class BillResult {
  final double units;
  final bool isProtected;
  final double energy;
  final double fcSurcharge;
  final double fixed;
  final double gst;
  final double total;

  BillResult({
    required this.units,
    required this.isProtected,
    required this.energy,
    required this.fcSurcharge,
    required this.fixed,
    required this.gst,
    required this.total,
  });
}

double calculateBill(double units, List<Slab> slabs) {
  double bill = 0;
  for (final s in slabs) {
    if (units <= s.from) break;
    final upTo = units < s.to ? units : s.to;
    bill += (upTo - s.from) * s.rate;
  }
  return bill;
}

/// Bill using the user's real status: protected only if saved history
/// allows it AND this month's units are within the limit.
BillResult estimateBill(double units) {
  final isProtected =
      TariffConfig.protectedEligible && units <= TariffConfig.protectedLimit;
  return estimateBillAs(units, isProtected);
}

/// Bill assuming a specific tariff (used by the cliff simulator).
BillResult estimateBillAs(double units, bool isProtected) {
  final slabs = isProtected
      ? TariffConfig.protectedSlabs
      : TariffConfig.unprotectedSlabs;

  final energy = calculateBill(units, slabs);
  final fc = isProtected ? 0.0 : units * TariffConfig.fcSurchargePerUnit;
  final fixed = units > 0 ? TariffConfig.fixedCharge : 0.0;
  final gst = (energy + fc + fixed) * TariffConfig.gstRate;

  return BillResult(
    units: units,
    isProtected: isProtected,
    energy: energy,
    fcSurcharge: fc,
    fixed: fixed,
    gst: gst,
    total: energy + fc + fixed + gst,
  );
}
