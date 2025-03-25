import 'package:flutter/material.dart';
import '../../../core/models/recommendation.dart';
import '../../../core/services/mock_data_service.dart';
import '../../core/models/task_detail.dart';

class RecommendationsScreen extends StatefulWidget {
  final MockDataService mockService;
  final bool isConsultant;

  const RecommendationsScreen({
    Key? key,
    required this.mockService,
    required this.isConsultant,
  }) : super(key: key);

  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late List<Recommendation> _toDo;
  late List<Recommendation> _doing;
  late List<Recommendation> _done;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  void _loadRecommendations() {
    setState(() {
      final recommendations = widget.mockService.recommendations;
      _toDo = recommendations.where((r) => r.status == "To Do").toList();
      _doing = recommendations.where((r) => r.status == "Doing").toList();
      _done = recommendations.where((r) => r.status == "Done").toList();
    });
  }

  void _moveTask(Recommendation recommendation, String newStatus) {
    setState(() {
      _toDo.remove(recommendation);
      _doing.remove(recommendation);
      _done.remove(recommendation);

      recommendation.status = newStatus;

      switch (newStatus) {
        case "To Do":
          _toDo.add(recommendation);
          break;
        case "Doing":
          _doing.add(recommendation);
          break;
        case "Done":
          _done.add(recommendation);
          break;
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "To Do":
        return Colors.red;
      case "Doing":
        return Colors.orange;
      case "Done":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _addNewRecommendation(
    String parcel,
    String type,
    String date,
    String notes,
    List<String> tasks,
  ) {
    final newRecommendation = Recommendation(
      parcelName: parcel,
      recommendedDate: date,
      notes: notes,
      status: "To Do",
      type: type,
      tasks: tasks.map((task) => TaskDetail(name: task)).toList(),
    );

    setState(() {
      widget.mockService.recommendations.add(newRecommendation);
      _toDo.add(newRecommendation);
    });
  }

  void _showRecommendationDetail(
    BuildContext context,
    Recommendation recommendation,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // 🟢 Ensure state updates inside the dialog
            return AlertDialog(
              title: Text(
                recommendation.parcelName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("📌 Tipo", recommendation.type),
                    _buildInfoRow(
                      "📅 Data Recomendada",
                      recommendation.recommendedDate,
                    ),
                    _buildInfoRow(
                      "🔍 Observações",
                      recommendation.notes.isNotEmpty
                          ? recommendation.notes
                          : "Nenhuma",
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "✔️ Passos a Seguir:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children:
                          recommendation.tasks.map((task) {
                            return CheckboxListTile(
                              controlAffinity:
                                  ListTileControlAffinity
                                      .leading, // 🟢 Move checkbox to the left
                              title: Text(task.name),
                              value: task.completed,
                              onChanged: (value) {
                                setState(() {
                                  // 🟢 Ensure immediate update inside the dialog
                                  task.completed = value ?? false;
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Fechar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// 🟢 Reusable Info Row UI for Neat Display
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRecommendationDialog() {
    String parcel = "";
    String type = "";
    String date = "";
    String notes = "";
    List<String> tasks = [
      "1- Jet Gold = 50 ml/ha",
      "2- Unizeb Gold 75% = 1,5 kgs/ha",
      "3- Methomyl 90% = 300 gramos/ha",
      "4- Brivo ( Piraclostrobin 26% + Difenoconazole 30%) = 300 ml/ha",
      "5- Treky Top = 400 ml/ha",
      "6- Fluid Max Orange = 120 ml/ha.",
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Recomendação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Talhão"),
                onChanged: (value) => parcel = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Tipo de Ação"),
                onChanged: (value) => type = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Data"),
                onChanged: (value) => date = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Observação"),
                onChanged: (value) => notes = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (parcel.isNotEmpty && type.isNotEmpty && date.isNotEmpty) {
                  _addNewRecommendation(parcel, type, date, notes, tasks);
                  Navigator.pop(context);
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskColumn(
    String title,
    List<Recommendation> tasks,
    Color color,
  ) {
    return SizedBox(
      width: 300, // Fixed width for each column
      child: DragTarget<Recommendation>(
        onWillAccept: (recommendation) => true,
        onAccept: (recommendation) => _moveTask(recommendation, title),
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white, //color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children:
                        tasks.map((task) => _buildDraggableTask(task)).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableTask(Recommendation recommendation) {
    return LongPressDraggable<Recommendation>(
      data: recommendation,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(opacity: 0.8, child: _buildTaskCard(recommendation)),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildTaskCard(recommendation),
      ),
      child: _buildTaskCard(recommendation),
    );
  }

  Widget _buildTaskCard(Recommendation recommendation) {
    return Container(
      width: 280, // Set a fixed width for each card
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          leading: Icon(
            Icons.insights,
            color: _getStatusColor(recommendation.status),
            size: 32,
          ),
          title: Text(
            recommendation.parcelName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "📅 ${recommendation.recommendedDate} | ${recommendation.type}",
          ),
          trailing: Icon(
            Icons.drag_handle,
            color: _getStatusColor(recommendation.status),
          ),
          onTap: () => _showRecommendationDetail(context, recommendation),
        ),
      ),
    );
  }

  Widget _buildAddRecommendationButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text("Adicionar Recomendação"),
        onPressed: _showAddRecommendationDialog,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recomendações Agronômicas")),
      body: Column(
        children: [
          if (widget.isConsultant) _buildAddRecommendationButton(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicWidth(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTaskColumn("To Do", _toDo, Colors.red),
                    _buildTaskColumn("Doing", _doing, Colors.orange),
                    _buildTaskColumn("Done", _done, Colors.green),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
