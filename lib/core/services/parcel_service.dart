import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/parcel.dart';

class ParcelService {
  Future<List<Parcel>> fetchParcels() async {
    final response = await http.get(Uri.parse('https://your-api.com/parcels'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((parcel) => Parcel.fromJson(parcel)).toList();
    } else {
      throw Exception("Failed to load parcels");
    }
  }
}
