import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hueca_movil/global/common/toast.dart';
import 'package:hueca_movil/src/controllers/categoria_controller.dart';
import 'package:hueca_movil/src/controllers/restaurante_controller.dart';
import 'package:hueca_movil/src/models/categoria.dart';
import 'package:hueca_movil/src/models/restaurante.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class RestaurantCreateForm extends StatefulWidget {
  const RestaurantCreateForm({super.key});

  @override
  State<RestaurantCreateForm> createState() => _RestaurantCreateFormState();
}

class _RestaurantCreateFormState extends State<RestaurantCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  List<Categoria> _categorias = [];
  String? _categoriaSeleccionada;
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  bool _isUploading = false;
  bool _isUploadComplete = false;
  bool _isSubmitEnabled = false;

  final CategoriaController _categoriaController = CategoriaController();
  final RestauranteController _restauranteController = RestauranteController();
  final double _lat = 0.0;
  final double _lng = 0.0;
  File? _image;

  final picker = ImagePicker();

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<String> _uploadImage(File image) async {
    String fileName = basename(image.path);
    Reference storageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');

    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isUploading = true; // Comienza la carga
        _isSubmitEnabled = false; // Deshabilita el botón de registro
      });

      // Sube la imagen y obtiene la URL
      try {
        await _uploadImage(_image!);
        setState(() {
          _isUploading = false; // Termina la carga
          _isUploadComplete = true; // Marca la carga como completada
          _isSubmitEnabled = true; // Habilita el botón de registro
        });
      } catch (e) {
        // Maneja cualquier error que pueda ocurrir durante la carga
        setState(() {
          _isUploading = false; // Asegura que el estado de carga se resetee
        });
        showToast(message: 'Error al cargar la imagen: $e');
      }
    }
  }

  Future<void> _submit(
    BuildContext context,
  ) async {
    if (_formKey.currentState!.validate()) {
      String imageUrl = await _uploadImage(_image!);

      Restaurante nuevoRestaurante = Restaurante(
        id: FirebaseFirestore.instance.collection('restaurantes').doc().id,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        categoriaId: _categoriaSeleccionada,
        direccion: _direccionController.text,
        geolocalizacion: Geolocalizacion(lat: _lat, lng: _lng),
        telefono: _telefonoController.text,
        imagen: imageUrl,
      );

      await _restauranteController
          .addRestaurante(nuevoRestaurante)
          .then((value) {
        // Mostrar Toast
        showToast(message: "Restaurante agregado exitosamente");
        Navigator.pop(context, true);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategorias(); // Llamar a la función para cargar categorías al inicializar
  }

  Future<void> _loadCategorias() async {
    var categorias = await _categoriaController
        .fetchCategorias(); // Suponiendo que este es tu método para cargar categorías
    setState(() {
      _categorias = categorias;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nuevo Restaurante'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                if (_categorias
                    .isNotEmpty) // Asegúrate de que _categorias no esté vacío
                  DropdownButtonFormField<String?>(
                    value: _categoriaSeleccionada,
                    hint: const Text('Seleccione una categoría'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _categoriaSeleccionada = newValue!;
                        print(newValue);
                      });
                    },
                    items: _categorias
                        .map<DropdownMenuItem<String>>((Categoria categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria.id,
                        child: Text(categoria.nombre),
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'Campo requerido' : null,
                  ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una dirección';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un número de teléfono';
                    }
                    return null;
                  },
                ),
                Center(
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isUploadComplete
                                ? Colors.green
                                : null, // Cambia el color si la carga está completa
                          ),
                          child: _isUploading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : (_isUploadComplete
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : const Text('Seleccionar Imagen'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 5.0),
                      child: ElevatedButton(
                        onPressed:
                            _isSubmitEnabled ? () => _submit(context) : null,
                        child: const Text('Registrar Restaurante'),
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
