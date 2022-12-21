import 'dart:convert';
import 'dart:io';
// import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app1/models/models.dart';
import 'package:http/http.dart' as http;


class WakalaService extends ChangeNotifier {

  final String _baseUrl = '985cd18612e9.sa.ngrok.io';
  final List<WakalaItem> wakalas = [];
  late WakalaItem selectedWakala;
  late WakalaFull selectedWakalaFull;

  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  WakalaService() {
    loadWakalas();
  }

  Future<List<WakalaItem>> loadWakalas() async {
    isLoading = true;
    notifyListeners();

    // GET wakalas
    final url = Uri.https(_baseUrl, '/api/wuakalasApi/Getwuakalas');
    final resp = await http.get(url);

    final List<dynamic> produtsMap = json.decode(resp.body);
    // mapear y agregar al arreglo lcal
    produtsMap.forEach((key) {
      final tempWakala = WakalaItem.fromMap(key);
      // tempWakala.id = ;
      wakalas.add(tempWakala);
    });
    isLoading = false;
    notifyListeners();
    return wakalas;
  }

// este metodo me sirve para crear o actualizar un producto

  Future saveOrCreateWakala(WakalaFull wakala) async {
    isSaving = true;
    notifyListeners();
    if (wakala.id == null) {
      // es necesario crear
      await createProduct(wakala);
    } else {
      // actualizar
      await updateProduct(wakala);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<int> updateProduct(WakalaFull wakala) async {
    final url = Uri.https(_baseUrl, 'wakalas/${wakala.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    // tenemos un metodo ya habilitado con quick type
    // put: es para actualizar
    // ignore porque aqui hacemos la petitición
    // ignore: unused_local_variable
    final resp = await http.put(url, body: wakala.toJson());

    final index = wakalas.indexWhere((element) => element.id == wakala.id);
    //TODO: el update wakala en save or create product
    // wakalas[index] = wakala;

    return wakala.id!;
  }

  Future<int> createProduct(WakalaFull wakala) async {
    final url = Uri.https(_baseUrl, 'wakalas.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    // post es para crear
    final resp = await http.post(url, body: wakala.toJson());
    final decodedData = json.decode(resp.body);

    wakala.id = decodedData['name'];
    //TODO: el update wakala en save or create product

    // wakalas.add(wakala);

    return wakala.id!;
  }
  // TODO
  void updateSelectedProductImage(String path) {
    // yo se que es un archivo que existe porque tiene path
    selectedWakalaFull.urlFoto1 = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  /*
  Procedimiento para guardar la imagen en cloudinary
   */
  //todo: aquí guardar la imagen
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
  

  
  Future<WakalaFull> loadSelectedWakala() async{
    WakalaFull fullWakalaSelected;
    isLoading = true;
    // notifyListeners();

    final url =  Uri.parse(
          'https://985cd18612e9.sa.ngrok.io/api/wuakalasApi/Getwuakala/' +
              selectedWakala.id.toString());
  
    final resp = await http.get(url,headers: {"Content-Type": "application/json"});

 
    final Map<String,dynamic> wakalaJSON = json.decode(resp.body);
    // mapear y agregar al arreglo lcal
    selectedWakalaFull = WakalaFull.fromMap(wakalaJSON);
 
    isLoading = false;
    // notifyListeners();
    return selectedWakalaFull;
  }
}
