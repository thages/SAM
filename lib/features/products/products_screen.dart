import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../core/models/product.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../shared/themes/app_theme.dart';
import '../../core/models/product_usage.dart';
import '../../shared/components/loading_animation_loop.dart';

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
      body: Stack(
        children: [
          Column(
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
                onPressed: _getImage,
              ),
            ],
          ),
          // Loading animation overlay
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.9),
              child: const Center(
                child: LoadingAnimationLoop(
                  lottieFiles: [
                    'assets/lottie/photo-in-reveal.json',
                    'assets/lottie/document-hover-unfold.json',
                    'assets/lottie/layers-in-reveal.json',
                  ],
                  duration: Duration(seconds: 3),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _processImageWithOpenAI();
    }
  }

  bool _isLoading = false;

  Future<void> _processImageWithOpenAI() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true; // Start loading
    });
    var local = "http://192.168.3.20:5185";
    var apiUrl = "https://sam-api-e6pj.onrender.com";
    var uri = Uri.parse("$apiUrl/api/v1/Products/UploadImage");
    var request = http.MultipartRequest("POST", uri);

    // Attach the image file
    request.files.add(await http.MultipartFile.fromPath("file", _image!.path));

    _image = null;

    var streamedResponse = await request.send();

    // Convert streamed response to String
    var responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode == 200) {
      try {
        _extrairDadosNotaFiscal(responseBody);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao processar resposta: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao processar imagem: $responseBody")),
      );
    }
  }

  void _extrairDadosNotaFiscal(String jsonData) {
    try {
      List<dynamic> decodedList = jsonDecode(jsonData);

      List<Product> novosProdutos =
          decodedList.map<Product>((item) => Product.fromJson(item)).toList();

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
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao processar JSON: $e")));
    }
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(_image!);
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    _extrairDadosNotaFiscalORCgoogle(recognizedText.text);
    textRecognizer.close();

    setState(() {
      _image = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produtos extraídos e adicionados!")),
    );
  }

  void _extrairDadosNotaFiscalORCgoogle(String texto) {
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
          price: 0.0,
          vat: 10.0,
          quantity: int.tryParse(match.group(2) ?? '1') ?? 1,
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
            Text("💰 Preço: ${product.price.toStringAsFixed(2)} \$"),
            Text("🏦 IVA: ${product.vat} %"),
            Text(
              "📦 Estoque: ${product.quantity} unidades",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: product.quantity < 5 ? Colors.red : AppColors.primary,
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
                _buildInfoRow("📦 Estoque", "${product.quantity} unidades"),
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
                "🌱 Talhão: ${usage.parcelName}\n📊 Dose: ${usage.dose} kg/L",
              ),
            );
          }).toList(),
    );
  }

  void _registerProductUsage(Product product) {
    setState(() {
      product.usageHistory.add(
        ProductUsage(
          date: DateTime.now().toString().split(' ')[0],
          parcelName: "Talhão X",
          dose: product.dosage,
        ),
      );
    });
    Navigator.pop(context);
  }

  void _addNewProduct() {
    setState(() {
      widget.mockService.products.add(
        Product(
          id: DateTime.now().toString(),
          name: "Novo Insumo",
          type: "Fertilizante",
          dosage: 50.0,
          applicationMethod: "Solo",
          quantity: 10,
          usageHistory: [],
        ),
      );
    });
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
