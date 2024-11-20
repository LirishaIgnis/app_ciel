import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GeneralSettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  ImageProvider<Object>? institutionLogo;
  final ImagePicker _picker = ImagePicker();

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
            const Text(
              'Logo de la institución',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      institutionLogo = FileImage(File(image.path));
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: institutionLogo ??
                      const AssetImage('assets/images/default_logo.png'),
                  child: const Icon(Icons.edit, size: 28, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
