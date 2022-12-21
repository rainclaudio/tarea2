import 'package:flutter/material.dart';
import 'package:productos_app1/models/models.dart';

class WakalasFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
// una nueva instancia para alojar el valor del producto seleccionado
  WakalaFull wakala;
  // importante que este valor sea una copia y no el original PORQUE TODOS LOS ELEMENTOS SE PASAN POR REFERENCIA
  WakalasFormProvider(this.wakala);

  updateAviability(bool value) {
    // print(value);
   // product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    // print(product.name);
    // print(product.price);
    // print(product.available);
    return formKey.currentState?.validate() ?? false;
  }
}
