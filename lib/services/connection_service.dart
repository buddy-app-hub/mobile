import 'package:flutter/material.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/services/api_service_base.dart';

class ConnectionService {
  Future<Connection> getConnection(String id) async {
    var response = await ApiService.get(
      endpoint: "/connections/$id",
    );

    return Connection.fromJson(response);
  }

  Future<void> createConnection(BuildContext context, Connection connection) async {
    await ApiService.post(
      endpoint: "/connections",
      body: connection.toJson(),
    );
  }

  Future<void> updateConnectionMeetings(
      BuildContext context, Connection connection, Meeting meeting) async {
    
    List<Meeting> updatedMeetings = connection.meetings.map((m) {
      if (m.dateLastModification == meeting.dateLastModification) {
        m = meeting;
        m.dateLastModification = DateTime.now(); 
      }
      return m;
    }).toList();

    connection.meetings = updatedMeetings;
    try {
      await ApiService.put(
        endpoint: "/connections/${connection.id}",
        body: connection.toJson(),
      );
      print("Conexión actualizada con éxito");

    } catch (e) {
      print("Error al actualizar la conexión: $e");
    }
  }

  Future<void> createMeetingOfConnection(
      BuildContext context, Connection connection, Meeting meeting) async {
    
    List<Meeting> meetings = List.from(connection.meetings);
    meetings.add(meeting);
    connection.meetings = meetings;
    try {
      await ApiService.put(
        endpoint: "/connections/${connection.id}",
        body: connection.toJson(),
      );
      print("Conexión actualizada con éxito");

    } catch (e) {
      print("Error al actualizar la conexión en create meeting: $e");
    }
  }
}
