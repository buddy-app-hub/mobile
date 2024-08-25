import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPhotosPage extends StatefulWidget {
  @override
  _EditPhotosPageState createState() => _EditPhotosPageState();
}

class _EditPhotosPageState extends State<EditPhotosPage> {
  final ImagePicker _picker = ImagePicker();
  List<File?> _selectedPhotos = List.filled(6, null);

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedPhotos[index] = File(pickedFile.path);
      });
    }
  }

  void _showPhotoOptions(int index) {
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
                onTap: () {
                  setState(() {
                    _selectedPhotos[index] = null;
                  });
                  Navigator.pop(context);
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 fotos por fila
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (_selectedPhotos[index] == null) {
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
                      : null,
                ),
                child: _selectedPhotos[index] == null
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
