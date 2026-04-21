import 'dart:convert';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _barcodeController = TextEditingController();
  String _productInfo = '';
  bool _isLoading = false;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0],
          ResolutionPreset.medium,
        );
        await _cameraController!.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _scanBarcode() async {
    if (!_isCameraInitialized) {
      setState(() {
        _productInfo = 'Camera not initialized.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _productInfo = '';
    });

    try {
      final image = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final barcodeScanner = BarcodeScanner();
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        final barcodeValue =
            barcodes.first.displayValue ?? barcodes.first.rawValue;
        if (barcodeValue != null && barcodeValue.isNotEmpty) {
          _searchProduct(barcodeValue);
        } else {
          setState(() {
            _productInfo = 'Barcode detected but no value.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _productInfo = 'No barcode detected.';
          _isLoading = false;
        });
      }

      barcodeScanner.close();
    } catch (e) {
      setState(() {
        _productInfo = 'Error scanning: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchProduct(String barcode) async {
    if (barcode.isEmpty) return;

    setState(() {
      _isLoading = true;
      _productInfo = '';
    });

    try {
      final url = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          final product = data['product'];
          final name = product['product_name'] ?? 'Unknown';
          final description =
              product['ingredients_text'] ??
              product['generic_name'] ??
              'No description available';
          final brands = product['brands'] ?? '';
          final categories = product['categories'] ?? '';
          setState(() {
            _productInfo =
                'Name: $name\nBrands: $brands\nCategories: $categories\nDescription: $description';
          });
        } else {
          setState(() {
            _productInfo = 'Product not found.';
          });
        }
      } else {
        setState(() {
          _productInfo = 'Error fetching product: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _productInfo = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenwith = MediaQuery.of(context).size.width;
    final isDesktop = screenwith >= 1200;
    final isTablet = screenwith >= 768 && screenwith < 1200;
    final isMobile = screenwith < 768;

    return Scaffold(
      drawer: Drawer(
        width: min(screenwith * 0.7, 200),
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Text('Menu'),
            ),
            ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard')),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
          ],
        ),
      ),

      body: Row(
        children: [
          if (isDesktop) ...[
            Container(
              width: 200,
              color: Colors.white,
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.dashboard_outlined),
                    title: Text('Dashboard'),
                  ),
                  ListTile(
                    leading: Icon(Icons.inventory),
                    title: Text('Inventory'),
                  ),
                  ListTile(
                    leading: Icon(Icons.bar_chart),
                    title: Text('Sales'),
                  ),
                ],
              ),
            ),
          ] else if (isTablet) ...[
            Container(
              width: 100,
              color: Colors.white,
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.dashboard)),
                  ListTile(leading: Icon(Icons.settings)),
                ],
              ),
            ),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (isMobile) ...[
                      Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(Icons.menu, color: Colors.black),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                    ],
                    Expanded(
                      child: Container(
                        height: isMobile ? 50 : 70,
                        color: Colors.grey[200],
                        child: const Center(child: Text('Header')),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Barcode Product Search',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _barcodeController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Barcode (or scan below)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => _searchProduct(
                                        _barcodeController.text.trim(),
                                      ),
                                child: const Text('Search Product'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _scanBarcode,
                                child: const Text('Scan Barcode'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_productInfo.isNotEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                'Product Info:\n$_productInfo',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
