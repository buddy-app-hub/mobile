import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/navigation.dart';
import 'dart:io';
import 'dart:math';
import 'package:mobile/services/files_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EditDocumentationPage extends StatefulWidget {
  @override
  _EditDocumentationPageState createState() => _EditDocumentationPageState();
}

class _EditDocumentationPageState extends State<EditDocumentationPage> {
  final ImagePicker _picker = ImagePicker();
  Map<String, File?> _newPhotos = {
    'front_id' : null,
    'back_id' : null,
    'selfie' : null,
  };
  Map<String, String?> _storedPhotoUrls = {
    'front_id' : null,
    'back_id' : null,
    'selfie' : null,
  };
  final FilesService _filesService = FilesService();
  bool _isLoading = false;
  PageController _pageController = PageController();
  bool enableSendDocument = false;

  @override
  void initState() {
    super.initState();
    _loadUserDocuments();
  }

  Future<void> _loadUserDocuments() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Map<String, String?> urlsMap = await _filesService.getCurrentUserDocuments(context);
      
      setState(() {
        _storedPhotoUrls = urlsMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading photos: $e');
    }
  }


  bool _areAllPicturesSelected() {
    for (String key in _newPhotos.keys) {
      if (_newPhotos[key] == null && _storedPhotoUrls[key] == null) {
        return false;
      }
    }
    return true;
  }

  void _checkAllPicturesSelected() {
    setState(() {
      enableSendDocument = _areAllPicturesSelected();
    });
  }

  void _checkIfAllPhotosSelected() {
    bool allPhotosSelected = true;

    for (String key in _newPhotos.keys)  {
      if (_newPhotos[key] == null && _storedPhotoUrls[key] == null) {
        allPhotosSelected = false;
        break;
      }
    }

    setState(() {
      enableSendDocument = allPhotosSelected;
    });
  }


  Future<void> _pickImage(String photoType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newPhotos[photoType] = File(pickedFile.path);
        _storedPhotoUrls[photoType] =
            null;
      });
      _checkAllPicturesSelected(); 
    }
  }

  void _showPhotoOptions(String index) {

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
                  Navigator.pop(context); 

                  if (_newPhotos[index] != null) {
                    setState(() {
                      _newPhotos[index] = null;
                      _storedPhotoUrls[index] = null;
                    });
                    _checkIfAllPhotosSelected();
                    return;
                  }

                  setState(() {
                    _isLoading = true; // Mostramos el indicador de carga
                  });

                  try {
                    await _loadUserDocuments();
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

  Future<void> _uploadDocumentsPhotos(List<int>? swapFromTo) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    try {
      await _filesService.uploadUserDocuments(
        userId: authProvider.user!.uid,
        images: _newPhotos,
        context: context,
        swapFromTo: swapFromTo,
        onProgress: (index, progress) {
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

  Future<void> sendDocument() async {
    await _uploadDocumentsPhotos(null);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Navigation(index: 2)),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SmoothPageIndicator(    
            controller: _pageController,   
            count: 3,    
            effect:  WormEffect(
              activeDotColor: theme.colorScheme.onPrimaryFixedVariant,
              dotColor: theme.colorScheme.outlineVariant,
            ),   
            onDotClicked: (index){    
            }
          )    
        ),
      ),
      body: _isLoading
      ? Center(
          child:
              CircularProgressIndicator())
      : Stack(
        children: [
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx < -10 && _canGoToNextPage()) {
                _goToNextPage();
              } else if (details.delta.dx > 10 && _canGoToPreviousPage()) {
                _goToPreviousPage();
              }
            },
            child: PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              onPageChanged: (index) {
              },
              itemBuilder: (context, index) {
                return Center(
                  child: _createStepsDescription(context, theme, index),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: ElevatedButton(
          onPressed: enableSendDocument ? sendDocument : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            backgroundColor: theme.colorScheme.inversePrimary,
          ),
          child: Text(
            'Finalizar verificación',
            style:
                TextStyle(color: theme.colorScheme.onPrimaryContainer, fontSize: 16),
          ),
        ),
      ),
    );
  }


 
  bool _canGoToNextPage() {
    int currentPage = _pageController.page!.toInt();

    switch (currentPage) {
      case 0:
        return _newPhotos['front_id'] != null || _storedPhotoUrls['front_id'] != null;
      case 1:
        return _newPhotos['back_id'] != null || _storedPhotoUrls['back_id'] != null;
      default:
        return false;
    }
  }

  bool _canGoToPreviousPage() {
    int currentPage = _pageController.page!.toInt();
    return currentPage > 0;
  }

  void _goToNextPage() {
    _pageController.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  void _goToPreviousPage() {
    _pageController.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  int _getLastNonNullIndex(Map<String, dynamic> map) {
    int lastIndex = -1;
    List<String> keys = map.keys.toList();

    for (int i = 0; i < keys.length; i++) {
      if (map[keys[i]] != null) {
        lastIndex = i;
      }
    }

    return lastIndex;
  }


  

  Widget _createStepsDescription(BuildContext context, ThemeData theme, int index) {
    int firstFreeIndex = max(_getLastNonNullIndex(_newPhotos),
        _getLastNonNullIndex(_storedPhotoUrls)) +
    1;
    if (index == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(28, 30, 28, 10),
            child: Text(
              'Tomar foto del frente del documento',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(18, 20, 40, 40),
            child: Text(
              'Verificá que la foto se vea clara.',
              style: ThemeTextStyle.titleSmallOutline(context),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: GestureDetector(
                key: ValueKey(index),
                onTap: () {
                  if (index == firstFreeIndex) {
                    _pickImage('front_id');
                  } else if (index < firstFreeIndex) {
                    _showPhotoOptions('front_id');
                  }
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(8),
                      image: _newPhotos['front_id'] != null
                          ? DecorationImage(
                              image: FileImage(_newPhotos['front_id']!),
                              fit: BoxFit.cover,
                            )
                          : (_storedPhotoUrls['front_id'] != null
                              ? DecorationImage(
                                  image: NetworkImage(_storedPhotoUrls['front_id']!),
                                  fit: BoxFit.cover,
                                )
                              : null),
                    ),
                    child: _newPhotos['front_id'] == null && _storedPhotoUrls['front_id'] == null
                        ? Icon(Icons.add_a_photo, color: theme.colorScheme.outline)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (index == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(28, 30, 28, 10),
            child: Text(
              'Tomar foto del dorso del documento',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(18, 20, 40, 40),
            child: Text(
              'Verificá que la foto se vea clara.',
              style: ThemeTextStyle.titleSmallOutline(context),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: GestureDetector(
                key: ValueKey(index),
                onTap: () {
                  if (index == firstFreeIndex) {
                    _pickImage('back_id');
                  } else if (index < firstFreeIndex) {
                    _showPhotoOptions('back_id');
                  }
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(8),
                      image: _newPhotos['back_id'] != null
                          ? DecorationImage(
                              image: FileImage(_newPhotos['back_id']!),
                              fit: BoxFit.cover,
                            )
                          : (_storedPhotoUrls['back_id'] != null
                              ? DecorationImage(
                                  image: NetworkImage(_storedPhotoUrls['back_id']!),
                                  fit: BoxFit.cover,
                                )
                              : null),
                    ),
                    child: _newPhotos['back_id'] == null && _storedPhotoUrls['back_id'] == null
                        ? Icon(Icons.add_a_photo, color: theme.colorScheme.outline)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(28, 30, 28, 10),
            child: Text(
              'Tomar selfie para completar la verificación',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(28, 20, 40, 0),
            child: Text(
              'Verificá estar en un lugar con luz.\nNo tengas anteojos y/o gorra puestos.',
              style: ThemeTextStyle.titleSmallOutline(context),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: GestureDetector(
                key: ValueKey(index),
                onTap: () {
                  if (index == firstFreeIndex) {
                    _pickImage('selfie');
                  } else if (index < firstFreeIndex) {
                    _showPhotoOptions('selfie'); 
                  }
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(8),
                      image: _newPhotos['selfie'] != null
                          ? DecorationImage(
                              image: FileImage(_newPhotos['selfie']!),
                              fit: BoxFit.cover,
                            )
                          : (_storedPhotoUrls['selfie'] != null
                              ? DecorationImage(
                                  image: NetworkImage(_storedPhotoUrls['selfie']!),
                                  fit: BoxFit.cover,
                                )
                              : null),
                    ),
                    child: _newPhotos['selfie'] == null && _storedPhotoUrls['selfie'] == null
                        ? Icon(Icons.add_a_photo, color: theme.colorScheme.outline)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
