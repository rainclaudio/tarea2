import 'package:productos_app1/screens/screens.dart';
import 'package:productos_app1/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

// podemos tener acceso a los productos en cualquier widget de la aplicación, partiendo desde el punto más alto que es MyApp
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // podemos alojar más de un provider
        ChangeNotifierProvider(
          create: (_) => ProductService(),
        ),
        // podemos llamarlo donde necesitemos
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => WakalaService(),
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        'checking': (_) => const CheckAuthScreen(),
        'home': (_) => const HomeScreen(),
        'login': (_) => const LoginScreen(),
        'wakala': (_) => const WakalaScreen(),
        'new_wakala': (_) => const NewWakalaScreen(),
        'register': (_) => const RegisterScreen(),
      },
      // ahora en cualquier lado de la aplicación yo puedo mostrar las notificaciones
      scaffoldMessengerKey: NotificationsServices.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo, elevation: 0)),
    );
  }
}
