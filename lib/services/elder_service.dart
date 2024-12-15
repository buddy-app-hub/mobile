import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/connection_preferences.dart';
import 'package:mobile/models/elder.dart';
import 'package:mobile/models/elder_profile.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/models/personal_data.dart';
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
    BuildContext context,
    String newDescription,
  ) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    ElderProfile newProfile = authProvider.userData!.elder!.elderProfile!;
    newProfile.description = newDescription;

    try {
      await updateElderProfile(
        context,
        newProfile,
        authProvider.user!.uid,
        false, // Por ahora la biografia no forma parte del algoritmo de matching asi que no hay que recalcular recomendaciones
      );
      print("Descripción actualizada con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al actualizar la descripción: $e");
    }
  }

  Future<void> updateElderProfileRangeKms(
    BuildContext context,
    int kms,
  ) async {
    UserHelper userHelper = UserHelper();
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    ElderProfile newProfile = authProvider.userData!.elder!.elderProfile!;
    newProfile.connectionPreferences = ConnectionPreferences(maxDistanceKM: kms);

    bool isElderProfileComplete =
        await userHelper.isElderProfileComplete(authProvider.userData!);

    try {
      await updateElderProfile(
        context,
        newProfile,
        authProvider.user!.uid,
        isElderProfileComplete,
      );
      print("Rango ks actualizado con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al actualizar rango kms: $e");
    }
  }

  Future<void> updateProfileInterests(
    BuildContext context,
    List<Interest> newInterests,
  ) async {
    UserHelper userHelper = UserHelper();
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    ElderProfile newProfile = authProvider.userData!.elder!.elderProfile!;
    newProfile.interests = newInterests;

    bool isElderProfileComplete =
        await userHelper.isElderProfileComplete(authProvider.userData!);

    try {
      await updateElderProfile(
        context,
        newProfile,
        authProvider.user!.uid,
        isElderProfileComplete, // Recalculamos reco. budd. solo si el perfil del mayor esta completo
      );
      print("Intereses actualizados con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al actualizar los intereses: $e");
    }
  }

  Future<void> updateProfileAvailability(
    BuildContext context,
    List<custom_time.TimeOfDay> newAvailability,
  ) async {
    UserHelper userHelper = UserHelper();
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    ElderProfile newProfile = authProvider.userData!.elder!.elderProfile!;
    newProfile.availability = newAvailability;

    bool isElderProfileComplete =
        await userHelper.isElderProfileComplete(authProvider.userData!);

    try {
      await updateElderProfile(
        context,
        newProfile,
        authProvider.user!.uid,
        isElderProfileComplete, // Recalculamos reco. budd. solo si el perfil del mayor esta completo
      );
      print("Dispobibilidad actualizada con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al actualizar la disponibilidad: $e");
    }
  }

  Future<void> updateElderProfilePhotosArray(
      BuildContext context, List<String> newPhotosArray) async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    ElderProfile newProfile = authProvider.userData!.elder!.elderProfile!;
    newProfile.photos = newPhotosArray;

    try {
      await updateElderProfile(
        context,
        newProfile,
        authProvider.user!.uid,
        false, // Nunca recalculamos reco. budd. si se cambian las fotos
      );
      print("Array de fotos actualizado con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al actualizar el array de fotos: $e");
    }
  }

  Future<List<Connection>> getConnections(String id) async {
    var response = await ApiService.get<dynamic>(
      endpoint: "/connections/elders/$id",
    );

    List<Connection> connections = (response as List<dynamic>)
        .map((e) => Connection.fromJson(e as Map<String, dynamic>))
        .toList();

    return connections;
  }

  Future<void> updateElderProfile(
    BuildContext context,
    ElderProfile newProfile,
    String uid,
    bool recalcRecoBuddies,
  ) async {
    await ApiService.patch(
      endpoint:
          "/elders/$uid/profile?recalcRecommendedBuddies=$recalcRecoBuddies",
      body: newProfile.toJson(),
    );
  }

  void updateElderPersonalData(
    BuildContext context,
    PersonalData personalData,
  ) async {
    UserHelper userHelper = UserHelper();
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);
    print(personalData.toJson());
    try {
      // Se recalcularan los buddies recomendados del mayor solo si el perfil esta completo
      bool isElderProfileComplete =
          await userHelper.isElderProfileComplete(authProvider.userData!);

      await ApiService.patch(
        endpoint:
            "/elders/${authProvider.user!.uid}/personaldata?recalcRecommendedBuddies=$isElderProfileComplete",
        body: personalData.toJson(),
      );
      print("Personal data actualizada con éxito");

      await authProvider.fetchUserData();
    } catch (e) {
      print("Error al actualizar la personal data: $e");
    }
  }

  /* Solo para usar cuando se termina de completar el perfil con acciones que no recalculan las recomendaciones 
  de manera automatica (por ej. si un elder subio su foto de perfil o su album de fotos) 
  Tiene como precondicion que el perfil del elder debe estar completo */
  void calculateRecommendedBuddies(
    String uid,
  ) async {
    print("Recalculando recomendaciones de buddies directamente...");
    try {
      await ApiService.post(
        endpoint: "/elders/$uid/buddies/recalc",
        body: {},
      );
      print("Peticion de recalculo de recomendacion de buddies con éxito");
    } catch (e) {
      print(
          "Error al intentar hacer la peticion de recalculo de recomendaciones: $e");
    }
  }
}
