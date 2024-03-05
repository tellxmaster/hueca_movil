import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/resena.dart'; // Ensure this path matches the location of your Resena model

class ResenaController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addResena(Resena resena) async {
    if (resena.id.isEmpty) {
      // Genera un nuevo ID de documento si el ID actual está vacío
      String newId = _db.collection('resenas').doc().id;
      resena.id = newId;
    }
    await _db.collection('resenas').doc(resena.id).set(resena.toJson());
  }

  Future<void> updateResena(String id, Resena resena) async {
    await _db.collection('resenas').doc(id).update(resena.toJson());
  }

  Future<List<Resena>> fetchResenas() async {
    QuerySnapshot querySnapshot = await _db.collection('resenas').get();
    List<Resena> resenas = querySnapshot.docs
        .map((doc) => Resena.fromJson(doc.data()! as Map<String, dynamic>))
        .toList();
    return resenas;
  }

  Future<List<Resena>> fetchResenasByRestaurante(String restauranteId) async {
    QuerySnapshot querySnapshot = await _db
        .collection('resenas')
        .where('restaurante_id', isEqualTo: restauranteId)
        .get();

    return querySnapshot.docs
        .map((doc) => Resena.fromJson(doc.data()! as Map<String, dynamic>))
        .toList();
  }

  Future<List<Resena>> fetchResenasByUser(String userId) async {
    QuerySnapshot querySnapshot = await _db
        .collection('resenas')
        .where('usuario_id', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => Resena.fromJson(doc.data()! as Map<String, dynamic>))
        .toList();
  }

  Future<Resena?> fetchResenaById(String id) async {
    DocumentSnapshot docSnapshot =
        await _db.collection('resenas').doc(id).get();

    if (docSnapshot.exists) {
      return Resena.fromJson(docSnapshot.data()! as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<double> calculateAverageRating(String restauranteId) async {
    List<Resena> resenas = await fetchResenasByRestaurante(restauranteId);
    if (resenas.isEmpty) {
      return 0.0; // Retorna 0 si no hay reseñas
    }
    double totalRating = 0;
    for (var resena in resenas) {
      totalRating += resena.calificacion;
    }
    return totalRating / resenas.length;
  }

  Future<void> deleteResena(String id) async {
    await _db.collection('resenas').doc(id).delete();
  }
}
