import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/services/files_service.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class EditProfileImageBottomSheet {
  final ImagePicker _picker = ImagePicker();
  final FilesService _filesService = FilesService();

  Future<void> _pickImageFromGallery(BuildContext context,
      AuthSessionProvider authProvider, Function _loadProfileImage) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _uploadImage(context, imageFile, authProvider, _loadProfileImage);
    }
  }

  Future<void> _takePhoto(BuildContext context,
      AuthSessionProvider authProvider, Function _loadProfileImage) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _uploadImage(context, imageFile, authProvider, _loadProfileImage);
    }
  }

  Future<void> _uploadImage(BuildContext scaffoldContext, File imageFile,
      AuthSessionProvider authProvider, Function _loadProfileImage) async {
    // Show progress indicator dialog
    final progressDialog = showDialog(
      context: scaffoldContext,
      builder: (context) => AlertDialog(
        title: Text('Subiendo imagen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Por favor, espere...'),
          ],
        ),
      ),
    );

    try {
      await _filesService.uploadProfileImage(
        userId: authProvider.user!.uid,
        imageFile: imageFile,
        onProgress: (progress) {},
        onComplete: (downloadUrl) {
          Navigator.pop(scaffoldContext); // Close the progress dialog
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            SnackBar(content: Text('Imagen subida correctamente')),
          );
          _loadProfileImage();
        },
        onError: (error) {
          Navigator.pop(scaffoldContext); // Close the progress dialog
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            SnackBar(content: Text('Error al subir la imagen: $error')),
          );
        },
      );
    } catch (error) {
      Navigator.pop(scaffoldContext); // Close the progress dialog
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(content: Text('Error al subir la imagen: $error')),
      );
    }
  }

  void show(BuildContext context, Function _loadProfileImage) {
    // Captura el contexto de Scaffold antes de cerrar el BottomSheet
    final scaffoldContext = context;

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
                  final authProvider =
                      Provider.of<AuthSessionProvider>(context, listen: false);
                  Navigator.pop(context);
                  _pickImageFromGallery(
                      scaffoldContext, authProvider, _loadProfileImage);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tomar Foto'),
                onTap: () {
                  final authProvider =
                      Provider.of<AuthSessionProvider>(context, listen: false);
                  Navigator.pop(context);
                  _takePhoto(scaffoldContext, authProvider, _loadProfileImage);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
