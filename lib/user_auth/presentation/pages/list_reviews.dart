import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:hueca_movil/features/user_auth/presentation/widgets/restaurant_create_form.dart';
// import 'package:hueca_movil/features/user_auth/presentation/widgets/restaurant_review_form.dart';
import 'package:hueca_movil/global/common/toast.dart';
import 'package:hueca_movil/src/controllers/resena_controller.dart';
import 'package:hueca_movil/src/controllers/restaurante_controller.dart';
import 'package:hueca_movil/src/models/resena.dart';
import 'package:hueca_movil/src/models/restaurante.dart';

class ListReviews extends StatefulWidget {
  const ListReviews({Key? key}) : super(key: key);

  @override
  ListReviewsState createState() => ListReviewsState();
}

class ListReviewsState extends State<ListReviews> {
  final _resenaController = ResenaController();
  final RestauranteController _restauranteController = RestauranteController();
  List<Resena> _resenas = [];
  bool _isLoading = true;

  void _getResenas() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    try {
      List<Resena> resenas = await _resenaController.fetchResenasByUser(userId);
      setState(() {
        _resenas = resenas;
        _isLoading = false;
      });
    } catch (e) {
      showToast(message: "Error al obtener reseñas: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getResenas(); // Carga inicial de reseñas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Reseñas"),
      ),
      body: RefreshIndicator(
        // Añade el RefreshIndicator aquí
        onRefresh: () async {
          // Llama a _getResenas() para recargar las reseñas
          _getResenas();
        },
        child: _isLoading == true
            ? const Center(
                child:
                    CircularProgressIndicator(), // Muestra el indicador de carga si _isLoading es true
              )
            : _resenas.isEmpty
                ? const Center(
                    child: Text("No hay reseñas aún"),
                  )
                : ListView.builder(
                    itemCount: _resenas.length,
                    itemBuilder: (context, index) {
                      final resena = _resenas[index];
                      return ListTile(
                        title: FutureBuilder<String>(
                          future: _restauranteController
                              .fetchNombreRestaurantePorId(
                                  resena.restauranteId),
                          builder: (context, nombreRestauranteSnapshot) {
                            if (nombreRestauranteSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Cargando....');
                            }
                            return Text(
                                '${nombreRestauranteSnapshot.data}: ${resena.titulo}');
                          },
                        ),
                        subtitle: RatingBarIndicator(
                          rating: resena.calificacion.toDouble(),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                // bool? result = await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => RestaurantReviewForm(
                                //       restauranteId: resena
                                //           .restauranteId, // Ya tienes este dato
                                //       resenaId: resena
                                //           .id, // Aquí pasas el ID de la reseña para editarla
                                //     ),
                                //   ),
                                // );
                                // if (result == true) {
                                //   _getResenas();
                                // }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _mostrarDialogoOpciones(context),
          tooltip: 'Añadir nueva reseña',
          foregroundColor: Colors.white,
          child: const Icon(Icons.add)),
    );
  }

  void _mostrarDialogoOpciones(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Reseña'),
          content: const Text(
              '¿Deseas reseñar un nuevo restaurante o uno existente?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         const RestaurantCreateForm(), // Pasa el ID al nuevo widget
                //   ),
                // );
              },
              child: const Text('Nuevo Restaurante'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _mostrarSelectorRestaurante(context);
              },
              child: const Text('Restaurante Existente'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarSelectorRestaurante(BuildContext context) {
    // Asumiendo que tienes un RestauranteController ya definido e instanciado
    final restauranteController = RestauranteController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona un Restaurante'),
          content: FutureBuilder<List<Restaurante>>(
            future: restauranteController.fetchAllRestaurants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: 60, // Ajusta el tamaño como sea necesario
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Text('No hay restaurantes disponibles');
              }
              final restaurantes = snapshot.data!;
              return DropdownButton<String>(
                items: restaurantes
                    .map((restaurante) => DropdownMenuItem<String>(
                          value: restaurante.id,
                          child: Text(restaurante.nombre),
                        ))
                    .toList(),
                onChanged: (String? restauranteId) {
                  // Aquí puedes manejar la selección del restaurante
                  Navigator.of(context).pop(); // Cierra el diálogo
                  if (restauranteId != null) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         RestaurantReviewForm(restauranteId: restauranteId),
                    //   ),
                    // );
                  }
                },
                hint: const Text('Selecciona un restaurante'),
              );
            },
          ),
        );
      },
    );
  }
}
