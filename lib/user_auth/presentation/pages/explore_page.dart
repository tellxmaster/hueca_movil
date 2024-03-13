import 'package:flutter/material.dart';
import 'package:hueca_movil/src/controllers/categoria_controller.dart';
import 'package:hueca_movil/src/controllers/restaurante_controller.dart';
import 'package:hueca_movil/src/models/restaurante.dart';

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

  final TextEditingController _searchController = TextEditingController();

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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.trim();
                      });
                      _buscarRestaurantesPorNombre(searchQuery);
                    },
                    decoration: InputDecoration(
                      labelText: 'Buscar Restaurantes',
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  searchQuery = '';
                                });
                              },
                              icon: Icon(Icons.clear),
                            )
                          : Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: searchQuery.isEmpty
                ? _buildRestaurantesListView(
                    future: _restauranteController.fetchAllRestaurants())
                : _buildRestaurantesListView(
                    future: Future.value(restaurantesFiltrados)),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantesListView(
      {required Future<List<Restaurante>> future}) {
    return FutureBuilder<List<Restaurante>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Text("No hay restaurantes disponibles");
        } else {
          List<Restaurante> restaurantes = snapshot.data ?? [];
          return ListView.builder(
            itemCount: restaurantes.length,
            itemBuilder: (context, index) {
              Restaurante restaurante = restaurantes[index];
              return InkWell(
                child: ListTile(
                  title: Text(restaurante.nombre),
                  subtitle: FutureBuilder<String>(
                    future: _categoriaController
                        .getCategoryNameById(restaurante.categoriaId),
                    builder: (context, categoriaSnapshot) {
                      if (categoriaSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Text('Cargando nombre de categoría...',
                            style: Theme.of(context).textTheme.bodySmall);
                      }
                      return Text(
                        '${categoriaSnapshot.data}', // Nombre de la categoría
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      },
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
