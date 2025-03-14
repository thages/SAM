import 'package:flutter/material.dart';
import 'package:sees/core/models/parcel_detail.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/models/parcel.dart';
import '../../../shared/themes/app_theme.dart';
import 'parcel_detail_screen.dart';

class ParcelsScreen extends StatelessWidget {
  final MockDataService mockService;
  const ParcelsScreen({super.key, required this.mockService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parcelas')),
      body: FutureBuilder<List<Parcel>>(
        future: mockService.fetchParcels(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar parcelas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma parcela encontrada'));
          }

          final parcels = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: parcels.length,
            itemBuilder: (ctx, i) {
              final p = parcels[i];
              return _buildParcelCard(context, p);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          mockService.addParcel(
            Parcel(
              id: '1',
              name: 'Parcela A',
              production: 5000, // kg
              cost: 1200, // R$
              revenue: 3000, // R$
              costPerHectare: 200, // R$ per ha
              temperature: 25.0, // °C
              rainfall: 120.0, // mm
              machineEfficiency: 85, // %
              detail: ParcelDetail(
                inputCosts: 500,
                laborCosts: 300,
                equipmentCosts: 250,
                fixedCosts: 150,
                indirectCosts: 100,
                fertilizer: "Fertilizante NPK",
                fertilizerCost: 200,
                pesticides: "Defensivo XYZ",
                pesticideCost: 150,
                seeds: "Milho Híbrido A",
                seedCost: 100,
                yields: 6.5, // ton/ha
                revenue: 3000,
                variableCosts: 800,
              ),
            ),
          );

          (context as Element).reassemble();
        },
      ),
    );
  }

  // 🟢 **Parcel Card UI**
  Widget _buildParcelCard(BuildContext context, Parcel parcel) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.grass, color: Colors.white),
        ),
        title: Text(
          parcel.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🌱 Produção: ${parcel.production} kg"),
            Text("💰 Custo: R\$ ${parcel.cost}"),
            Text("📊 Eficiência: ${parcel.machineEfficiency}%"),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: AppColors.darkGreen),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ParcelDetailScreen(parcel: parcel),
            ),
          );
        },
      ),
    );
  }
}
