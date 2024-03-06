import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Ingreso',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String _categoria = 'Asados'; // Categoría por defecto
  String? _nombre = ''; // Cambiado a String? para aceptar valores nulos
  String? _comentario = ''; // Cambiado a String? para aceptar valores nulos

  final List<String> _categorias = ['Asados', 'Embutidos', 'Fritos', 'Otros']; // Categorías predefinidas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios y reseñas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Categoría:',
              style: TextStyle(fontSize: 18.0),
            ),
            DropdownButtonFormField(
              value: _categoria,
              items: _categorias.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) { 
                setState(() {
                  _categoria = value ?? '';
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Nombre:',
              style: TextStyle(fontSize: 18.0),
            ),
            TextFormField(
              onChanged: (value) { // Cambiado a String? para aceptar valores nulos
                setState(() {
                  _nombre = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Comentario:',
              style: TextStyle(fontSize: 18.0),
            ),
            TextFormField(
              onChanged: (value) { 
                setState(() {
                  _comentario = value;
                });
              },
              maxLines: 3,
            ),
            SizedBox(height: 20.0),
            ElevatedButton( 
              onPressed: () {
                
                print('Categoría: $_categoria');
                print('Nombre: $_nombre');
                print('Comentario: $_comentario');
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
