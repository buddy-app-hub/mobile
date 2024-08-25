import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/services/files_service.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class EditProfileImageBottomSheet {
  final ImagePicker _picker = ImagePicker();
  final FilesService _filesService = FilesService();
  double _uploadProgress = 0.0;


  Future<void> _pickImageFromGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _uploadImage(context, imageFile);
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _uploadImage(context, imageFile);
    }
  }

  Future<void> _uploadImage(BuildContext context, File imageFile) async {
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(value: _uploadProgress),
              SizedBox(height: 20),
              Text('Subiendo imagen...'),
            ],
          ),
        );
      },
    );

    await _filesService.uploadProfileImage(
      userId: authProvider.user!.uid,
      imageFile: imageFile,
      onProgress: (progress) {
        _uploadProgress = progress;
        (context as Element).markNeedsBuild();
      },
      onComplete: (downloadUrl) {
        Navigator.pop(context); // Cerrar el diálogo de progreso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imagen subida correctamente')),
        );
      },
      onError: (errorMessage) {
        Navigator.pop(context); // Cerrar el diálogo de progreso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir la imagen: $errorMessage')),
        );
      },
    );
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
