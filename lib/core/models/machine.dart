class Machine {
  final String id;
  final String name;
  final String type;
  final String lastMaintenance;
  double hoursUsed;
  final double fuelCostPerHour;
  final double maintenanceCostPerHour;
  final double depreciationCostPerHour;

  Machine({
    required this.id,
    required this.name,
    required this.type,
    required this.lastMaintenance,
    required this.hoursUsed,
    required this.fuelCostPerHour,
    required this.maintenanceCostPerHour,
    required this.depreciationCostPerHour,
  });

  double calculateCostPerHour() {
    return fuelCostPerHour + maintenanceCostPerHour + depreciationCostPerHour;
  }

  double calculateTotalCost() {
    return hoursUsed * calculateCostPerHour();
  }
}
