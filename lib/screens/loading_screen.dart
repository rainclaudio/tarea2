import 'package:flutter/material.dart';

// Función: se encarga de mostrar un loading a modo de pantalla completa, es decir, cubré todo lo demás y cuando
// finaliza la carga, desaparece.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.indigo,
          ),
        ));
  }
}
