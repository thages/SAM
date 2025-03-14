import 'package:flutter/material.dart';
import '../../../core/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Insumo: ${product.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('ID: ${product.id}'),
            Text('Tipo: ${product.type}'),
            Text('Dosagem Recomendada: ${product.dosage}'),
          ],
        ),
      ),
    );
  }
}
