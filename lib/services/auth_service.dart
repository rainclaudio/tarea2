import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {

  final String _baseUrl = '985cd18612e9.sa.ngrok.io';
 // final String _firebaseToken = 'AIzaSyBeEsEhRzTzi1OFtgKdLC1vQEY76B-MmCU';

  final storage = const FlutterSecureStorage();

// si retornamos algo, será un error, si no todo, bien
  Future<String?> createUser(String email, String password, String nombre) async {
   
    final Map authData = {
      'email': email,
      'pass': password,
      'nombre': nombre
    };

    final url =
        Uri.https(_baseUrl, '/api/usuariosApi/Postusuarios');

    // final resp = await http.post(url, body: json.encode(authData));
    // final Map<String, dynamic> decodedResp = json.decode(resp.body);
    final data_to_send = json.encode(authData);
    final resp = await http.post(url,headers: {"Content-Type": "application/json"},body: data_to_send);

    final Map<String, dynamic> decodedResp = json.decode(resp.body);
   
    if (resp.statusCode == 201) {
      storage.write(key: 'email', value: decodedResp['email']);
      // tenemos que grabar el token en un lugar seguro
      // return decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
  
    final url =  Uri.parse(
          'https://985cd18612e9.sa.ngrok.io/api/usuariosApi/GetUsuario?email=' +
              email +
              '&password=' +
              password);
  
    final resp = await http.get(url,headers: {"Content-Type": "application/json"});


    if (resp.statusCode == 200) {
      // tenemos que grabar el token en un lugar seguro
      // return decodedResp['idToken'];
       final Map<String, dynamic> decodedResp = json.decode(resp.body);
      storage.write(key: 'email', value: decodedResp['email']);
      return null;
    } else {
      return resp.reasonPhrase;
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return null;
  }

// verificamos si tenemos token
  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
