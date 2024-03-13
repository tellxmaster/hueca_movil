import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hueca_movil/global/common/toast.dart';
import 'package:hueca_movil/src/controllers/resena_controller.dart';
import 'package:hueca_movil/src/models/resena.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantReviewForm extends StatefulWidget {
  static const String routeName = '/restaurant_review_form';
  final String restauranteId;
  final String? resenaId;

  const RestaurantReviewForm(
      {Key? key, required this.restauranteId, this.resenaId})
      : super(key: key);

  @override
  RestaurantReviewFormState createState() => RestaurantReviewFormState();
}

class RestaurantReviewFormState extends State<RestaurantReviewForm> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 0;
  final _tituloController = TextEditingController();
  final _textoController = TextEditingController();
  final ResenaController resenaController = ResenaController();

  void _submitReview() {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? '';
    if (_formKey.currentState!.validate()) {
      // Aquí manejas la lógica para enviar la reseña, como:
      final resena = Resena(
        id: widget.resenaId ??
            FirebaseFirestore.instance.collection('resenas').doc().id,
        restauranteId: widget.restauranteId,
        usuarioId:
            userId, // Debes obtener el ID del usuario actual de alguna manera
        titulo: _tituloController.text,
        texto: _textoController.text,
        calificacion: _rating.toInt(),
        fecha: DateTime.now(),
      );

      if (widget.resenaId == null) {
        // Si no hay resenaId, se trata de una nueva reseña
        resenaController.addResena(resena).then((_) {
          Navigator.of(context).pop(true); // Regresar a la pantalla anterior
        }).catchError((error) {
          showToast(message: 'Error al crear reseña: $error');
        });
      } else {
        resenaController.updateResena(widget.resenaId!, resena).then((_) {
          Navigator.of(context).pop(true); // Regresar a la pantalla anterior
        }).catchError((error) {
          showToast(message: 'Error al actualizar reseña: $error');
        });
      }
    }
  }

  void _deleteReview() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Retorna un objeto de tipo Dialog
        return AlertDialog(
          title: const Text("Eliminar Reseña"),
          content: const Text(
              "¿Estás seguro de que quieres eliminar esta reseña? Esta acción no se puede deshacer."),
          actions: <Widget>[
            // Botón para cancelar
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text("Cancelar"),
            ),
            // Botón para confirmar la eliminación
            TextButton(
              onPressed: () async {
                if (widget.resenaId != null) {
                  try {
                    await resenaController
                        .deleteResena(widget.resenaId!)
                        .then((_) {
                      Navigator.of(context)
                          .pop(); // Cierra el diálogo de confirmación
                      Navigator.of(context).pop(
                          true); // Opcional: regresa a la pantalla anterior si es necesario

                      // Muestra el mensaje de éxito
                      showToast(message: "Reseña eliminada con éxito");
                    });
                  } catch (e) {
                    Navigator.of(context)
                        .pop(); // Cierra el diálogo de confirmación

                    // Muestra el mensaje de error
                    showToast(message: "Error al eliminar la reseña");
                  }
                }
              },
              child:
                  const Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.resenaId != null) {
      _loadResenaData(widget.resenaId!);
    }
  }

  void _loadResenaData(String resenaId) async {
    // Utiliza ResenaController para cargar los detalles de la reseña
    final resenaController = ResenaController();
    Resena? resena = await resenaController.fetchResenaById(resenaId);
    if (resena != null) {
      setState(() {
        _tituloController.text = resena.titulo;
        _textoController.text = resena.texto;
        _rating = resena.calificacion.toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Reseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _textoController,
                decoration:
                    const InputDecoration(labelText: 'Texto de la reseña'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el texto de la reseña';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centra los botones en el Row
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: const Text('Enviar Reseña'),
                  ),
                  // Espacio opcional entre botones, si deseas añadir un poco de separación
                  const SizedBox(width: 10),
                  // Muestra el botón de eliminar solo si estás editando una reseña existente
                  if (widget.resenaId != null)
                    ElevatedButton(
                      onPressed:
                          _deleteReview, // Asegúrate de implementar este método
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Color rojo para el botón de eliminar
                      ),
                      child: const Text('Eliminar Reseña'),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
