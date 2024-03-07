import 'package:flutter/material.dart';
import 'package:hueca_movil/src/controllers/categoria_controller.dart';
import 'package:hueca_movil/src/controllers/resena_controller.dart';
import 'package:hueca_movil/src/controllers/restaurante_controller.dart';
import 'package:hueca_movil/src/models/resena.dart';
import 'package:hueca_movil/src/models/restaurante.dart';
import 'package:hueca_movil/user_auth/presentation/widgets/restaurant_review_form.dart';

class RestaurantInfo extends StatelessWidget {
  final String id;
  final RestauranteController _restauranteController = RestauranteController();
  final CategoriaController _categoriaController = CategoriaController();
  final ResenaController _resenaController = ResenaController();

  RestaurantInfo({
    Key? key,
    required this.id,
  }) : super(key: key);

  void _showReviewForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantReviewForm(
            restauranteId: id), // Pasa el ID al nuevo widget
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Restaurante'),
      ),
      body: FutureBuilder<Restaurante?>(
        future: _restauranteController.fetchRestauranteById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ocurrió un error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final restaurante = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    restaurante.imagen,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre
                        Text(
                          snapshot.data!.nombre,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),
                        // Descripción
                        Text(
                          snapshot.data!.descripcion,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        // Categoría
                        // Categoría con Icono
                        Row(
                          children: <Widget>[
                            Icon(Icons.category,
                                color: Colors.grey[600]), // Icono de categoría
                            const SizedBox(
                                width: 8), // Espacio entre el icono y el texto
                            FutureBuilder<String>(
                                future:
                                    _categoriaController.getCategoryNameById(
                                        snapshot.data?.categoriaId),
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
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  );
                                }),
                          ],
                        ),
                        const SizedBox(height: 8),
// Dirección con Icono
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on,
                                color: Colors.grey[600]), // Icono de ubicación
                            const SizedBox(width: 8),
                            Expanded(
                              // Usar Expanded para evitar overflow si la dirección es muy larga
                              child: Text(
                                snapshot.data!.direccion,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
// Teléfono con Icono
                        Row(
                          children: <Widget>[
                            Icon(Icons.phone,
                                color: Colors.grey[600]), // Icono de teléfono
                            const SizedBox(width: 8),
                            Text(
                              snapshot.data!.telefono,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 20.0),
                              child: ElevatedButton(
                                onPressed: () => {},
                                child: const Text('Ver el mapa'),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 20.0),
                                child: ElevatedButton(
                                  onPressed: () => _showReviewForm(context),
                                  child: const Text('Nueva reseña'),
                                )),
                          ],
                        ),
                        // Continuación después de tu Row con los botones
                        FutureBuilder<List<Resena>>(
                          future: _resenaController
                              .fetchResenasByRestaurante(restaurante.id),
                          builder: (context, resenasSnapshot) {
                            if (resenasSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (resenasSnapshot.hasError) {
                              return Text(
                                  'Error al cargar las reseñas: ${resenasSnapshot.error}');
                            }
                            if (resenasSnapshot.hasData &&
                                resenasSnapshot.data!.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Reseñas',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ...resenasSnapshot.data!
                                        .map((resena) => ListTile(
                                              title: Text(resena.titulo,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              subtitle: Text(resena.texto),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children:
                                                    List.generate(5, (index) {
                                                  return Icon(
                                                    index < resena.calificacion
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: Colors.amber,
                                                  );
                                                }),
                                              ),
                                            ))
                                        .toList(),
                                  ],
                                ),
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    'No hay reseñas aún para este restaurante.'),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
              child: Text('No se encontró información del restaurante'));
        },
      ),
    );
  }
}
