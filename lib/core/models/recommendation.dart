class Recommendation {
  final String parcelName;
  final String type;
  final String recommendedDate;
  String status;
  final String notes;

  Recommendation({
    required this.parcelName,
    required this.type,
    required this.recommendedDate,
    required this.status,
    required this.notes,
  });
}
