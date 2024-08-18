import 'package:flutter/material.dart';
import 'package:mobile/models/buddy.dart';
import 'package:mobile/models/buddy_profile.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/services/api_service_base.dart';
import 'package:provider/provider.dart';

class BuddyService {
  Future<Buddy> getBuddy(String id) async {
    var response = await ApiService.get(
      endpoint: "/buddies/$id",
    );

    return Buddy.fromJson(response);
  }

  Future<void> createBuddy(BuildContext context, Buddy buddy) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    try {
      await ApiService.post(
        endpoint: "/buddies",
        body: buddy.toJson(),
      );
      print("Datos enviados con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al enviar los datos: $e");
    }
  }

  Future<void> updateBuddyProfileDescription(
      BuildContext context, String newDescription) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    BuddyProfile newProfile = authProvider.userData!.buddy!.buddyProfile!;
    newProfile.description = newDescription;

    try {
      await ApiService.patch(
        endpoint: "/buddies/${authProvider.user!.uid}/profile",
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

    BuddyProfile newProfile = authProvider.userData!.buddy!.buddyProfile!;
    newProfile.interests = newInterests;

    try {
      await ApiService.patch(
        endpoint: "/buddies/${authProvider.user!.uid}/profile",
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

    BuddyProfile newProfile = authProvider.userData!.buddy!.buddyProfile!;
    newProfile.availability = newAvailability;

    try {
      await ApiService.patch(
        endpoint: "/buddies/${authProvider.user!.uid}/profile",
        body: newProfile.toJson(),
      );
      print("Disponibilidad actualizada con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al actualizar la disponibilidad: $e");
    }
  }
}
