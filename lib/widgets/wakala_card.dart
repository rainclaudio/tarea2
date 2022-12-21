import 'package:flutter/material.dart';
import 'package:productos_app1/models/models.dart';

// estamos usando solo statless widge

class WakalaCard extends StatelessWidget {
  final WakalaItem wakala;

  const WakalaCard({Key? key, required this.wakala}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 5),
        width: double.infinity,
        height: 200, 
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // _BackgroundImage(wakala: wakala),
            _WakalaDetails(
              wakala: wakala,
            ),
            Positioned(top: 0, right: 0, child: _PriceTag(wakala: wakala)),
           
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


class _PriceTag extends StatelessWidget {
  final WakalaItem wakala;

  // ignore: unused_element
  const _PriceTag({Key? key, required this.wakala});
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
            child: Text('\$${wakala.autor}',
                style: const TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ));
  }
}

class _WakalaDetails extends StatelessWidget {
  final WakalaItem wakala;
  const _WakalaDetails({
    Key? key,
    required this.wakala,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        // Sacamos esa aberración de mostrar la id y reducimos el tamaño
        height: 100,
        decoration: _buildBoxDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            wakala.sector +'\n' + wakala.fecha,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Text(
          //   wakala.id != null ? wakala.id! : '',
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
// TODO: el fondo de la imagen
/* 
class _BackgroundImage extends StatelessWidget {
  final WakalaItem wakala;
  const _BackgroundImage({
    Key? key,
    required this.wakala,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
          width: double.infinity,
          height: 400,
          // si el producto fetcheado no posee imagen, de dejamos una imagen por defecto
          child: wakala.picture == null
              // ignore: prefer_const_constructors
              ? Image(
                  image: const AssetImage('assets/no-image.png'),
                  fit: BoxFit.cover,
                )
              : FadeInImage(
                  // todo: productos sin imagenes
                  placeholder: const AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(wakala.picture!),
                  fit: BoxFit.cover,
                )),
    );
  }
}
*/