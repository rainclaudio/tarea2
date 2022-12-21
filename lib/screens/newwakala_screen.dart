import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app1/providers/wakalas_provider.dart';
import 'package:productos_app1/services/wakalas_service.dart';

import 'package:provider/provider.dart';

import 'package:productos_app1/UI/input_decorations.dart';
import 'package:productos_app1/providers/product_provider.dart';
import 'package:productos_app1/services/products_service.dart';

import 'package:productos_app1/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

/*
    Problema: necesito crear la instancia del wakala form provider ¿en qué lugar la coloco? 
    respuesta: tiene que ser en esta misma screen ¿en qué parte? por ejemplo si pongo el provider dentro del 
    wakala form, dejaría la opción de subir la imagen fuer a del provider, lo que no es bueno

    por lo que tenemos que subir un NIVEL:
      1. creamos un body para todo lo que teníamos anteriormente: _product screen body
      2. wrapeamos el screenbody con un changenotifierprovider  y le pasamos el WakalasFormProvider

      Así tenemos acceso a todo el provider desde el _productScreenBody
  */
class NewWakalaScreen extends StatelessWidget {
  const NewWakalaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wakalaService = Provider.of<WakalaService>(context);
    return ChangeNotifierProvider(
      create: (_) => WakalasFormProvider(wakalaService.selectedWakalaFull),
      child: _WakalaScreenBody(wakalaService: wakalaService),
    );
  }
}

class _WakalaScreenBody extends StatelessWidget {
  const _WakalaScreenBody({
    Key? key,
    required this.wakalaService,
  }) : super(key: key);

  final WakalaService wakalaService;

  @override
  Widget build(BuildContext context) {
    final wakalaForm = Provider.of<WakalasFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
          // una vez que hago scroll en la pantalla, el teclado se oculta
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            // Aquí se está renderizando la parte de la imagen con los botones sobre ella
            children: [
              // para posicionar objetos uno encima de otro
              Stack(
                children: [
                  // imagen
                  ProductImage(url: wakalaService.selectedWakalaFull.urlFoto1),
                  // botón para regresar a la home page
                  Positioned(
                      top: 60,
                      left: 20,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new,
                            size: 40, color: Colors.white),
                      )),
                  // botón para subir una imagen
                  Positioned(
                      top: 60,
                      right: 20,
                      child: IconButton(
                        onPressed: () async {
                          // aquí seleccionamos una imagen desde la cámara o galería

                          final picker = ImagePicker();
                          // final PickedFile? pickedFile = await picker.getImage(
                          //     source: ImageSource.gallery, imageQuality: 100);

                          // El de arriba estaba depprecated por lo que cambiamos a pickImage:
                          // revisar esta línea si el code falla
                          // final XFile? pickedFile = await picker.pickImage(
                          //     source: ImageSource.gallery, imageQuality: 100);

                          final PickedFile? pickedFile = await picker.getImage(
                              source: ImageSource.gallery,
                              // source: ImageSource.camera,
                              imageQuality: 100);

                          if (pickedFile == null) {
                            return;
                            // throw Error();
                          }
                          // print("tenemos imagen ${pickedFile.path}");
                          // mandar la imagen al service - redibujará el árbol de widgets correspondiente al product_screen
                          // fijate que arriba aparece ProductImage() el cual se ocupa del image que subes en esta función
                          wakalaService
                              .updateSelectedProductImage(pickedFile.path);
                        },
                        icon: const Icon(Icons.camera_alt_outlined,
                            size: 40, color: Colors.white),
                      )),
                ],
              ),
              // Aquí tenemos el formulario para modificar los valores
              const _ProductForm(),
              // expacio extra
              const SizedBox(
                height: 100,
              )
            ],
          )),
      /* Ícono: guardar producto*/
      // posición: esquina  derecha
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        // Icono
        // si la imagen está en proceso de guardado, no se ejecuta la función
        onPressed: wakalaService.isSaving
            ? null
            : () async {
                // Aquí verifica si lo que está en el widget _ProductForm(), es válido. Por favor, echarle un ojo
                wakalaForm.isValidForm();
                // si no es válido
                if (!wakalaForm.isValidForm()) return;
                // llamar a service para que guarde la imagen en cloudinary
                // ignore: unused_local_variable
                final String? imageUrl = await wakalaService.uploadImage();

                if (imageUrl != null) wakalaForm.wakala.urlFoto1 = imageUrl;

                // llamar a service para que guarde la descripción en firebase
                await wakalaService.saveOrCreateWakala(wakalaForm.wakala);
              },
        // Icono: si la imagen está en proceso de guardado, el icono cambia a status loading
        child: wakalaService.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.save_outlined),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // aquí estamos accediento al provider
    final wakalaForm = Provider.of<WakalasFormProvider>(context);
    // aquí estamos accediento el wakala del provider. ahora toca rellenar los valores de nombre, precio, etc
    // IMPORTANTE:  recuerde que todo es manejado por referencia, no es como si wakala fuese una copia, sino que el objeto original
    final wakala = wakalaForm.wakala;
    return Padding(
      // padding padding de tarjeta (?)
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        // padding dentro de tarjeta (?)
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        // objeto tipo decoration: importante dejarlo como un método para ahorrar espacio
        decoration: _buildBoxDecoration(),
        /* FORMULARIO:  */
        child: Form(
            key: wakalaForm.formKey,
            // validar cuando el usuario está escribiendo
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                // espacio
                const SizedBox(
                  height: 10,
                ),
                // Form tipo texto
                TextFormField(
                  initialValue: wakala.sector,
                  // aquí estamos llamando al provider para cambiar el nombre
                  onChanged: (value) => wakala.sector = value,
                  // un validador de texto
                  validator: (value) {
                    // el or es con ctrl más 1 || pero el ctrl de la derecha
                    if (value == null || value.isEmpty) {
                      return 'Sector es obligatorio';
                    }
                    return null;
                  },
                  // objeto tipo decoración: importante crear como método para ahorrar espacio
                  decoration: InputsDecorations.authInputDecoration(
                      hintText: 'Sector', labelText: 'Sector'),
                ),
                // espacio extra
                // Input tipo texto
               
                // expacio extra
                const SizedBox(
                  height: 30,
                ),
              
                Container(
                  height: 220,
                  child: TextFormField(
                    maxLines: 420,
                    keyboardType: TextInputType.multiline,
                    initialValue: wakala.descripcion,
                    onChanged: (value) => wakala.descripcion = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'por favor añada contenido';
                      }
                      return null;
                    },
                    decoration: InputsDecorations.authInputDecoration(
                    hintText: 'Descripción',labelText: 'Descripción')),
                ),
         
                const SizedBox(
                  height: 30,
                )
              ],
            )
            ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            blurRadius: 5,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5))
      ],
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)));
}
