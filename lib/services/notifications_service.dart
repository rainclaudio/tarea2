import 'package:flutter/material.dart';

export 'package:flutter/material.dart';

class NotificationsServices {
  // me ayudaraá a mantener la referencia a un widget en particular que es el material app
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ));
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
