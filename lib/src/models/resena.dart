// To parse this JSON data, do
//
//     final resena = resenaFromJson(jsonString);

import 'dart:convert';

Resena resenaFromJson(String str) => Resena.fromJson(json.decode(str));

String resenaToJson(Resena data) => json.encode(data.toJson());

class Resena {
  String id;
  String restauranteId;
  String usuarioId;
  String titulo;
  String texto;
  int calificacion;
  DateTime fecha;

  Resena({
    required this.id,
    required this.restauranteId,
    required this.usuarioId,
    required this.titulo,
    required this.texto,
    required this.calificacion,
    required this.fecha,
  });

  factory Resena.fromJson(Map<String, dynamic> json) => Resena(
        id: json["id"],
        restauranteId: json["restaurante_id"],
        usuarioId: json["usuario_id"],
        titulo: json["titulo"],
        texto: json["texto"],
        calificacion: json["calificacion"],
        fecha: DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "restaurante_id": restauranteId,
        "usuario_id": usuarioId,
        "titulo": titulo,
        "texto": texto,
        "calificacion": calificacion,
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
      };
}
