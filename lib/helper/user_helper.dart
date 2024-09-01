import 'package:mobile/models/connection.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/services/files_service.dart';

class UserHelper {

  BuddyService buddyService = BuddyService();
  ElderService elderService = ElderService();
  FilesService _filesService = FilesService();

  Future<List<Connection>> fetchConnections(UserData userData) async {
    List<Connection> connections;
    if (userData.buddy != null) {
      connections = await buddyService.getConnections(userData);
    } else {
      connections = await elderService.getConnections(userData);
    }

    return connections;
  }

  Future<Object> fetchPersonProfile(String personID, bool isBuddy) async {
    Object? personalProfile = isBuddy
      ? (await elderService.getElder(personID)).elderProfile
      : (await buddyService.getBuddy(personID)).buddyProfile;
    return personalProfile!;
  }

  Future<(String, String)> fetchPersonFullName(Connection connection, bool isBuddy) async {
    String personID;
    if (isBuddy) {
      personID = connection.elderID;
    } else {
      personID = connection.buddyID;
    }
    var personalData = isBuddy
      ? (await elderService.getElder(personID)).personalData
      : (await buddyService.getBuddy(personID)).personalData;
    return (personID, '${personalData.firstName} ${personalData.lastName}');
  }

  Future<(String, String)> fetchPersonIDAndName(Connection connection, bool isBuddy) async {
    String personID;
    if (isBuddy) {
      personID = connection.elderID;
    } else {
      personID = connection.buddyID;
    }
    var personalData = isBuddy
      ? (await elderService.getElder(personID)).personalData
      : (await buddyService.getBuddy(personID)).personalData;
    return (personID, personalData.firstName);
  }

  Future<String> fetchProfileFullName(String personID, bool isBuddy) async {
    var personalData = isBuddy
      ? (await elderService.getElder(personID)).personalData
      : (await buddyService.getBuddy(personID)).personalData;
    return '${personalData.firstName} ${personalData.lastName}';
  }

  Future<String> fetchSenderName(String senderID, UserData userData) async {
    var userID = userData.buddy != null
      ? userData.buddy?.firebaseUID
      : userData.elder?.firebaseUID;
    if (userID == senderID) {
      var personalData = userData.buddy != null
      ? userData.buddy?.personalData
      : userData.elder?.personalData;
      return personalData!.firstName;
    } else {
      var personalData = userData.buddy != null
      ? (await elderService.getElder(senderID)).personalData
      : (await buddyService.getBuddy(senderID)).personalData;
      return personalData.firstName;
    }
  }

  bool isUserSender(String senderID, UserData userData) {
    var userID = userData.buddy != null
      ? userData.buddy?.firebaseUID
      : userData.elder?.firebaseUID;

    return userID == senderID;
  }

  Future<String> loadProfileImage(String personID) async {
    String? imageUrl =
        await _filesService.getProfileImageUrl(personID);
    if (imageUrl == null) {
      return '';
    } else {
      return imageUrl; 
    }
  }
}
