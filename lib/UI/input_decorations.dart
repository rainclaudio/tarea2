import 'package:flutter/material.dart';

class InputsDecorations {
  static InputDecoration authInputDecoration(
      {required String hintText,
       String? labelText,
      IconData? prefixIcon}) {
    return InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        // Aquí va la ayuda: 'hola@123.com'
        hintText: hintText,
        // aquí va la etiqueta: 'Correo electrónico'
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        // Aquí va el Icon
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.deepPurple,
              )
            : null);
  }
}
