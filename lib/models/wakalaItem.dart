// To parse this JSON data, do
//
//     final wakalas = wakalasFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class WakalaItem {
    WakalaItem({
         this.id,
        required this.sector,
        required this.autor,
        required this.fecha,
    });

     int? id;
     String sector;
     String autor;
     String fecha;

    factory WakalaItem.fromJson(String str) => WakalaItem.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory WakalaItem.fromMap(Map<String, dynamic> json) => WakalaItem(
        id: json["id"],
        sector: json["sector"],
        autor: json["autor"],
        fecha: json["fecha"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "sector": sector,
        "autor": autor,
        "fecha": fecha,
    };
    WakalaItem copy() => WakalaItem(
       sector: sector, autor: autor, fecha: fecha, id: id);
}


