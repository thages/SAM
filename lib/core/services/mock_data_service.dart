import '../models/machine.dart';
import '../models/parcel.dart';
import '../models/product.dart';
import '../models/parcel_detail.dart';
import '../models/product_usage.dart';
import '../models/recommendation.dart';

class MockDataService {
  List<Parcel> parcels = [
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
    Parcel(
      id: '2',
      name: 'Parcela B',
      production: 7000,
      cost: 1800,
      revenue: 4000,
      costPerHectare: 250,
      temperature: 27.0,
      rainfall: 90.0,
      machineEfficiency: 90,
      detail: ParcelDetail(
        inputCosts: 600,
        laborCosts: 400,
        equipmentCosts: 350,
        fixedCosts: 200,
        indirectCosts: 120,
        fertilizer: "Fertilizante Orgânico",
        fertilizerCost: 250,
        pesticides: "Defensivo ABC",
        pesticideCost: 180,
        seeds: "Soja Premium B",
        seedCost: 120,
        yields: 7.2,
        revenue: 4000,
        variableCosts: 900,
      ),
    ),
    Parcel(
      id: '3',
      name: 'Parcela C',
      production: 6000,
      cost: 1500,
      revenue: 3200,
      costPerHectare: 220,
      temperature: 26.0,
      rainfall: 140.0,
      machineEfficiency: 78,
      detail: ParcelDetail(
        inputCosts: 550,
        laborCosts: 350,
        equipmentCosts: 300,
        fixedCosts: 180,
        indirectCosts: 130,
        fertilizer: "Fertilizante Superfosfato",
        fertilizerCost: 230,
        pesticides: "Defensivo DEF",
        pesticideCost: 160,
        seeds: "Trigo Rústico C",
        seedCost: 110,
        yields: 6.8,
        revenue: 3200,
        variableCosts: 850,
      ),
    ),
    Parcel(
      id: '4',
      name: 'Parcela D',
      production: 8000,
      cost: 2000,
      revenue: 5000,
      costPerHectare: 270,
      temperature: 24.0,
      rainfall: 110.0,
      machineEfficiency: 82,
      detail: ParcelDetail(
        inputCosts: 700,
        laborCosts: 500,
        equipmentCosts: 400,
        fixedCosts: 250,
        indirectCosts: 150,
        fertilizer: "Fertilizante Nitrogenado",
        fertilizerCost: 300,
        pesticides: "Defensivo UVW",
        pesticideCost: 190,
        seeds: "Arroz Tropical D",
        seedCost: 130,
        yields: 7.5,
        revenue: 5000,
        variableCosts: 1000,
      ),
    ),
  ];

  List<Product> products = [
    Product(
      id: 'prod1',
      name: 'Fertilizante X',
      type: 'Fertilizante',
      dosage: 50.0,
      applicationMethod: 'Solo',
      stock: 20,
      price: 100.0,
      vat: 10.0,
      usageHistory: [
        ProductUsage(date: '2024-03-01', parcelName: 'Parcela A', dose: 25.0),
        ProductUsage(date: '2024-02-20', parcelName: 'Parcela C', dose: 15.0),
      ],
    ),
    Product(
      id: 'prod2',
      name: 'Defensivo Y',
      type: 'Defensivo',
      dosage: 10.0,
      applicationMethod: 'Foliar',
      stock: 15,
      price: 80.0,
      vat: 10.0,
      usageHistory: [
        ProductUsage(date: '2024-02-25', parcelName: 'Parcela B', dose: 5.0),
        ProductUsage(date: '2024-02-15', parcelName: 'Parcela D', dose: 8.0),
      ],
    ),
    Product(
      id: 'prod3',
      name: 'Semente Z',
      type: 'Semente',
      dosage: 100.0,
      applicationMethod: 'Plantio Direto',
      stock: 50,
      price: 150.0,
      vat: 12.0,
      usageHistory: [
        ProductUsage(date: '2024-03-05', parcelName: 'Parcela A', dose: 30.0),
        ProductUsage(date: '2024-02-28', parcelName: 'Parcela C', dose: 20.0),
      ],
    ),
  ];

  List<Machine> machines = [
    Machine(
      id: 'mach1',
      name: 'Trator John Deere X',
      type: 'Trator',
      lastMaintenance: '2024-02-15',
      hoursUsed: 120,
      fuelCostPerHour: 20.0,
      maintenanceCostPerHour: 10.0,
      depreciationCostPerHour: 5.0,
    ),
    Machine(
      id: 'mach2',
      name: 'Colheitadeira Case 9250',
      type: 'Colheitadeira',
      lastMaintenance: '2024-01-30',
      hoursUsed: 95,
      fuelCostPerHour: 30.0,
      maintenanceCostPerHour: 12.0,
      depreciationCostPerHour: 8.0,
    ),
  ];

  List<Recommendation> recommendations = [
    Recommendation(
      parcelName: "Parcela A",
      type: "Adubação",
      recommendedDate: "2025-03-15",
      status: "Pendente",
      notes: "Aplicação de fertilizante NPK recomendada após a irrigação.",
    ),
    Recommendation(
      parcelName: "Parcela B",
      type: "Irrigação",
      recommendedDate: "2025-03-17",
      status: "Pendente",
      notes: "Manter irrigação leve para evitar compactação do solo.",
    ),
    Recommendation(
      parcelName: "Parcela C",
      type: "Pulverização",
      recommendedDate: "2025-03-18",
      status: "Pendente",
      notes: "Pulverização preventiva contra pragas devido à alta umidade.",
    ),
  ];

  Future<List<Parcel>> fetchParcels() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return parcels;
  }

  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return products;
  }

  Future<List<Machine>> fetchMachines() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return machines;
  }

  Future<List<Recommendation>> fetchRecommendations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return recommendations;
  }

  void addParcel(Parcel parcel) => parcels.add(parcel);
  void addProduct(Product product) => products.add(product);
}
