import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/categoria.dart'; // Ensure this path matches the location of your Categoria model

class CategoriaController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addCategoria(Categoria categoria) async {
    await _db
        .collection('categorias')
        .doc(categoria.id)
        .set(categoria.toJson());
  }

  Future<void> updateCategoria(String id, Categoria categoria) async {
    await _db.collection('categorias').doc(id).update(categoria.toJson());
  }

  Future<List<Categoria>> fetchCategorias() async {
    QuerySnapshot querySnapshot = await _db.collection('categorias').get();
    List<Categoria> categorias = querySnapshot.docs
        .map((doc) => Categoria.fromJson(doc.data()! as Map<String, dynamic>))
        .toList();
    return categorias;
  }

  Future<Categoria?> fetchCategoriaById(String id) async {
    var doc = await _db.collection('categorias').doc(id).get();
    if (doc.exists) {
      return Categoria.fromJson(doc.data()!);
    }
    return null;
  }

  Future<String> getCategoryNameById(String? id) async {
    var doc = await _db.collection('categorias').doc(id).get();
    if (doc.exists) {
      // Asumiendo que el documento tiene un campo 'nombre'
      return doc.data()!['nombre'] ?? 'Nombre no disponible';
    } else {
      return 'Categoría no encontrada';
    }
  }

  Future<void> deleteCategoria(String id) async {
    await _db.collection('categorias').doc(id).delete();
  }
}
