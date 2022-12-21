import 'dart:convert';
import 'dart:io';
// import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app1/models/models.dart';
import 'package:http/http.dart' as http;

File? newPictureFile;

class ProductService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-ab2ab-default-rtdb.firebaseio.com';

  final List<Product> products = [];
  late Product selectedProduct;

  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductService() {
    loadProducts();
  }
  // todo: <list<product>>
  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    // GET products
    final url = Uri.https(_baseUrl, 'products.json', {
      // aquí va el argumento de el token
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.get(url, headers: {});

    final Map<String, dynamic> produtsMap = json.decode(resp.body);
    // mapear y agregar al arreglo lcal
    produtsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();
    return products;
  }

// este metodo me sirve para crear o actualizar un producto

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      // es necesario crear
      await createProduct(product);
    } else {
      // actualizar
      await updateProduct(product);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    // tenemos un metodo ya habilitado con quick type
    // put: es para actualizar
    // ignore porque aqui hacemos la petitición
    // ignore: unused_local_variable
    final resp = await http.put(url, body: product.toJson());

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    // post es para crear
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];
    products.add(product);

    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    // yo se que es un archivo que existe porque tiene path
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  /*
  Procedimiento para guardar la imagen en cloudinary
   */
  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dkndekypu/image/upload?upload_preset=flutterImages');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
