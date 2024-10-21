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

  Future<void> createConnection(
      BuildContext context, Connection connection) async {
    await ApiService.post(
      endpoint: "/connections",
      body: connection.toJson(),
    );
  }

  Future<void> createMeetingOfConnection(
      BuildContext context, Connection connection, Meeting meeting) async {
    try {
      await ApiService.post(
        endpoint: "/connections/${connection.id}/meetings",
        body: meeting.toJson(),
      );
      print("Meeting creada con éxito");
    } catch (e) {
      print("Error al crear la meeting: $e");
    }
  }

    Future<void> updateMeetingOfConnection(
      BuildContext context, Connection connection, Meeting meeting) async {
      print("En updateMeetingOfConnection: ${meeting.toString()}");
    try {
      await ApiService.put(
        endpoint: "/connections/${connection.id}/meetings/${meeting.meetingID}",
        body: meeting.toJson(),
      );
      print("Meeting actualizado con éxito");
    } catch (e) {
      print("Error al actualizar el meeting: $e");
    }
  }
}
