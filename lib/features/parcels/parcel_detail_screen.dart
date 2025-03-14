import 'package:flutter/material.dart';
import '../../../core/models/parcel.dart';
import '../../../shared/themes/app_theme.dart';

class ParcelDetailScreen extends StatelessWidget {
  final Parcel parcel;
  const ParcelDetailScreen({Key? key, required this.parcel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double profit = parcel.revenue - parcel.cost;
    double roi = (parcel.cost > 0) ? (profit / parcel.cost) * 100 : 0;
    double grossMargin = parcel.revenue - parcel.detail.variableCosts;
    double netMargin = grossMargin - parcel.detail.fixedCosts;

    return Scaffold(
      appBar: AppBar(title: Text(parcel.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionTitle("📍 Informações da Parcela"),
            _buildInfoCard([
              _buildInfoRow("Produção", "${parcel.production} kg"),
              _buildInfoRow("Produtividade", "${parcel.detail.yields} kg/ha"),
              _buildInfoRow("Custo Total", "R\$ ${parcel.cost}"),
              _buildInfoRow("Receita", "R\$ ${parcel.revenue}"),
              _buildInfoRow(
                "Custo por Hectare",
                "R\$ ${parcel.costPerHectare}",
              ),
              _buildInfoRow(
                "Eficiência das Máquinas",
                "${parcel.machineEfficiency}%",
              ),
            ]),

            const SizedBox(height: 20),

            _buildSectionTitle("💰 Gestão Financeira Agrícola"),
            _buildFinancialCard(profit, roi, grossMargin, netMargin),

            const SizedBox(height: 20),

            _buildSectionTitle("📈 Histórico Econômico"),
            _buildHistoryChart(),

            const SizedBox(height: 20),

            _buildSectionTitle("🔍 Controle Detalhado de Custos"),
            _buildCostBreakdown(),

            const SizedBox(height: 20),

            _buildSectionTitle("🌱 Produtos Utilizados"),
            _buildProductUsage(),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Editar Dados Financeiros"),
              onPressed: () {
                // Navigate to edit financial details (to be implemented)
              },
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGreen,
        ),
      ),
    );
  }

  // 📌 Information Card
  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: children),
      ),
    );
  }

  // 📌 Information Row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // 📌 Financial Overview Card
  Widget _buildFinancialCard(
    double profit,
    double roi,
    double grossMargin,
    double netMargin,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildInfoRow("Lucro", "R\$ ${profit.toStringAsFixed(2)}"),
            _buildInfoRow(
              "Retorno sobre Investimento (ROI)",
              "${roi.toStringAsFixed(2)}%",
            ),
            _buildInfoRow(
              "Margem Bruta",
              "R\$ ${grossMargin.toStringAsFixed(2)}",
            ),
            _buildInfoRow(
              "Margem Líquida",
              "R\$ ${netMargin.toStringAsFixed(2)}",
            ),
          ],
        ),
      ),
    );
  }

  // 📈 Mock Data for Economic History Chart
  Widget _buildHistoryChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 200,
        child: const Center(
          child: Text(
            "📊 Evolução financeira nos últimos anos\n(Exemplo: 2021 - 2024)\n\nAno  | Receita (R\$) | Custo (R\$)\n2021  | 10,000         | 7,500\n2022  | 12,000         | 8,000\n2023  | 13,500         | 8,700\n2024  | 15,000         | 9,500",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // 📌 Cost Breakdown (Direct & Indirect Costs)
  Widget _buildCostBreakdown() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildInfoRow("🌿 Insumos", "R\$ ${parcel.detail.inputCosts}"),
            _buildInfoRow(
              "🧑‍🌾 Mão de Obra",
              "R\$ ${parcel.detail.laborCosts}",
            ),
            _buildInfoRow("🚜 Máquinas", "R\$ ${parcel.detail.equipmentCosts}"),
            _buildInfoRow("🏢 Custos Fixos", "R\$ ${parcel.detail.fixedCosts}"),
            _buildInfoRow(
              "📦 Custos Indiretos",
              "R\$ ${parcel.detail.indirectCosts}",
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Product Usage (Fertilizers, Pesticides, Seeds)
  Widget _buildProductUsage() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildInfoRow(
              "🌱 Fertilizantes",
              "${parcel.detail.fertilizer} kg - R\$ ${parcel.detail.fertilizerCost}",
            ),
            _buildInfoRow(
              "🛡️ Defensivos",
              "${parcel.detail.pesticides} L - R\$ ${parcel.detail.pesticideCost}",
            ),
            _buildInfoRow(
              "🌾 Sementes",
              "${parcel.detail.seeds} kg - R\$ ${parcel.detail.seedCost}",
            ),
          ],
        ),
      ),
    );
  }
}
