import 'package:flutter/material.dart';
import '../../../core/models/recommendation.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../shared/themes/app_theme.dart';

class RecommendationsScreen extends StatefulWidget {
  final MockDataService mockService;
  final bool isConsultant;

  const RecommendationsScreen({
    super.key,
    required this.mockService,
    required this.isConsultant,
  });

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
    List<Recommendation> recommendations = widget.mockService.recommendations;
    _toDo = recommendations.where((r) => r.status == "To Do").toList();
    _doing = recommendations.where((r) => r.status == "Doing").toList();
    _done = recommendations.where((r) => r.status == "Done").toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recomendações Agronômicas")),
      body: Column(
        children: [
          if (widget.isConsultant) _buildAddRecommendationButton(),
          Expanded(
            child: Row(
              children: [
                _buildTaskColumn("To Do", _toDo, Colors.red),
                _buildTaskColumn("Doing", _doing, Colors.orange),
                _buildTaskColumn("Done", _done, Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📌 Botão para Adicionar Nova Recomendação
  Widget _buildAddRecommendationButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text("Adicionar Recomendação"),
        onPressed: () => _showAddRecommendationDialog(),
      ),
    );
  }

  // 📌 Coluna de Tarefas (Drag-and-Drop)
  Widget _buildTaskColumn(
    String title,
    List<Recommendation> tasks,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
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
              child: DragTarget<Recommendation>(
                onAccept: (recommendation) {
                  setState(() {
                    _moveTask(recommendation, title);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return ListView(
                    children:
                        tasks.map((task) => _buildDraggableTask(task)).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Card Draggable para cada Recomendação
  Widget _buildDraggableTask(Recommendation recommendation) {
    return Draggable<Recommendation>(
      data: recommendation,
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildTaskCard(recommendation),
      ),
      feedback: Material(child: _buildTaskCard(recommendation)),
      child: _buildTaskCard(recommendation),
    );
  }

  // 📌 Cartão da Tarefa
  Widget _buildTaskCard(Recommendation recommendation) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Icon(
          Icons.insights,
          color: _getStatusColor(recommendation.status),
          size: 32,
        ),
        title: Text(
          recommendation.parcelName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("📅 ${recommendation.recommendedDate}"),
        trailing: Icon(
          Icons.drag_handle,
          color: _getStatusColor(recommendation.status),
        ),
        onTap: () => _showRecommendationDetail(context, recommendation),
      ),
    );
  }

  // 📌 Mover Tarefa para Outro Status
  void _moveTask(Recommendation recommendation, String newStatus) {
    setState(() {
      recommendation.status = newStatus;
      _loadRecommendations();
    });
  }

  // 📌 Exibir Detalhes da Recomendação
  void _showRecommendationDetail(
    BuildContext context,
    Recommendation recommendation,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Detalhes da Recomendação",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildInfoRow("🌱 Parcela", recommendation.parcelName),
                _buildInfoRow(
                  "📅 Data Recomendada",
                  recommendation.recommendedDate,
                ),
                _buildInfoRow("⚡ Tipo de Ação", recommendation.type),
                _buildInfoRow("📌 Observação", recommendation.notes),
              ],
            ),
          ),
    );
  }

  // 📌 Adicionar Nova Recomendação
  void _showAddRecommendationDialog() {
    TextEditingController parcelController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Recomendação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: parcelController,
                decoration: const InputDecoration(labelText: "Parcela"),
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: "Tipo de Ação"),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Data Recomendada",
                ),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: "Observação"),
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
                _addNewRecommendation(
                  parcelController.text,
                  typeController.text,
                  dateController.text,
                  notesController.text,
                );
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  // 📌 Adicionar Nova Recomendação no MockDataService
  void _addNewRecommendation(
    String parcel,
    String type,
    String date,
    String notes,
  ) {
    setState(() {
      widget.mockService.recommendations.add(
        Recommendation(
          parcelName: parcel,
          type: type,
          recommendedDate: date,
          status: "To Do",
          notes: notes,
        ),
      );
      _loadRecommendations();
    });
  }

  // 📌 Info Row UI
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  // 📌 Status Color
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
}
