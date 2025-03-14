import 'product_usage.dart';

class Product {
  final String id;
  final String name;
  final String type;
  final double dosage;
  final String applicationMethod;
  final int stock;
  final double price;
  final double vat;
  final List<ProductUsage> usageHistory;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.dosage,
    required this.applicationMethod,
    required this.stock,
    required this.usageHistory,
    this.price = 0.0,
    this.vat = 0.0,
  });
}
