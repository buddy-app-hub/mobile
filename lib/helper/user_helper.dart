import 'package:flutter/material.dart';
import 'package:mobile/models/address.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/review.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/services/files_service.dart';
import 'package:provider/provider.dart';

class UserHelper {
  BuddyService buddyService = BuddyService();
  ElderService elderService = ElderService();
  FilesService _filesService = FilesService();

  Future<List<Connection>> fetchConnections(UserData userData) async {
    List<Connection> connections;
    if (userData.buddy != null) {
      connections =
          await buddyService.getConnections(userData.buddy!.firebaseUID);
    } else {
      connections =
          await elderService.getConnections(userData.elder!.firebaseUID);
    }

    return connections;
  }

  Future<List<Meeting>> fetchMeetingCurrentWeek(String id, bool isBuddy) async {
    List<Connection> connections;
    if (isBuddy) {
      connections = await buddyService.getConnections(id);
    } else {
      connections = await elderService.getConnections(id);
    }

    DateTime now = DateTime.now();
    DateTime weekFromNow = now.add(Duration(days: 6));

    List<Meeting> meeting = connections
        .expand((connection) => connection.meetings)
        .where((meeting) {
      final meetingDate = meeting.schedule.date;
      return meetingDate.isAfter(now.subtract(Duration(days: 1))) &&
          meetingDate.isBefore(weekFromNow) && !meeting.isCancelled;
    }).toList();

    return meeting;
  }

  Future<Map<Meeting, Review>> fetchReviews(String id, bool isBuddy) async {
    List<Connection> connections;
    if (isBuddy) {
      connections = await buddyService.getConnections(id);
    } else {
      connections = await elderService.getConnections(id);
    }
    Map<Meeting, Review> reviews = {
      for (var connection in connections)
        for (var meeting in connection.meetings)
          if (isBuddy && meeting.elderReviewForBuddy != null)
            meeting: meeting.elderReviewForBuddy!
          else if (!isBuddy && meeting.buddyReviewForElder != null)
            meeting: meeting.buddyReviewForElder!
    };

    return Map.fromEntries(reviews.entries.toList()
      ..sort((a, b) => b.value.rating.compareTo(a.value.rating)));
  }

  Future<int> fetchExperience(String id, bool isBuddy) async {
    List<Connection> connections;
    if (isBuddy) {
      connections = await buddyService.getConnections(id);
    } else {
      connections = await elderService.getConnections(id);
    }

    DateTime now = DateTime.now();

    List<Meeting> pastMeetings = connections
        .expand((connection) => connection.meetings)
        .where((meeting) {
      final meetingDate = meeting.schedule.date;
      return now.isAfter(meetingDate) && !meeting.isCancelled && meeting.isConfirmedByBuddy && meeting.isConfirmedByElder;
    }).toList();

    int totalHours = pastMeetings
    .map((m) => (m.schedule.endHour - m.schedule.startHour) / 100)
    .fold(0.0, (sum, hours) => sum + hours).round();

    return totalHours;
  }

  Future<int> fetchTotalMeetings(String id, bool isBuddy) async {
    List<Connection> connections;
    if (isBuddy) {
      connections = await buddyService.getConnections(id);
    } else {
      connections = await elderService.getConnections(id);
    }

    DateTime now = DateTime.now();

    List<Meeting> pastMeetings = connections
        .expand((connection) => connection.meetings)
        .where((meeting) {
      final meetingDate = meeting.schedule.date;
      return now.isAfter(meetingDate) && !meeting.isCancelled && meeting.isConfirmedByBuddy && meeting.isConfirmedByElder;
    }).toList();

    return pastMeetings.length;
  }

  Future<int> fetchTotalConnections(String id, bool isBuddy) async {
    List<Connection> connections;
    if (isBuddy) {
      connections = await buddyService.getConnections(id);
    } else {
      connections = await elderService.getConnections(id);
    }

    return connections.length;
  }


  Future<Object> fetchPersonProfile(String personID, bool isBuddy) async {
    Object? personalProfile = isBuddy
        ? (await elderService.getElder(personID)).elderProfile
        : (await buddyService.getBuddy(personID)).buddyProfile;
    return personalProfile!;
  }

  Future<(String, String)> fetchPersonFullName(
      Connection connection, bool isBuddy) async {
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

  Future<(String, String)> fetchPersonIDAndName(
      Connection connection, bool isBuddy) async {
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
        ? (await buddyService.getBuddy(personID)).personalData
        : (await elderService.getElder(personID)).personalData;
    return '${personalData.firstName} ${personalData.lastName}';
  }

  Future<List<custom_time.TimeOfDay>?> fetchProfileAvailability(
      String personID, bool isBuddy) async {
    var personalData = isBuddy
        ? (await elderService.getElder(personID)).elderProfile?.availability
        : (await buddyService.getBuddy(personID)).buddyProfile?.availability;
    return personalData;
  }

  Future<List<custom_time.TimeOfDay>?> fetchProfileMeetings(
      String personID, bool isBuddy) async {
    var personalData = isBuddy
        ? (await elderService.getElder(personID)).elderProfile?.availability
        : (await buddyService.getBuddy(personID)).buddyProfile?.availability;
    return personalData;
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
    String? imageUrl = await _filesService.getProfileImageUrl(personID);
    if (imageUrl == null) {
      return '';
    } else {
      return imageUrl;
    }
  }

  bool isUserIdentityVerified(UserData userData) {
    var isIdentityValidated =
        userData.buddy != null ? userData.buddy!.isIdentityValidated : true;

    return isIdentityValidated;
  }

  bool isUserBiographyCompleted(UserData userData) {
    var userBiography = userData.buddy != null
        ? userData.buddy?.buddyProfile!.description
        : userData.elder?.elderProfile!.description;

    return userBiography != null && userBiography.isNotEmpty;
  }

  bool isUserAddressCompleted(UserData userData) {
    var userAddress = userData.buddy != null
        ? userData.buddy?.personalData.address
        : userData.elder?.personalData.address;

    return isAddressCompleted(userAddress);
  }

  bool isUserPhotoAlbumCompleted(UserData userData) {
    var photoAlbum = userData.buddy != null
        ? userData.buddy?.buddyProfile!.photos
        : userData.elder?.elderProfile!.photos;

    return photoAlbum != null && photoAlbum.isNotEmpty;
  }

  bool isUserInterestCompleted(UserData userData) {
    var interests = userData.buddy != null
        ? userData.buddy?.buddyProfile!.interests
        : userData.elder?.elderProfile!.interests;

    return interests != null && interests.isNotEmpty;
  }

  bool isUserAvailabilityCompleted(UserData userData) {
    var availability = userData.buddy != null
        ? userData.buddy?.buddyProfile!.availability
        : userData.elder?.elderProfile!.availability;

    return availability != null && availability.isNotEmpty;
  }

  Future<bool> isIntroVideoUploaded(
      BuildContext context, UserData userData) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);
    final userId = authProvider.user?.uid ?? '';
    final url = await _filesService.getIntroVideo(userId);

    return url != null;
  }

  bool isUserBuddyApplicationCompleted(UserData userData) {
    var applicationCompleted =
        userData.buddy != null ? userData.buddy!.isApprovedBuddy : true;

    return applicationCompleted;
  }

  bool isAddressCompleted(Address? address) {
    return address != null &&
        address.streetName != null &&
        address.streetName != "" &&
        address.streetNumber != null &&
        address.streetNumber != 0 &&
        address.postalCode != null &&
        address.postalCode != "" &&
        address.city != null &&
        address.city != "";
  }
}
