import '../models/slab.dart';

class TariffConfig {
  static double protectedLimit = 200;
  static int protectedWindowMonths = 6;

  // Set by ProtectedStatusService from saved history
  static bool protectedEligible = true;

  static List<Slab> protectedSlabs = [
    Slab(0, 100, 10.54),
    Slab(100, 200, 13.01),
  ];

  static List<Slab> unprotectedSlabs = [
    Slab(0, 100, 22.44),
    Slab(100, 200, 28.91),
    Slab(200, 300, 33.10),
    Slab(300, 400, 33.10),
    Slab(400, 500, 33.10),
    Slab(500, 600, 33.10),
    Slab(600, 700, 33.10),
    Slab(700, double.infinity, 47.69),
  ];

  static double gstRate = 0.18;
  static double fcSurchargePerUnit = 0.43;
  static double fixedCharge = 0;
  static String note = 'Default rates (offline)';
}
