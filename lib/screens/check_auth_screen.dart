import 'package:productos_app1/screens/screens.dart';
import 'package:productos_app1/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        // No entiendo que es el future builder
        child: FutureBuilder(
            future: authService.readToken(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) return const Text('e');
              // hay que sacar al usuario de la pantalla
              if (snapshot.data == '') {
                Future.microtask(() {
                  // no se ve natural que nos loguemos como si cambiaramos hacia al lado de pantalla
                  // si no que directamente salta a la información: por ello vamos a modificar la volaita
                  // Navigator.of(context).pushReplacementNamed('login');

                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const LoginScreen(),
                          transitionDuration: const Duration(seconds: 0)));
                });
              } else {
                // el micro task ayuda a ejecutar en cuanto podamos
                Future.microtask(() {
                  // no se ve natural que nos loguemos como si cambiaramos hacia al lado de pantalla
                  // si no que directamente salta a la información: por ello vamos a modificar la volaita
                  // Navigator.of(context).pushReplacementNamed('login');

                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const HomeScreen(),
                          transitionDuration: const Duration(seconds: 0)));
                });
              }
              return Container();
            }),
      ),
    );
  }
}
