import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/restaurante.dart'; // Ensure this path matches the location of your Restaurante model

class RestauranteController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addRestaurante(Restaurante restaurante) async {
    await _db
        .collection('restaurantes')
        .doc(restaurante.id)
        .set(restaurante.toJson());
  }

  Future<void> updateRestaurante(String id, Restaurante restaurante) async {
    await _db.collection('restaurantes').doc(id).update(restaurante.toJson());
  }

  Future<List<Restaurante>> fetchAllRestaurants() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection("restaurantes").get();
      List<Restaurante> restaurantes = querySnapshot.docs.map((doc) {
        return Restaurante.fromJson(doc.data()! as Map<String, dynamic>);
      }).toList();
      return restaurantes;
    } catch (e) {
      rethrow; // O maneja el error como consideres adecuado para tu aplicación
    }
  }

  Future<Restaurante?> fetchRestauranteById(String id) async {
    var doc = await _db.collection('restaurantes').doc(id).get();
    if (doc.exists) {
      return Restaurante.fromJson(doc.data()!);
    }
    return null;
  }

  Future<String> fetchNombreRestaurantePorId(String restauranteId) async {
    try {
      var doc = await _db.collection('restaurantes').doc(restauranteId).get();
      if (doc.exists) {
        return doc.data()?['nombre'] ?? 'Nombre no disponible';
      }
      return 'Restaurante no encontrado';
    } catch (e) {
      print(e);
      return 'Error al obtener el restaurante';
    }
  }

  Future<List<Restaurante>> fetchRestaurantsByCategory(
      String categoriaId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection("restaurantes")
          .where('categoriaId', isEqualTo: categoriaId)
          .get();

      //querySnapshot.docs.forEach((doc) => print(doc.data()));

      List<Restaurante> restaurantes = querySnapshot.docs
          .map(
              (doc) => Restaurante.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return restaurantes;
    } catch (e) {
      print("Error al obtener restaurantes por categoría: $e");
      return [];
    }
  }

  Future<void> deleteRestaurante(String id) async {
    await _db.collection('restaurantes').doc(id).delete();
  }
}
