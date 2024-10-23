import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/base_card_meeting.dart';

UserHelper userHelper = UserHelper();

Future<List<Widget>> fetchConfirmedMeetingsAsFuture(
    ThemeData theme, UserData userData, List<Connection> connections) async {
  List<Meeting> allMeetings = [];
  String personID, personName;
  bool isBuddy = userData.buddy != null;

  for (var connection in connections) {
    // Filtra las reuniones no confirmadas o pendientes de pago
    List<Meeting> meetings = connection.meetings
        .where((m) =>
            isDateInNextWeek(m.schedule.date) &&
            !m.isCancelled &&
            !m.isPaymentPending &&
            isConfirmed(m))
        .toList();

    meetings.forEach((meeting) => meeting.connection = connection);

    allMeetings.addAll(meetings);
  }

  sortMeetings(allMeetings);

  List<Widget> meetingCards = [];

  for (var meeting in allMeetings) {
    (personID, personName) =
        await userHelper.fetchPersonFullName(meeting.connection!, isBuddy);

    List<String> images = await fetchAvatars(personID, isBuddy, userData);

    meetingCards.add(
      buildMeetingCard(
        isBuddy,
        personID,
        personName,
        meeting.connection!,
        meeting,
        images,
        true,
      ),
    );
  }

  if (meetingCards.isEmpty) {
    return [SizedBox.shrink()];
  }

  return [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
          child: Text(
            'Próximos encuentros',
            style: ThemeTextStyle.titleMediumInverseSurfaceTheme(theme),
          ),
        ),
        ...meetingCards,
      ],
    ),
  ];
}

Future<List<Widget>> fetchUnconfirmedMeetingsAsFuture(
    ThemeData theme, UserData userData, List<Connection> connections) async {
  List<Meeting> allMeetings = [];
  String personID, personName;
  bool isBuddy = userData.buddy != null;

  for (var connection in connections) {
    // Filtra las reuniones no confirmadas o pendientes de pago
    List<Meeting> meetings = connection.meetings
        .where((m) =>
            isDateInFuture(m.schedule.date) &&
            !m.isCancelled &&
            (!isConfirmed(m) || m.isPaymentPending))
        .where((m) => !isBuddy || !m.isPaymentPending)
        .toList();

    meetings.forEach((meeting) => meeting.connection = connection);

    allMeetings.addAll(meetings);
  }

  sortMeetings(allMeetings);

  List<Widget> meetingCards = [];

  for (var meeting in allMeetings) {
    (personID, personName) =
        await userHelper.fetchPersonFullName(meeting.connection!, isBuddy);

    List<String> images = await fetchAvatars(personID, isBuddy, userData);

    meetingCards.add(
      buildMeetingCard(
        isBuddy,
        personID,
        personName,
        meeting.connection!,
        meeting,
        images,
        false,
      ),
    );
  }

  if (meetingCards.isEmpty) {
    return [SizedBox.shrink()];
  }

  return [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
          child: Text(
            'Encuentros a confirmar',
            style: ThemeTextStyle.titleMediumInverseSurfaceTheme(theme),
          ),
        ),
        ...meetingCards,
      ],
    ),
  ];
}

Future<List<String>> fetchAvatars(
    String personID, bool isBuddy, UserData userData) async {
  String? imageUser = await userHelper.loadProfileImage(
      isBuddy ? userData.buddy!.firebaseUID : userData.elder!.firebaseUID);
  String? imageConnection = await userHelper.loadProfileImage(personID);
  return [imageUser, imageConnection];
}

bool isConfirmed(Meeting m) {
  return m.isConfirmedByBuddy && m.isConfirmedByElder;
}

// Ordena una lista de meetings por fecha y hora de comienzo
void sortMeetings(List<Meeting> meetings) {
  meetings.sort((a, b) {
    int dateComparison = a.schedule.date.compareTo(b.schedule.date);
    if (dateComparison != 0) {
      return dateComparison;
    }
    // Si las fechas son iguales, comparamos por startHour
    return a.schedule.startHour.compareTo(b.schedule.startHour);
  });
}