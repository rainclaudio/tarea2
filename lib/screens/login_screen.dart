import 'package:productos_app1/UI/input_decorations.dart';
import 'package:productos_app1/providers/login_form_provider.dart';
import 'package:productos_app1/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 160,
          ),
          CardContainer(
            child: Column(
              children: [
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'Ingreso',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 20,
                ),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: const _LoginForm(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'register'),
              style: ButtonStyle(
                  // cuando es clickeado, se muestra una pantalla en color indigo
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  // esto es para que aparezcan border redondeados
                  shape: MaterialStateProperty.all(const StadiumBorder())),
              child: const Text(
                'Crear una nueva cuenta',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              )),
          const SizedBox(
            height: 50,
          ),
        ]),
      )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,

      autovalidateMode: AutovalidateMode.onUserInteraction,

      // todo: mantenr la referencia aqui
      child: Column(children: [
        TextFormField(
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputsDecorations.authInputDecoration(
              hintText: 'john.doe@gmail.com',
              labelText: 'Correo Electrónico',
              prefixIcon: Icons.mail_sharp),
          onChanged: (value) => loginForm.email = value,
          validator: (value) {
            // expresión regular que evalua si el input ingresado es un correo electrónico válido
            String pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regExp = RegExp(pattern);
            return regExp.hasMatch(value ?? '')
                ? null
                : 'Correo electrónico no válido';
          },
        ),
        const SizedBox(
          height: 30,
        ),
        TextFormField(
          autocorrect: false,
          obscureText: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputsDecorations.authInputDecoration(
              hintText: '******',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline),
          onChanged: (value) => loginForm.password = value,
          validator: (value) {
            if (value != null && value.length >= 6) return null;
            return 'La contraseña debe de ser de a lo menos 6 caracteres';
          },
        ),
        const SizedBox(
          height: 30,
        ),
        MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    // instancia de authservice: hay que dejar el listen en false porque no se puede escuchar dentro de un método
                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;

                  

                    final String? respuesta = await authService.login(
                        loginForm.email, loginForm.password);

                    // si hay algo en la respuesta, significa que nos ha retornado un error (ex: email already exists)
                    if (respuesta == null) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      // todo: mostrar error en pantalla
                      // print(respuesta);
                      NotificationsServices.showSnackbar(respuesta);
                      loginForm.isLoading = false;
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading ? 'Expere..' : 'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ))
      ]),
    );
  }
}
