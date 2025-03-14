import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../core/models/product.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../shared/themes/app_theme.dart';
import '../../core/models/product_usage.dart';

class ProductsScreen extends StatefulWidget {
  final MockDataService mockService;
  const ProductsScreen({super.key, required this.mockService});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late List<Product> _products;
  File? _image;

  @override
  void initState() {
    super.initState();
    _products = widget.mockService.products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Controle de Insumos")),
      body: Column(
        children: [
          Expanded(
            child:
                _products.isEmpty
                    ? const Center(child: Text("Nenhum insumo cadastrado"))
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _products.length,
                      itemBuilder: (ctx, i) {
                        final product = _products[i];
                        return _buildProductCard(context, product);
                      },
                    ),
          ),
          const SizedBox(height: 20),

          _image != null
              ? Image.file(_image!)
              : const Text('📸 Nenhuma nota fiscal escaneada'),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text("Capturar Nota Fiscal"),
            // backgroundColor: AppColors.primary,
            // child: const Icon(Icons.add, color: Colors.white),
            onPressed: _getImage,
          ),
        ],
      ),
    );
  }

  // 📌 Capturar Imagem da Nota Fiscal
  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _processImage();
    }
  }

  // 📌 Processar OCR da Nota Fiscal
  Future<void> _processImage() async {
    if (_image == null) return;

    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(_image!);
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    _extrairDadosNotaFiscal(recognizedText.text);
    textRecognizer.close();
  }

  // 📌 Extrair Produtos da Nota Fiscal
  void _extrairDadosNotaFiscal(String texto) {
    RegExp itemRegex = RegExp(
      r'([A-Z\s]+)\s+(\d+)\s+([\d,.]+)',
      multiLine: true,
    );

    List<Product> novosProdutos = [];
    for (Match match in itemRegex.allMatches(texto)) {
      novosProdutos.add(
        Product(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: match.group(1)?.trim() ?? "Produto Desconhecido",
          type:
              "Fertilizante", // 🛠️ **Melhoria futura: detectar o tipo automaticamente**
          dosage:
              double.tryParse(match.group(3)?.replaceAll(',', '.') ?? '0') ??
              0.0,
          applicationMethod: "Solo",
          stock: int.tryParse(match.group(2) ?? '1') ?? 1,
          usageHistory: [],
        ),
      );
    }

    setState(() {
      _products.addAll(novosProdutos);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${novosProdutos.length} produtos adicionados ao inventário",
        ),
      ),
    );
  }

  // 📌 Product Card UI
  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _getProductIcon(product.type),
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📌 Tipo: ${product.type}"),
            Text("💊 Dosagem: ${product.dosage} kg/L"),
            Text("🛠️ Aplicação: ${product.applicationMethod}"),
            Text(
              "📦 Estoque: ${product.stock} unidades",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: product.stock < 5 ? Colors.red : AppColors.primary,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          _showProductDetail(context, product);
        },
      ),
    );
  }

  // 📌 Get Icon Based on Product Type
  Widget _getProductIcon(String type) {
    switch (type.toLowerCase()) {
      case "fertilizante":
        return const Icon(Icons.grass, color: Colors.green);
      case "defensivo":
        return const Icon(Icons.shield, color: Colors.blue);
      case "semente":
        return const Icon(Icons.eco, color: Colors.brown);
      default:
        return const Icon(Icons.inventory, color: Colors.grey);
    }
  }

  // 📌 Show Product Details (Track Usage)
  void _showProductDetail(BuildContext context, Product product) {
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
                  product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildInfoRow("📌 Tipo", product.type),
                _buildInfoRow("💊 Dosagem", "${product.dosage} kg/L"),
                _buildInfoRow(
                  "🛠️ Método de Aplicação",
                  product.applicationMethod,
                ),
                _buildInfoRow("📦 Estoque", "${product.stock} unidades"),
                const SizedBox(height: 20),
                _buildUsageHistory(product),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_chart),
                  label: const Text("Registrar Novo Uso"),
                  onPressed: () {
                    _registerProductUsage(product);
                  },
                ),
              ],
            ),
          ),
    );
  }

  // 📌 Display Product Usage History
  Widget _buildUsageHistory(Product product) {
    if (product.usageHistory.isEmpty) {
      return const Text("📋 Nenhum uso registrado.");
    }

    return Column(
      children:
          product.usageHistory.map((usage) {
            return ListTile(
              leading: const Icon(Icons.history, color: Colors.orange),
              title: Text("Data: ${usage.date}"),
              subtitle: Text(
                "🌱 Parcela: ${usage.parcelName}\n📊 Dose: ${usage.dose} kg/L",
              ),
            );
          }).toList(),
    );
  }

  // 📌 Register New Product Usage
  void _registerProductUsage(Product product) {
    setState(() {
      product.usageHistory.add(
        ProductUsage(
          date: DateTime.now().toString().split(' ')[0],
          parcelName: "Parcela X",
          dose: product.dosage,
        ),
      );
    });
    Navigator.pop(context);
  }

  // 📌 Register New Product
  void _addNewProduct() {
    setState(() {
      widget.mockService.products.add(
        Product(
          id: DateTime.now().toString(),
          name: "Novo Insumo",
          type: "Fertilizante",
          dosage: 50.0,
          applicationMethod: "Solo",
          stock: 10,
          usageHistory: [],
        ),
      );
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
}
