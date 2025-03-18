class ProductUsage {
  final String date;
  final String parcelName;
  final double dose;

  ProductUsage({
    required this.date,
    required this.parcelName,
    required this.dose,
  });

  factory ProductUsage.fromJson(Map<String, dynamic> json) {
    return ProductUsage(
      date: json["date"] ?? "Data Desconhecida",
      parcelName: json["parcelName"] ?? "Parcela Desconhecida",
      dose: (json["dose"] as num?)?.toDouble() ?? 0.0,
    );
  }
}
