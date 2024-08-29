import 'package:flutter/material.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/elder.dart';
import 'package:mobile/models/elder_profile.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/services/api_service_base.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:provider/provider.dart';

class UserHelper {

  BuddyService buddyService = BuddyService();
  ElderService elderService = ElderService();

  Future<List<Connection>> fetchConnections(UserData userData) async {
    List<Connection> connections;
    if (userData.buddy != null) {
      connections = await buddyService.getConnections(userData);
    } else {
      connections = await elderService.getConnections(userData);
    }

    return connections;
  }


  Future<String> fetchPersonFullName(Connection connection, bool isBuddy) async {
    String personID;
    if (isBuddy) {
      personID = connection.elderID;
    } else {
      personID = connection.buddyID;
    }
    var personalData = isBuddy
      ? (await elderService.getElder(personID)).personalData
      : (await buddyService.getBuddy(personID)).personalData;
    return '${personalData.firstName} ${personalData.lastName}';
  }

  Future<String> fetchPersonName(Connection connection, bool isBuddy) async {
    String personID;
    if (isBuddy) {
      personID = connection.elderID;
    } else {
      personID = connection.buddyID;
    }
    var personalData = isBuddy
      ? (await elderService.getElder(personID)).personalData
      : (await buddyService.getBuddy(personID)).personalData;
    return personalData.firstName;
  }

}
