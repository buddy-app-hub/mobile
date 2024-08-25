import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FilesService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadProfileImage({
    required String userId,
    required File imageFile,
    required Function(double) onProgress,
    required Function(String) onComplete,
    required Function(String) onError,
  }) async {
    try {
      final String fileExtension = path.extension(imageFile.path);
      final String filePath = 'users/$userId/profile_image$fileExtension';
      print(filePath);

      final storageRef = _firebaseStorage.ref().child(filePath);

      final uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/${fileExtension.replaceAll('.', '')}'),
      );

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      await uploadTask;

      String downloadUrl = await storageRef.getDownloadURL();
      onComplete(downloadUrl);
    } catch (e) {
      onError(e.toString());
      print(e.toString());
    }
  }

  Future<String?> getProfileImageUrl(String userId) async {
    try {
      final storageRef = _firebaseStorage.ref().child('users/$userId/profile_image.jpg');
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error obteniendo URL de imagen de perfil: $e');
      return null;
    }
  }

  Future<void> uploadUserPhotos({
    required String userId,
    required List<File?> images,
    required Function(int, double) onProgress,
    required Function onComplete,
    required Function(String) onError,
  }) async {
    try {
      for (int i = 0; i < images.length; i++) {
        if (images[i] != null) {
          final imageFile = images[i]!;
          final String fileExtension = path.extension(imageFile.path);
          final String filePath = 'users/$userId/photos/${i + 1}_photo$fileExtension';
          final storageRef = _firebaseStorage.ref().child(filePath);

          final uploadTask = storageRef.putFile(
            imageFile,
            SettableMetadata(contentType: 'image/${fileExtension.replaceAll('.', '')}'),
          );

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;
            onProgress(i, progress);
          });

          await uploadTask;
        }
      }
      onComplete();
    } catch (e) {
      onError(e.toString());
      print('Error al subir fotos de usuario: $e');
    }
  }

  Future<List<String?>> getUserPhotos(String userId) async {
    List<String?> photoUrls = [];
    try {
      for (int i = 1; i <= 6; i++) {
        final storageRef = _firebaseStorage.ref().child('users/$userId/photos/${i}_photo.jpg');
        try {
          String downloadUrl = await storageRef.getDownloadURL();
          photoUrls.add(downloadUrl);
        } catch (e) {
          print('Error obteniendo URL de la foto ${i}: $e');
          photoUrls.add(null); // Add null if photo not found
        }
      }
    } catch (e) {
      print('Error obteniendo fotos de usuario: $e');
    }
    return photoUrls;
  }
}
