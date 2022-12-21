import 'package:flutter/material.dart';
import 'package:productos_app1/models/models.dart';

// estamos usando solo statless widge

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(product: product),
            _ProductDetails(
              product: product,
            ),
            Positioned(top: 0, right: 0, child: _PriceTag(product: product)),
            if (!product.available)
              Positioned(
                  top: 0, left: 0, child: _NotAvailable(product: product)),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 6),
              color: Colors.black12,
            )
          ]);
}

class _NotAvailable extends StatelessWidget {
  final Product product;
  const _NotAvailable({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No disponible',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final Product product;

  // ignore: unused_element
  const _PriceTag({Key? key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))),
        child: FittedBox(
          // fittedbox: Ayuda a definir como quieres que se adapte el widget interno
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('\$${product.price}',
                style: const TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ));
  }
}

class _ProductDetails extends StatelessWidget {
  final Product product;
  const _ProductDetails({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        // Sacamos esa aberración de mostrar la id y reducimos el tamaño
        height: 50,
        decoration: _buildBoxDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Text(
          //   product.id != null ? product.id! : '',
          //   style: const TextStyle(
          //     fontSize: 15,
          //     color: Colors.white,
          //   ),
          // ),
        ]),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), topRight: Radius.circular(25)),
      );
}

class _BackgroundImage extends StatelessWidget {
  final Product product;
  const _BackgroundImage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
          width: double.infinity,
          height: 400,
          // si el producto fetcheado no posee imagen, de dejamos una imagen por defecto
          child: product.picture == null
              // ignore: prefer_const_constructors
              ? Image(
                  image: const AssetImage('assets/no-image.png'),
                  fit: BoxFit.cover,
                )
              : FadeInImage(
                  // todo: productos sin imagenes
                  placeholder: const AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(product.picture!),
                  fit: BoxFit.cover,
                )),
    );
  }
}
