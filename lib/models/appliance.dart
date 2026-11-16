class Appliance {
  final String id;
  final String name;
  final double watts;
  final double hoursPerDay;
  final int daysPerMonth;

  Appliance({
    required this.id,
    required this.name,
    required this.watts,
    required this.hoursPerDay,
    this.daysPerMonth = 30,
  });

  double get monthlyUnits => (watts * hoursPerDay * daysPerMonth) / 1000;

  Map<String, dynamic> toMap() => {
    'name': name,
    'watts': watts,
    'hoursPerDay': hoursPerDay,
    'daysPerMonth': daysPerMonth,
  };

  factory Appliance.fromMap(String id, Map<String, dynamic> m) => Appliance(
    id: id,
    name: (m['name'] ?? '') as String,
    watts: (m['watts'] as num).toDouble(),
    hoursPerDay: (m['hoursPerDay'] as num).toDouble(),
    daysPerMonth: (m['daysPerMonth'] ?? 30) as int,
  );
}
