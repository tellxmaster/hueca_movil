import 'package:flutter/material.dart';
import 'package:hueca_movil/user_auth/presentation/pages/explore_page.dart';
import 'package:hueca_movil/user_auth/presentation/pages/list_restaurantes.dart';
import 'package:hueca_movil/user_auth/presentation/pages/list_reviews.dart';
import 'package:hueca_movil/user_auth/presentation/widgets/sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aquí puedes añadir lógica adicional para cada índice, como navegar a diferentes pantallas.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hueca Movil"),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: Colors.white,
      ),
      drawer: const Sidebar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          ListRestaurantes(),
          ListReviews(),
          Explore(), // Pantalla de explorar
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews),
            label: 'Reseñas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explorar',
          ),
        ],
        currentIndex:
            _selectedIndex, // Índice actual basado en la selección del usuario
        selectedItemColor: Colors.amber[800], // Color del ítem seleccionado
        onTap: _onItemTapped, // Método llamado al seleccionar un ítem
      ),
    );
  }
}
