import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/navigation.dart';
import 'dart:io';
import 'dart:math';
import 'package:mobile/services/files_service.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class EditPhotosPage extends StatefulWidget {
  @override
  _EditPhotosPageState createState() => _EditPhotosPageState();
}

class _EditPhotosPageState extends State<EditPhotosPage> {
  final ImagePicker _picker = ImagePicker();
  List<File?> _newPhotos = List.filled(6, null);
  List<String?> _storedPhotoUrls = List.filled(6, null);
  final FilesService _filesService = FilesService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserPhotos();
  }

  Future<void> _loadUserPhotos() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<String?> urls =
          await _filesService.getCurrentUserPhotos(context);
      setState(() {
        _storedPhotoUrls = urls;
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
        _newPhotos[index] = File(pickedFile.path);
        _storedPhotoUrls[index] =
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

                  // Si elimino una foto recien subida, la descarto
                  if (_newPhotos.elementAt(index) != null) {
                    setState(() {
                      _newPhotos[index] = null;
                      _storedPhotoUrls[index] = null;
                    });
                    return;
                  }

                  setState(() {
                    _isLoading = true; // Mostramos el indicador de carga
                  });

                  try {
                    await _filesService.deletePhoto(
                        authProvider.user!.uid, context, index);
                    await _loadUserPhotos();
                    _reorderNewPhotosAfterDelete();
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

  Future<void> _uploadPhotos(List<int>? swapFromTo) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    try {
      await _filesService.uploadUserPhotos(
        userId: authProvider.user!.uid,
        images: _newPhotos,
        context: context,
        swapFromTo: swapFromTo,
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
    int firstFreeIndex = max(_getLastNonNullIndex(_newPhotos),
            _getLastNonNullIndex(_storedPhotoUrls)) +
        1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Fotos'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            onPressed: () async {
              await _uploadPhotos(null); // Upload photos when the check button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Navigation(index: 2)),
              );
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
              child: ReorderableGridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(
                  6,
                  (index) {
                    return GestureDetector(
                      key: ValueKey(index),
                      onTap: () {
                        if (index == firstFreeIndex) {
                          // Chequeamos si el índice corresponde al primer cuadrado libre
                          _pickImage(index);
                        } else if (index < firstFreeIndex) {
                          _showPhotoOptions(index);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                          image: _newPhotos[index] != null
                              ? DecorationImage(
                                  image: FileImage(_newPhotos[index]!),
                                  fit: BoxFit.cover,
                                )
                              : (_storedPhotoUrls[index] != null
                                  ? DecorationImage(
                                      image: NetworkImage(_storedPhotoUrls[index]!),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                        ),
                        child: index == firstFreeIndex
                            ? Icon(Icons.add_a_photo, color: Colors.grey[700])
                            : null,
                      ),
                    );
                  },
                ),
                onReorder: (oldIndex, newIndex) async {
                  // La foto que estaba en oldIndex pasa a newIndex (la que arrastre), y la que estaba en newIndex pasa a oldIndex
                  if (oldIndex != newIndex) {
                    if (oldIndex < firstFreeIndex && newIndex < firstFreeIndex) { // Tienen que estar dentro de las fotos que se cargaron
                       setState(() {
                    _isLoading = true;
                  });

                  try {
                    await _uploadPhotos([oldIndex, newIndex]);
                    await _loadUserPhotos();
                  } catch (e) {
                    print('Error al reordernar las fotos: $e');
                  }

                  setState(() {
                    _isLoading = false;
                  });
                      
                    }
                  }
                },
              ),
            ),
    );
  }

  int _getLastNonNullIndex(List<dynamic> list) {
    int lastIndex = -1;
    for (int i = 0; i < list.length; i++) {
      if (list[i] != null) {
        lastIndex = i;
      }
    }
    return lastIndex;
  }

  void _reorderNewPhotosAfterDelete() {
    List<File?> _reorderedNewPhotos = List.filled(6, null);

    for (int i = 0; i < _newPhotos.length; i++) {
      if (_newPhotos[i] != null) {
        _reorderedNewPhotos[i-1] = _newPhotos[i];
      }
    }
    _newPhotos = _reorderedNewPhotos;
  }
}
