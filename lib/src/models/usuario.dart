// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  String uid;
  String username;
  String email;
  String fechaCreacion;
  String ultimaConexion;

  Usuario({
    required this.uid,
    required this.username,
    required this.email,
    required this.fechaCreacion,
    required this.ultimaConexion,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        fechaCreacion:
            (json["fechaCreacion"] as Timestamp).toDate().toIso8601String(),
        ultimaConexion:
            (json["ultimaConexion"] as Timestamp).toDate().toIso8601String(),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "fechaCreacion": fechaCreacion,
        "ultimaConexion": ultimaConexion,
      };
}
