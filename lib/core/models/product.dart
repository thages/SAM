import 'product_usage.dart';

class Product {
  final String id;
  final String name;
  final String type;
  final double dosage;
  final String applicationMethod;
  final int quantity;
  final double price;
  final double vat;
  final List<ProductUsage> usageHistory;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.dosage,
    required this.applicationMethod,
    required this.quantity,
    required this.usageHistory,
    this.price = 0.0,
    this.vat = 0.0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: json["name"] ?? "Produto Desconhecido",
      type: json["type"] ?? "Outros",
      dosage: (json["dosage"] as num?)?.toDouble() ?? 50.0,
      applicationMethod: json["applicationMethod"] ?? "Solo",
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      vat: (json["vat"] as num?)?.toDouble() ?? 0.0,
      quantity: (json["quantity"] as num?)?.toInt() ?? 1,
      usageHistory:
          (json["usageHistory"] as List<dynamic>?)
              ?.map((e) => ProductUsage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "dosage": dosage,
      "applicationMethod": applicationMethod,
      "price": price,
      "vat": vat,
      "quantity": quantity,
      "usageHistory": usageHistory,
    };
  }
}
