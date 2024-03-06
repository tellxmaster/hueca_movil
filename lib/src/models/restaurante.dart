// To parse this JSON data, do
//
//     final restaurante = restauranteFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Restaurante restauranteFromJson(String str) =>
    Restaurante.fromJson(json.decode(str));

String restauranteToJson(Restaurante data) => json.encode(data.toJson());

class Restaurante {
  String id;
  String nombre;
  String descripcion;
  String? categoriaId;
  String direccion;
  Geolocalizacion geolocalizacion;
  String telefono;
  String imagen;

  Restaurante({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.categoriaId,
    required this.direccion,
    required this.geolocalizacion,
    required this.telefono,
    required this.imagen,
  });

  factory Restaurante.fromJson(Map<String, dynamic> json) => Restaurante(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        categoriaId: json["categoriaId"],
        direccion: json["direccion"],
        geolocalizacion: json["geolocalizacion"] is GeoPoint
            ? Geolocalizacion.fromGeoPoint(json["geolocalizacion"])
            : Geolocalizacion.fromJson(json["geolocalizacion"]),
        telefono: json["telefono"],
        imagen: json["imagen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "categoriaId": categoriaId,
        "direccion": direccion,
        "geolocalizacion": geolocalizacion.toJson(),
        "telefono": telefono,
        "imagen": imagen,
      };
}

class Geolocalizacion {
  double lat;
  double lng;

  Geolocalizacion({
    required this.lat,
    required this.lng,
  });

  // Método existente
  factory Geolocalizacion.fromJson(Map<String, dynamic> json) =>
      Geolocalizacion(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  // Nuevo método para manejar GeoPoint
  factory Geolocalizacion.fromGeoPoint(GeoPoint geoPoint) => Geolocalizacion(
        lat: geoPoint.latitude,
        lng: geoPoint.longitude,
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
