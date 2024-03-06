// Asegúrate de importar los widgets y modelos necesarios en la parte superior
import 'package:flutter/material.dart';
<<<<<<< HEAD

import 'package:hueca_movil/src/controllers/categoria_controller.dart';
import 'package:hueca_movil/src/controllers/restaurante_controller.dart';
import 'package:hueca_movil/src/models/restaurante.dart';
import 'package:hueca_movil/user_auth/presentation/widgets/restaurant_info.dart';
=======
import 'package:hueca_movil/src/controllers/categoria_controller.dart';
import 'package:hueca_movil/src/controllers/restaurante_controller.dart';
import 'package:hueca_movil/src/models/restaurante.dart';
>>>>>>> f5cdc12e1667dcecce50927249053c3de1d6cf95

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  String searchQuery = '';
  final RestauranteController _restauranteController = RestauranteController();
  final CategoriaController _categoriaController = CategoriaController();
  List<Restaurante> restaurantesFiltrados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explorar Restaurantes"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
                if (searchQuery.isNotEmpty) {
                  _buscarRestaurantesPorNombre(searchQuery);
                }
              },
              decoration: InputDecoration(
                labelText: 'Buscar Restaurantes',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: searchQuery.isEmpty
                ? FutureBuilder<List<Restaurante>>(
                    future: _restauranteController.fetchAllRestaurants(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Restaurante restaurante = snapshot.data![index];
                            return InkWell(
<<<<<<< HEAD
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RestaurantInfo(id: restaurante.id),
                                ),
                              ),
=======
                              
>>>>>>> f5cdc12e1667dcecce50927249053c3de1d6cf95
                              child: ListTile(
                                title: Text(restaurante.nombre),
                                subtitle: FutureBuilder<String>(
                                    future: _categoriaController
                                        .getCategoryNameById(
                                            restaurante.categoriaId),
                                    builder: (context, categoriaSnapshot) {
                                      if (categoriaSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(
                                            'Cargando nombre de categoría...',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall);
                                      }
                                      return Text(
                                        '${categoriaSnapshot.data}', // Nombre de la categoría
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      );
                                    }),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Text("No hay restaurantes disponibles");
                      }
                    },
                  )
                : ListView.builder(
                    itemCount: restaurantesFiltrados.length,
                    itemBuilder: (context, index) {
                      Restaurante restaurante = restaurantesFiltrados[index];
                      return InkWell(
<<<<<<< HEAD
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RestaurantInfo(id: restaurante.id),
                          ),
                        ),
=======
                        
>>>>>>> f5cdc12e1667dcecce50927249053c3de1d6cf95
                        child: ListTile(
                          title: Text(restaurante.nombre),
                          subtitle: FutureBuilder<String>(
                              future: _categoriaController
                                  .getCategoryNameById(restaurante.categoriaId),
                              builder: (context, categoriaSnapshot) {
                                if (categoriaSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('Cargando nombre de categoría...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall);
                                }
                                return Text(
                                  '${categoriaSnapshot.data}', // Nombre de la categoría
                                  style: Theme.of(context).textTheme.bodySmall,
                                );
                              }),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _buscarRestaurantesPorNombre(String query) async {
    var restaurantes = await _restauranteController.fetchAllRestaurants();
    setState(() {
      restaurantesFiltrados = restaurantes
          .where((restaurante) =>
              restaurante.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
