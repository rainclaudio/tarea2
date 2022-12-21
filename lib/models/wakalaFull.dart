// To parse this JSON data, do
//
//     final wakalaFull = wakalaFullFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class WakalaFull {
    WakalaFull({
         this.id,
        required this.sector,
        required this.descripcion,
        required this.fechaPublicacion,
        required this.autor,
        required this.urlFoto1,
        required this.urlFoto2,
         this.sigueAhi,
         this.yaNoEsta,
         this.comentarios,
    });

    int? id;
    String? sector;
    String? descripcion;
    final String fechaPublicacion;
    final String autor;
     String urlFoto1;
     String urlFoto2;
     int? sigueAhi;
     int? yaNoEsta;
     List<Comentario>? comentarios;

    factory WakalaFull.fromJson(String str) => WakalaFull.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory WakalaFull.fromMap(Map<String, dynamic> json) => WakalaFull(
        id: json["id"],
        sector: json["sector"],
        descripcion: json["descripcion"],
        fechaPublicacion: json["fecha_publicacion"],
        autor: json["autor"],
        urlFoto1: json["url_foto1"],
        urlFoto2: json["url_foto2"],
        sigueAhi: json["sigue_ahi"],
        yaNoEsta: json["ya_no_esta"],
        comentarios: List<Comentario>.from(json["comentarios"].map((x) => Comentario.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "sector": sector,
        "descripcion": descripcion,
        "fecha_publicacion": fechaPublicacion,
        "autor": autor,
        "url_foto1": urlFoto1,
        "url_foto2": urlFoto2,
        "sigue_ahi": sigueAhi,
        "ya_no_esta": yaNoEsta,
        "comentarios": List<dynamic>.from(comentarios!.map((x) => x.toMap())),
    };
}



class Comentario {
    Comentario({
        required this.id,
        required this.descripcion,
        required this.fechaComentario,
        required this.autor,
    });

    final int id;
    final String descripcion;
    final String fechaComentario;
    final String autor;

    factory Comentario.fromJson(String str) => Comentario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Comentario.fromMap(Map<String, dynamic> json) => Comentario(
        id: json["id"],
        descripcion: json["descripcion"],
        fechaComentario: json["fecha_comentario"],
        autor: json["autor"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "descripcion": descripcion,
        "fecha_comentario": fechaComentario,
        "autor": autor,
    };
}

