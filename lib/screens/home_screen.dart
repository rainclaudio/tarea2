import 'package:productos_app1/screens/screens.dart';
import 'package:productos_app1/services/services.dart';
import 'package:productos_app1/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)  {
    final productsService = Provider.of<ProductService>(context);
    final wakalaService = Provider.of<WakalaService>(context);
    // no necesitamoos que redibuje widgets por lo que le ponemos el listen en false
    final authService = Provider.of<AuthService>(context, listen: false);

    if (productsService.isLoading) return const LoadingScreen();
    if (wakalaService.isLoading) return const LoadingScreen();
    
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wakalas'),
          // este es un botón para que nos podamos desloguear
          leading: IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ),
        body: ListView.builder(
            itemCount: wakalaService.wakalas.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: ()  {
                  wakalaService.selectedWakala =
                      wakalaService.wakalas[index].copy();

                    Navigator.pushReplacementNamed(context, 'wakala');
                },
                child: WakalaCard(
                  wakala: wakalaService.wakalas[index],
                ))),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            // creación de un dummy product
            wakalaService.selectedWakalaFull = WakalaFull(sector: '', descripcion: '', fechaPublicacion: '', autor: '', urlFoto1: '', urlFoto2: '');
            Navigator.pushNamed(context, 'new_wakala');
          },
        ));
  }
}
