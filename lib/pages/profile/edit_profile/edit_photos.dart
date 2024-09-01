import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'dart:io';

import 'package:mobile/services/files_service.dart';
import 'package:provider/provider.dart';

class EditPhotosPage extends StatefulWidget {
  @override
  _EditPhotosPageState createState() => _EditPhotosPageState();
}

class _EditPhotosPageState extends State<EditPhotosPage> {
  final ImagePicker _picker = ImagePicker();
  List<File?> _selectedPhotos = List.filled(6, null);
  List<String?> _photoUrls = List.filled(6, null);
  final FilesService _filesService = FilesService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserPhotos();
  }

  Future<void> _loadUserPhotos() async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    try {
      final List<String?> urls =
          await _filesService.getUserPhotos(authProvider.user!.uid, context);
      setState(() {
        _photoUrls = urls;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading photos: $e');
    }
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedPhotos[index] = File(pickedFile.path);
        _photoUrls[index] =
            null; // Clear the URL since we're picking a new image
      });
    }
  }

  void _showPhotoOptions(int index) {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Eliminar'),
                onTap: () async {
                  Navigator.pop(context); // Cerramos el modal primero

                  setState(() {
                    _isLoading = true; // Mostramos el indicador de carga
                  });

                  try {
                    await _filesService.deletePhoto(
                        authProvider.user!.uid,
                        context,
                        index);
                    await _loadUserPhotos();
                  } catch (e) {
                    print('Error al eliminar la foto: $e');
                  }

                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancelar'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadPhotos() async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    try {
      await _filesService.uploadUserPhotos(
        userId: authProvider.user!.uid,
        images: _selectedPhotos,
        context: context,
        onProgress: (index, progress) {
          // Optional: Handle progress updates here
        },
        onComplete: () {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fotos subidas correctamente')),
          );
        },
        onError: (error) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al subir fotos: $error')),
          );
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error uploading photos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Fotos'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            onPressed: () {
              _uploadPhotos(); // Upload photos when the check button is pressed
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator if loading
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 photos per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (_selectedPhotos[index] == null &&
                          _photoUrls[index] == null) {
                        _pickImage(index);
                      } else {
                        _showPhotoOptions(index);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        image: _selectedPhotos[index] != null
                            ? DecorationImage(
                                image: FileImage(_selectedPhotos[index]!),
                                fit: BoxFit.cover,
                              )
                            : (_photoUrls[index] != null
                                ? DecorationImage(
                                    image: NetworkImage(_photoUrls[index]!),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                      ),
                      child: _selectedPhotos[index] == null &&
                              _photoUrls[index] == null
                          ? Icon(Icons.add_a_photo, color: Colors.grey[700])
                          : null,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
