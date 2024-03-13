import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hueca_movil/global/common/toast.dart';
import 'package:hueca_movil/src/controllers/usuario_controller.dart';
import 'package:hueca_movil/user_auth/presentation/pages/login_page.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final UsuarioController _usuarioController = UsuarioController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 187, 187, 187),
              image: DecorationImage(
                image: AssetImage(
                    'assets/background.jpg'), // Tu imagen de fondo aquí
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/logo.png', // Tu logo aquí
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.contain,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${FirebaseAuth.instance.currentUser?.email}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 217, 255),
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          buildListTile(Icons.settings, 'Configuración', () {
            Navigator.pop(context);
            // Navegar a la pantalla de configuración
          }),
          buildListTile(Icons.account_circle, 'Editar Perfil', () {
            Navigator.pop(context);
            // Navegar a la pantalla de edición de perfil
          }),
          buildListTile(Icons.rate_review, 'Perfil de reseñas', () {
            Navigator.pop(context);
            // Navegar a la pantalla de reseñas
          }),
          buildListTile(Icons.info, 'Acerca de la App', () {
            Navigator.pop(context);
            // Navegar a la pantalla de información de la aplicación
          }),
          ListTile(
            title: GestureDetector(
              onTap: () async {
                _usuarioController.cerrarSesion(context).then((_) {
                  showToast(message: "Se ha cerrado la sesión con éxito");
                  Navigator.of(context)
                      .pushReplacementNamed(LoginPage.routeName);
                }).catchError((error) {
                  showToast(message: "Ocurrió un error al cerrar sesión");
                });
              },
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Cerrar Sesión",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, Function()? onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap != null ? onTap : () {},
    );
  }
}
