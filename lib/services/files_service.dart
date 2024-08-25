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
      // Generar la ruta del archivo en Firebase Storage
      final String fileExtension = path.extension(imageFile.path);
      final String filePath = 'users/$userId/profile_image$fileExtension';
      print(filePath);

      // Crear una referencia a Firebase Storage
      final storageRef = _firebaseStorage.ref().child(filePath);

      // Subir el archivo con un controlador de carga
      final uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/${fileExtension.replaceAll('.', '')}'),
      );

      // Escuchar el progreso de la carga
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      // Esperar a que la carga termine
      await uploadTask;

      String downloadUrl = await storageRef.getDownloadURL();
      onComplete(downloadUrl);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<String?> getProfileImageUrl(String userId) async {
    try {
      final storageRef = _firebaseStorage.ref().child('users/$userId/profile_image.jpg'); // TODO: ver que estension usar (o un wildcard)
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error obteniendo URL de imagen de perfil: $e');
      return null;
    }
  }
}
