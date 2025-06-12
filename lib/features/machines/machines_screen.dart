import 'package:flutter/material.dart';
import '../../../core/models/machine.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../shared/themes/app_theme.dart';

class MachinesScreen extends StatefulWidget {
  final MockDataService mockService;

  const MachinesScreen({super.key, required this.mockService});

  @override
  _MachinesScreenState createState() => _MachinesScreenState();
}

class _MachinesScreenState extends State<MachinesScreen> {
  late Future<List<Machine>> _machineData;

  @override
  void initState() {
    super.initState();
    _machineData = widget.mockService.fetchMachines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Controle de Máquinas")),
      body: FutureBuilder<List<Machine>>(
        future: _machineData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar máquinas: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma máquina cadastrada"));
          }

          List<Machine> machines = snapshot.data!;
          return Column(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Adicionar Máquina"),
                onPressed: _addNewMachine,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: machines.length,
                  itemBuilder: (ctx, i) {
                    final machine = machines[i];
                    return _buildMachineCard(context, machine);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMachineCard(BuildContext context, Machine machine) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const Icon(Icons.agriculture, color: Colors.green, size: 32),
        title: Text(
          machine.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🔧 Tipo: ${machine.type}"),
            Text("🛠️ Última Manutenção: ${machine.lastMaintenance}"),
            Text("⏳ Horas de Uso: ${machine.hoursUsed} h"),
            Text(
              "💰 Custo por Hora: R\$${machine.calculateCostPerHour().toStringAsFixed(2)}",
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          _showMachineDetail(context, machine);
        },
      ),
    );
  }

  void _showMachineDetail(BuildContext context, Machine machine) {
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
                  machine.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildInfoRow("🔧 Tipo", machine.type),
                _buildInfoRow("📅 Última Manutenção", machine.lastMaintenance),
                _buildInfoRow("⏳ Horas de Uso", "${machine.hoursUsed} h"),
                _buildInfoRow(
                  "💰 Custo Total de Operação",
                  "R\$ ${machine.calculateTotalCost().toStringAsFixed(2)}",
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text("Registrar Novo Uso"),
                  onPressed: () {
                    _registerMachineUsage(machine);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _registerMachineUsage(Machine machine) {
    setState(() {
      machine.hoursUsed += 5; // Simula 5h de uso
    });
    Navigator.pop(context);
  }

  void _addNewMachine() {
    setState(() {
      widget.mockService.machines.add(
        Machine(
          id: DateTime.now().toString(),
          name: "Nova Máquina",
          type: "Trator",
          lastMaintenance: "2024-03-01",
          hoursUsed: 0,
          fuelCostPerHour: 20.0,
          maintenanceCostPerHour: 10.0,
          depreciationCostPerHour: 5.0,
        ),
      );
    });

    _machineData =
        widget.mockService
            .fetchMachines(); 
  }

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
}
