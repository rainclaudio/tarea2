import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
class ProductImage extends StatelessWidget {
  final String? url;

  const ProductImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 250,
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              child: getImage(url)),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      color: Colors.black,
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5))
      ],
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(45), topRight: Radius.circular(45)));

  Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  } 

  Widget getImage(String? picture) {
    /*
    Función GET IMAGE: 
    es un handler que nos ayuda subir  una imagen proveniente de un http o desde el teléfono,

    Old Comentaries(para bitácora): 
    Esto funciona bien en el emulador de chrome porque efectivamente es un network image
    también en emuladores de ios o android porque no son network images
  */
    if (picture == null)
      // ignore: curly_braces_in_flow_control_structures
      return const Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );

    if (picture.length != 0){
      // ignore: curly_braces_in_flow_control_structures
      return FadeInImage(
        image: NetworkImage('https://985cd18612e9.sa.ngrok.io/images/'+url!),
        placeholder: const AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover,
      );
    }
 
      return const Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );
    
  }
}
