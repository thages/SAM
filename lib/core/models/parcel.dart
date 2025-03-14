import '../models/parcel_detail.dart';

class Parcel {
  final String id;
  final String name;
  final double production;
  final double cost;
  final double revenue;
  final double costPerHectare;
  final double temperature;
  final double rainfall;
  final double machineEfficiency;
  final ParcelDetail detail;

  Parcel({
    required this.id,
    required this.name,
    required this.production,
    required this.cost,
    required this.revenue,
    required this.costPerHectare,
    required this.temperature,
    required this.rainfall,
    required this.machineEfficiency,
    required this.detail,
  });

  factory Parcel.fromJson(Map<String, dynamic> json) {
    return Parcel(
      id: json['id'],
      name: json['name'],
      production: json['production'].toDouble(),
      cost: json['cost'].toDouble(),
      revenue: json['revenue'].toDouble(),
      costPerHectare: json['costPerHectare'].toDouble(),
      temperature: json['temperature'].toDouble(),
      rainfall: json['rainfall'].toDouble(),
      machineEfficiency: json['machineEfficiency'].toDouble(),
      detail: ParcelDetail.fromJson(json['detail']),
    );
  }
}

// class Parcel {
//   final String id;
//   final String name;
//   final double area;
//   final String soilType;
//   final String culture;

//   Parcel({
//     required this.id,
//     required this.name,
//     required this.area,
//     required this.soilType,
//     required this.culture,
//   });
// }
