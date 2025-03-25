import 'task_detail.dart';

class Recommendation {
  final String parcelName;
  final String type;
  final String recommendedDate;
  String status;
  final String notes;
  final List<TaskDetail> tasks;

  Recommendation({
    required this.parcelName,
    required this.type,
    required this.recommendedDate,
    required this.status,
    required this.notes,
    required this.tasks,
  });
}
