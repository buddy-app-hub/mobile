import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/base_card_meeting.dart';

UserHelper userHelper = UserHelper();

// Funcion para filtrar encuentros en curso
bool ongoingMeetingFilter(Meeting m) {
  return isMeetingOngoing(m.schedule) &&
      !m.isCancelled &&
      !m.isPaymentPending &&
      isConfirmed(m);
}

// Funcion para filtrar encuentros terminados y no calificados
bool notReviewedMeetingFilter(Meeting m) {
  return isMeetingEnded(m.schedule) &&
      !m.isCancelled &&
      !m.isPaymentPending &&
      isConfirmed(m) &&
      (m.buddyRatingForElder == null || m.elderRatingForBuddy == null);
}

// Funcion para filtrar encuentros confirmadas
bool confirmedMeetingFilter(Meeting m) {
  return isDateInNextWeek(m.schedule.date) &&
      !m.isCancelled &&
      !m.isPaymentPending &&
      isConfirmed(m);
}

// Funcion para filtrar encuentros no confirmadas o pendientes de pago
bool unconfirmedMeetingFilter(Meeting m, bool isBuddy) {
  return isDateInFuture(m.schedule.date) &&
      !m.isCancelled &&
      (!isConfirmed(m) || m.isPaymentPending) &&
      (!isBuddy || !m.isPaymentPending);
}

Future<List<Widget>> fetchOngoingMeetingsAsFuture(
    ThemeData theme, UserData userData, List<Connection> connections) {
  return fetchMeetingsAsFuture(
    theme,
    userData,
    connections,
    ongoingMeetingFilter,
    'Encuentro en curso !',
    true,
  );
}

Future<List<Widget>> fetchNotReviewedMeetingsAsFuture(
    ThemeData theme, UserData userData, List<Connection> connections) {
  return fetchMeetingsAsFuture(
    theme,
    userData,
    connections,
    notReviewedMeetingFilter,
    'Encuentros pendientes de calificar',
    true,
  );
}

Future<List<Widget>> fetchConfirmedMeetingsAsFuture(
    ThemeData theme, UserData userData, List<Connection> connections) {
  return fetchMeetingsAsFuture(
    theme,
    userData,
    connections,
    confirmedMeetingFilter,
    'Próximos encuentros confirmados',
    true,
  );
}

Future<List<Widget>> fetchUnconfirmedMeetingsAsFuture(
    ThemeData theme, UserData userData, List<Connection> connections) {
  bool isBuddy = userData.buddy != null;
  return fetchMeetingsAsFuture(
    theme,
    userData,
    connections,
    (m) => unconfirmedMeetingFilter(m, isBuddy),
    'Encuentros a confirmar',
    false,
  );
}

Future<List<Widget>> fetchMeetingsAsFuture(
  ThemeData theme,
  UserData userData,
  List<Connection> connections,
  bool Function(Meeting) filterFunction,
  String titleText,
  bool isConfirmedMeeting,
) async {
  List<Meeting> allMeetings = [];
  bool isBuddy = userData.buddy != null;

  for (var connection in connections) {
    // Filtra las  encuentros basado en la funcion que se pasa como argumento
    List<Meeting> meetings = connection.meetings.where(filterFunction).toList();

    meetings.forEach((meeting) => meeting.connection = connection);

    allMeetings.addAll(meetings);
  }

  // Ordena todas las encuentros por fecha y hora
  sortMeetings(allMeetings);

  List<Widget> meetingCards = await buildMeetingCards(
      allMeetings, isBuddy, userData, isConfirmedMeeting);

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
            titleText,
            style: ThemeTextStyle.titleMediumInverseSurfaceTheme(theme),
          ),
        ),
        ...meetingCards,
      ],
    ),
  ];
}

// Construye las tarjetas de encuentros
Future<List<Widget>> buildMeetingCards(List<Meeting> meetings, bool isBuddy,
    UserData userData, bool isConfirmedMeeting) async {
  List<Widget> meetingWidgets = [];

  for (var meeting in meetings) {
    var (personID, personName) =
        await userHelper.fetchPersonFullName(meeting.connection!, isBuddy);

    List<String> images = await fetchAvatars(personID, isBuddy, userData);

    meetingWidgets.add(
      buildMeetingCard(
        isBuddy,
        personID,
        personName,
        meeting.connection!,
        meeting,
        images,
        isConfirmedMeeting,
      ),
    );
  }

  return meetingWidgets;
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
