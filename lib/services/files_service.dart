import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

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
        SettableMetadata(
            contentType: 'image/${fileExtension.replaceAll('.', '')}'),
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
      final storageRef =
          _firebaseStorage.ref().child('users/$userId/profile_image.jpg');
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (! e.toString().contains('object-not-found')) {
        print('Error obteniendo URL de imagen de perfil: $e');
      }
      return null;
    }
  }

  Future<void> uploadUserPhotos({
    required String userId,
    required List<File?> images,
    required BuildContext context,
    List<int>? swapFromTo, 
    required Function(int, double) onProgress,
    required Function onComplete,
    required Function(String) onError,
  }) async {
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    final BuddyService buddyService = BuddyService();
    final ElderService elderService = ElderService();

    List<String> photosArray = authProvider.isBuddy
        ? authProvider.userData!.buddy!.buddyProfile!.photos!
        : authProvider.userData!.elder!.elderProfile!.photos!;

    try {
      for (int i = 0; i < images.length; i++) {
        if (images[i] != null) {
          // Valido que no haya una foto ya cargada en esa posicion
          if (photosArray.length - 1 >= i) {
            throw Exception('Cannot upload a photo in the position of an existing one');
          }

          final imageFile = images[i]!;
          final String fileExtension = path.extension(imageFile.path);
          final String filePath =
              'users/$userId/photos/${imageFile.hashCode}$fileExtension';
          final storageRef = _firebaseStorage.ref().child(filePath);

          final uploadTask = storageRef.putFile(
            imageFile,
            SettableMetadata(
                contentType: 'image/${fileExtension.replaceAll('.', '')}'),
          );

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;
            onProgress(i, progress);
          });

          await uploadTask;

          // Inserto el archivo en el array de imagenes, al final de todo
          photosArray.add(storageRef.name);
        }
      }
      onComplete();

      // Si hubo un reordenamiento por un swap que sea haya hecho, lo reflejamos en el array:
      if (swapFromTo != null) {
        String fromPhoto = photosArray[swapFromTo[0]];
        String toPhoto = photosArray[swapFromTo[1]];
        photosArray[swapFromTo[1]] = fromPhoto;
        photosArray[swapFromTo[0]] = toPhoto;
      }

    // Guardo el nuevo array de fotos en el backend
    if (authProvider.isBuddy) {
      buddyService.updateBuddyProfilePhotosArray(context, photosArray);
    } else {
      elderService.updateElderProfilePhotosArray(context, photosArray);
    }
      
    } catch (e) {
      onError(e.toString());
      print('Error al subir fotos de usuario: $e');
    }
  }

  Future<void> uploadUserDocuments({
    required String userId,
    required Map<String, File?> images,
    required BuildContext context,
    List<int>? swapFromTo, 
    required Function(String, double) onProgress,
    required Function onComplete,
    required Function(String) onError,
  }) async {
    try {
      for (String imageName in images.keys) {
        if (images[imageName] != null) {
          final imageFile = images[imageName]!; // Get the image file
          final String fileExtension = path.extension(imageFile.path);
          final String filePath =
              'users/$userId/identity/$imageName$fileExtension';
          final storageRef = _firebaseStorage.ref().child(filePath);

          final uploadTask = storageRef.putFile(
            imageFile,
            SettableMetadata(
                contentType: 'image/${fileExtension.replaceAll('.', '')}'),
          );

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;
            onProgress(imageName, progress); // Use imageName for progress tracking
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
  
  Future<Map<String, String?>> getCurrentUserDocuments(BuildContext context) async {
    Map<String, String?> photoUrls =  {
      'front_id' : null,
      'back_id' : null,
      'selfie' : null,
    };
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);

    try {
      final storageRef = await _firebaseStorage
        .ref()
        .child('users/${authProvider.user!.uid}/identity')
        .listAll();

      for (var item in storageRef.items) {
        String downloadUrl = await item.getDownloadURL();

        if (item.name.contains('front')) {
          photoUrls['front_id'] = downloadUrl;
        } else if (item.name.contains('back')) {
          photoUrls['back_id'] = downloadUrl;
        } else if (item.name.contains('selfie')) {
          photoUrls['selfie'] = downloadUrl;
        }
      }

    } catch (e) {
      if (e is FirebaseException && e.code != 'object-not-found') {
        print('Error obteniendo fotos del documento para el usuario ${authProvider.user!.uid}: $e');
      }
    }
    return photoUrls;
  }

  Future<List<String?>> getCurrentUserPhotos(BuildContext context) async {
    List<String?> photoUrls = List.filled(6, null);
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    List<String>? photos = authProvider.isBuddy
        ? authProvider.userData!.buddy!.buddyProfile!.photos
        : authProvider.userData!.elder!.elderProfile!.photos;

    int i = 0;
    try {
      final storageRef =
          await _firebaseStorage.ref().child('users/${authProvider.user!.uid}/photos').listAll();
      for (var item in storageRef.items) {
        String downloadUrl = await item.getDownloadURL();
        // Me fijo en que posicion debe estar la foto e inserto la url en esta
        int orderedIndex = photos!.indexOf(item.name);
        photoUrls[orderedIndex] = downloadUrl;
        i++;
      }
    } catch (e) {
      if (e is FirebaseException && e.code != 'object-not-found') {
        print('Error obteniendo fotos para el usuario ${authProvider.user!.uid}: $e');
      }
    }

    if (i != photos!.length) {
      print('IMPORTANTE: la cantidad de fotos en storage es $i pero en la base son ${photos.length}. Revisar users/${authProvider.user!.uid}/photos');
    }

    return photoUrls;
  }

  Future<List<String?>> getUserPhotos(String id, bool isBuddy, BuildContext context) async {
    List<String?> photoUrls = List.filled(6, null);
    List<String>? photos;
    if (isBuddy){
      BuddyService buddyService = BuddyService();
      photos = (await buddyService.getBuddy(id)).buddyProfile!.photos;
    } else {
      ElderService elderService = ElderService();
      photos = (await elderService.getElder(id)).elderProfile!.photos;
    }

    int i = 0;
    try {
      final storageRef =
          await _firebaseStorage.ref().child('users/$id/photos').listAll();
      for (var item in storageRef.items) {
        String downloadUrl = await item.getDownloadURL();
        // Me fijo en que posicion debe estar la foto e inserto la url en esta
        int orderedIndex = photos!.indexOf(item.name);
        photoUrls[orderedIndex] = downloadUrl;
        i++;
      }
    } catch (e) {
      if (e is FirebaseException && e.code != 'object-not-found') {
        print('Error obteniendo fotos para el usuario $id: $e');
      }
    }

    if (i != photos!.length) {
      print('IMPORTANTE: la cantidad de fotos en storage es $i pero en la base son ${photos.length}. Revisar users/$id/photos');
    }

    return photoUrls.where((url) => url != null).toList();
  }

  Future<void> deletePhoto(
      String userId, BuildContext context, int indexPhotoToDelete) async {
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    final BuddyService buddyService = BuddyService();
    final ElderService elderService = ElderService();
    
    List<String>? photos = authProvider.isBuddy
        ? authProvider.userData!.buddy!.buddyProfile!.photos
        : authProvider.userData!.elder!.elderProfile!.photos;

    // Borro la foto del array de fotos
    String photoRemoved = photos!.removeAt(indexPhotoToDelete);
    if (authProvider.isBuddy) {
      buddyService.updateBuddyProfilePhotosArray(context, photos);
    } else {
      elderService.updateElderProfilePhotosArray(context, photos);
    }

    // Borro la foto de Firebase storage
    try {
      final storageRef =
          _firebaseStorage.ref().child('users/$userId/photos/$photoRemoved');
      await storageRef.delete();
    } catch (e) {
      if (e is FirebaseException && e.code != 'object-not-found') {
        print('Error eliminando foto para el usuario $userId: $e');
      }
    }

    return;
  }

  Future<String?> fetchConnectionProfilePic(
      List<String> chatParticipants, String currentUserID) async {
    String personID = chatParticipants.firstWhere((id) => id != currentUserID);

    String? imageUrl = await getProfileImageUrl(personID);

    return imageUrl;
  }
}
