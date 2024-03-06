import 'package:flutter/material.dart';

import 'package:hueca_movil/global/common/toast.dart';
import 'package:hueca_movil/src/controllers/categoria_controller.dart';
import 'package:hueca_movil/src/controllers/resena_controller.dart';
import 'package:hueca_movil/src/controllers/restaurante_controller.dart';
import 'package:hueca_movil/src/models/categoria.dart';
import 'package:hueca_movil/src/models/restaurante.dart';
import 'package:hueca_movil/user_auth/presentation/widgets/categorias_navbar.dart';
import 'package:hueca_movil/user_auth/presentation/widgets/restaurant_card.dart';

class ListRestaurantes extends StatefulWidget {
  const ListRestaurantes({super.key});

  @override
  State<ListRestaurantes> createState() => _ListRestaurantesState();
}

class RestauranteConCalificacion {
  Restaurante restaurante;
  double rating;

  RestauranteConCalificacion(this.restaurante, this.rating);
}

class _ListRestaurantesState extends State<ListRestaurantes> {
  String? categoriaSeleccionadaId;
  final RestauranteController _restauranteController = RestauranteController();
  final CategoriaController _categoriaController = CategoriaController();
  final ResenaController _resenaController = ResenaController();
  List<Categoria> categorias = [];

  @override
  void initState() {
    super.initState();
    cargarCategorias(); // Llama al método al inicializar
  }

  void cargarCategorias() async {
    try {
      List<Categoria> categoriasObtenidas =
          await _categoriaController.fetchCategorias();
      setState(() {
        categorias = categoriasObtenidas;
      });
    } catch (error) {
      showToast(message: 'Ocurrió un error al obtener las categorías: $error');
      // Aquí podrías manejar el error como mejor te parezca, por ejemplo, mostrando un Snackbar.
    }
  }

  Future<void> _recargarRestaurantes() async {
    try {
      // Aquí, dependiendo de tu lógica de negocio, vuelves a cargar las categorías si es necesario.
      // Pero enfocándonos en los restaurantes:
      cargarCategorias(); // Esto recargará las categorías si tu lógica lo requiere.

      // No es necesario actualizar el estado después de cargar las categorías ya que
      // el RefreshIndicator automáticamente indicará la necesidad de reconstruir la interfaz
      // al completarse el Future.
    } catch (error) {
      showToast(message: 'Error al recargar los datos: $error');
    }
  }

  Future<List<RestauranteConCalificacion>> cargarRestaurantesConCalificaciones(
      String? categoriaId) async {
    List<Restaurante> restaurantes;
    if (categoriaId == null || categoriaId.isEmpty) {
      restaurantes = await _restauranteController.fetchAllRestaurants();
    } else {
      restaurantes =
          await _restauranteController.fetchRestaurantsByCategory(categoriaId);
    }

    List<RestauranteConCalificacion> restaurantesConCalificacion = [];
    for (var restaurante in restaurantes) {
      double rating =
          await _resenaController.calculateAverageRating(restaurante.id);
      restaurantesConCalificacion
          .add(RestauranteConCalificacion(restaurante, rating));
    }
    return restaurantesConCalificacion;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Alinea los widgets hijos a la izquierda
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          width: double
              .infinity, // Asegura que el Container ocupe todo el ancho disponible
          alignment: Alignment
              .centerLeft, // Alinea el contenido del Container a la izquierda
          child: const Text(
            "Buscar por categoría",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: CategoriasNavBar(
            categorias: categorias,
            onCategoriaSeleccionada: (id) {
              setState(() {
                categoriaSeleccionadaId = id;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          width: double
              .infinity, // Asegura que el Container ocupe todo el ancho disponible
          alignment: Alignment
              .centerLeft, // Alinea el contenido del Container a la izquierda
          child: const Text(
            "Explorar Huecas",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _recargarRestaurantes,
            child: FutureBuilder<List<RestauranteConCalificacion>>(
              future:
                  cargarRestaurantesConCalificaciones(categoriaSeleccionadaId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay restaurantes para esta categoría'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    RestauranteConCalificacion restauranteConCalificacion =
                        snapshot.data![index];
                    return RestaurantCard(
                      id: restauranteConCalificacion.restaurante.id,
                      name: restauranteConCalificacion.restaurante.nombre,
                      description:
                          restauranteConCalificacion.restaurante.descripcion,
                      address: restauranteConCalificacion.restaurante.direccion,
                      rating: restauranteConCalificacion.rating,
                      imageUrl: restauranteConCalificacion.restaurante.imagen,
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
