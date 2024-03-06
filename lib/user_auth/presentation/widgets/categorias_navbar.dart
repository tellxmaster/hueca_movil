import 'package:flutter/material.dart';
import 'package:hueca_movil/src/models/categoria.dart';

class CategoriasNavBar extends StatelessWidget {
  final List<Categoria> categorias;
  final Function(String id) onCategoriaSeleccionada;

  const CategoriasNavBar({
    Key? key,
    required this.categorias,
    required this.onCategoriaSeleccionada,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        return GestureDetector(
          onTap: () => onCategoriaSeleccionada(categoria.id),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(categoria.imageUrl),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 4),
                Text(
                  categoria.nombre,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
