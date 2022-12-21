import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidForm() {
    // print(formKey.currentState?.validate());
    return formKey.currentState?.validate() ?? false;
  }
}
