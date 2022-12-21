import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:productos_app1/UI/input_decorations.dart';
import 'package:productos_app1/providers/product_provider.dart';
import 'package:productos_app1/services/products_service.dart';

import 'package:productos_app1/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

/*
    Problema: necesito crear la instancia del product form provider ¿en qué lugar la coloco? 
    respuesta: tiene que ser en esta misma screen ¿en qué parte? por ejemplo si pongo el provider dentro del 
    product form, dejaría la opción de subir la imagen fuer a del provider, lo que no es bueno

    por lo que tenemos que subir un NIVEL:
      1. creamos un body para todo lo que teníamos anteriormente: _product screen body
      2. wrapeamos el screenbody con un changenotifierprovider  y le pasamos el ProductFormProvider

      Así tenemos acceso a todo el provider desde el _productScreenBody
  */
class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductsScreenBody(productService: productService),
    );
  }
}

class _ProductsScreenBody extends StatelessWidget {
  const _ProductsScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

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
                  ProductImage(url: productService.selectedProduct.picture),
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
                          productService
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
      // posición: esquina inferior derecha
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        // Icono
        // si la imagen está en proceso de guardado, no se ejecuta la función
        onPressed: productService.isSaving
            ? null
            : () async {
                // Aquí verifica si lo que está en el widget _ProductForm(), es válido. Por favor, echarle un ojo
                productForm.isValidForm();
                // si no es válido
                if (!productForm.isValidForm()) return;
                // llamar a service para que guarde la imagen en cloudinary
                // ignore: unused_local_variable
                final String? imageUrl = await productService.uploadImage();

                if (imageUrl != null) productForm.product.picture = imageUrl;

                // llamar a service para que guarde la descripción en firebase
                await productService.saveOrCreateProduct(productForm.product);
              },
        // Icono: si la imagen está en proceso de guardado, el icono cambia a status loading
        child: productService.isSaving
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
    final productForm = Provider.of<ProductFormProvider>(context);
    // aquí estamos accediento el product del provider. ahora toca rellenar los valores de nombre, precio, etc
    // IMPORTANTE:  recuerde que todo es manejado por referencia, no es como si product fuese una copia, sino que el objeto original
    final product = productForm.product;
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
            key: productForm.formKey,
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
                  initialValue: product.name,
                  // aquí estamos llamando al provider para cambiar el nombre
                  onChanged: (value) => product.name = value,
                  // un validador de texto
                  validator: (value) {
                    // el or es con ctrl más 1 || pero el ctrl de la derecha
                    if (value == null || value.isEmpty) {
                      return 'el nombre es obligatorio';
                    }
                    return null;
                  },
                  // objeto tipo decoración: importante crear como método para ahorrar espacio
                  decoration: InputsDecorations.authInputDecoration(
                      hintText: 'Nombre del producto', labelText: 'Nombre'),
                ),
                // espacio extra
                const SizedBox(
                  height: 30,
                ),
                // Input tipo texto
                TextFormField(
                  // tipo de teclado
                  keyboardType: TextInputType.number,
                  // así aceptamos solo números con dos decimales
                  inputFormatters: [
                    // esto es para que coincida con numeros puntos y decimales
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  // valor inicial obtenido del provider
                  initialValue: '${product.price}',
                  onChanged: (value) => {
                    // tryparse puede tomar cualquier valor
                    if (double.tryParse(value) == null)
                      {product.price = 0}
                    else
                      {product.price = double.parse(value)}
                  },
                  validator: (value) {
                    // el or es con ctrl más 1 || pero el ctrl de la derecha
                    if (value == null || value.isEmpty) {
                      return 'el precio es obligatorio';
                    }
                    return null;
                  },
                  // objeto tipo decoración: importante crear como método para ahorrar espacio
                  decoration: InputsDecorations.authInputDecoration(
                      hintText: '\$150', labelText: 'Precio'),
                ),
                // expacio extra
                const SizedBox(
                  height: 30,
                ),
                // Input tipo switch
                SwitchListTile.adaptive(
                    // valor obtenido del provider
                    value: product.available,
                    title: const Text('Disponible'),
                    activeColor: Colors.indigo,
                    // llamamos al provider
                    onChanged: (value) => productForm.updateAviability(value)),
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
