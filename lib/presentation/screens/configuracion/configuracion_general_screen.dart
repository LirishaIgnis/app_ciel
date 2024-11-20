import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class GeneralSettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  File? institutionLogo;  // Para almacenar el logo
  String institutionName = '';  // Para almacenar el nombre de la institución
  String institutionLocation = '';  // Para almacenar la localización
  bool isValid = true;  // Flag para indicar si la validación es correcta

  // Función para seleccionar una imagen utilizando FilePicker
  Future<void> _selectImage() async {
    // Usamos FilePicker para seleccionar un archivo de la galería o almacenamiento
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,  // Filtramos solo imágenes
    );

    if (result != null) {
      // Si el usuario seleccionó un archivo
      setState(() {
        institutionLogo = File(result.files.single.path!);
      });
    }
  }

  // Función para guardar la configuración
  void _saveConfiguration() {
    if (institutionName.isEmpty || institutionLocation.isEmpty || institutionLogo == null) {
      setState(() {
        isValid = false;  // Si algún campo está vacío, la validación falla
      });
      return;
    }

    // Aquí puedes agregar el código para guardar los datos en una base de datos local o en almacenamiento persistente

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuración guardada exitosamente')),
    );
    setState(() {
      isValid = true;  // Restablecer la validez
    });
  }

  // Función para mostrar la configuración guardada
  void _showInformation() {
    if (!isValid) {
      // Si hay un error de validación, mostramos un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos antes de guardar.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Información de la Institución'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre: $institutionName'),
              const SizedBox(height: 8),
              Text('Localización: $institutionLocation'),
              const SizedBox(height: 8),
              institutionLogo != null
                  ? Image.file(institutionLogo!)
                  : const Text('No se ha seleccionado un logo'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración General'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo para el nombre de la institución
            const Text(
              'Nombre de la Institución',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  institutionName = value;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Ingresa el nombre de la institución',
                errorText: institutionName.isEmpty && !isValid ? 'El nombre es obligatorio' : null,
              ),
            ),
            const SizedBox(height: 20),

            // Logo de la institución
            const Text(
              'Logo de la Institución',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: _selectImage, // Llamamos a la función para seleccionar el logo
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: institutionLogo == null
                      ? const AssetImage('assets/images/default_logo.png')
                      : FileImage(institutionLogo!) as ImageProvider<Object>,
                  child: const Icon(Icons.edit, size: 28, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Campo para la localización
            const Text(
              'Localización de la Institución',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  institutionLocation = value;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Ingresa la localización de la institución',
                errorText: institutionLocation.isEmpty && !isValid ? 'La localización es obligatoria' : null,
              ),
            ),
            const SizedBox(height: 30),

            // Botón para guardar la configuración
            ElevatedButton(
              onPressed: _saveConfiguration,
              child: const Text('Guardar Configuración'),
            ),
            const SizedBox(height: 20),

            // Botón para mostrar la información guardada
            ElevatedButton(
              onPressed: _showInformation,
              child: const Text('Mostrar Información Guardada'),
            ),
          ],
        ),
      ),
    );
  }
}

