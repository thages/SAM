class ParcelDetail {
  final double inputCosts;
  final double laborCosts;
  final double equipmentCosts;
  final double fixedCosts;
  final double indirectCosts;
  final String fertilizer;
  final double fertilizerCost;
  final String pesticides;
  final double pesticideCost;
  final String seeds;
  final double seedCost;
  final double yields;
  final double revenue;
  final double variableCosts;

  ParcelDetail({
    required this.inputCosts,
    required this.laborCosts,
    required this.equipmentCosts,
    required this.fixedCosts,
    required this.indirectCosts,
    required this.fertilizer,
    required this.fertilizerCost,
    required this.pesticides,
    required this.pesticideCost,
    required this.seeds,
    required this.seedCost,
    required this.yields,
    required this.revenue,
    required this.variableCosts,
  });

  factory ParcelDetail.fromJson(Map<String, dynamic> json) {
    return ParcelDetail(
      inputCosts: json['inputCosts'].toDouble(),
      laborCosts: json['laborCosts'].toDouble(),
      equipmentCosts: json['equipmentCosts'].toDouble(),
      fixedCosts: json['fixedCosts'].toDouble(),
      indirectCosts: json['indirectCosts'].toDouble(),
      fertilizer: json['fertilizer'],
      fertilizerCost: json['fertilizerCost'].toDouble(),
      pesticides: json['pesticides'],
      pesticideCost: json['pesticideCost'].toDouble(),
      seeds: json['seeds'],
      seedCost: json['seedCost'].toDouble(),
      yields: json['yields'].toDouble(),
      revenue: json['revenue'].toDouble(),
      variableCosts: json['variableCosts'].toDouble(),
    );
  }
}
