import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileImageBottomSheet {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print('Imagen seleccionada: ${pickedFile.path}');
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      print('Imagen tomada: ${pickedFile.path}');
    }
  }

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 200,
          child: Column(
            children: [
              Text(
                'Editar Foto de Perfil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Elegir de la Galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tomar Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
