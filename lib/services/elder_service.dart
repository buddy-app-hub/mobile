import 'package:flutter/material.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/elder.dart';
import 'package:mobile/models/elder_profile.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/services/api_service_base.dart';
import 'package:provider/provider.dart';

class ElderService {
  Future<Elder> getElder(String id) async {
    var response = await ApiService.get(
      endpoint: "/elders/$id",
    );

    return Elder.fromJson(response);
  }

  Future<void> createElder(BuildContext context, Elder elder) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    try {
      await ApiService.post(
        endpoint: "/elders",
        body: elder.toJson(),
      );
      print("Datos enviados con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al enviar los datos: $e");
    }
  }

  Future<void> updateElderProfileDescription(
      BuildContext context, String newDescription) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    ElderProfile newProfile = authProvider.userData!.elder!.elderProfile!;
    newProfile.description = newDescription;

    try {
      await ApiService.patch(
        endpoint: "/elders/${authProvider.user!.uid}/profile",
        body: newProfile.toJson(),
      );
      print("Descripción actualizada con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al actualizar la descripción: $e");
    }
  }

  Future<void> updateProfileInterests(
      BuildContext context, List<Interest> newInterests) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    ElderProfile newProfile = authProvider.userData!.elder!.elderProfile!;
    newProfile.interests = newInterests;

    try {
      await ApiService.patch(
        endpoint: "/elders/${authProvider.user!.uid}/profile",
        body: newProfile.toJson(),
      );
      print("Intereses actualizados con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al actualizar los intereses: $e");
    }
  }

  Future<void> updateProfileAvailability(
      BuildContext context, List<custom_time.TimeOfDay> newAvailability) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    ElderProfile newProfile = authProvider.userData!.elder!.elderProfile!;
    newProfile.availability = newAvailability;

    try {
      await ApiService.patch(
        endpoint: "/elders/${authProvider.user!.uid}/profile",
        body: newProfile.toJson(),
      );
      print("Dispobibilidad actualizada con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al actualizar la disponibilidad: $e");
    }
  }

  Future<List<Connection>> getConnections(UserData userData) async {
    var response = await ApiService.get<dynamic>(
      endpoint:  "/connections/elders/${userData.elder?.firebaseUID}",
    );

    List<Connection> connections = (response as List<dynamic>)
        .map((e) => Connection.fromJson(e as Map<String, dynamic>))
        .toList();

    return connections;
  }
}
