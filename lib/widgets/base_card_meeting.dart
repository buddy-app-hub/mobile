import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_location.dart';
import 'package:mobile/models/meeting_schedule.dart';
import 'package:mobile/models/payment_handshake.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/chats/chat_screen.dart';
import 'package:mobile/pages/connections/meetings/edit_meeting.dart';
import 'package:mobile/pages/payment/mercadopago.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/chat_service.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/services/payment_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/base_avatar_stack.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:provider/provider.dart';

UserHelper userHelper = UserHelper();

bool isConfirmed(Meeting m) {
  return m.isConfirmedByBuddy && m.isConfirmedByElder;
}

Future<List<Widget>> fetchMeetingsAsFuture(ThemeData theme, UserData userData) async {
  final stream = fetchMeetings(theme, userData);
  return stream.toList();
}

Future<List<Widget>> fetchNewMeetingsAsFuture(ThemeData theme, UserData userData) async {
  final stream = fetchNewMeetings(theme, userData);
  return stream.toList();
}

Future<List<Widget>> fetchRescheduledMeetingsAsFuture(ThemeData theme, UserData userData) async {
  final stream = fetchRescheduledMeetings(theme, userData);
  return stream.toList();
}

Stream<Widget> fetchMeetings(ThemeData theme, UserData userData) async* {
  List<Connection> connections = await userHelper.fetchConnections(userData);

  for (var connection in connections) {
    yield await buildCards(theme, connection, userData);
  }
}

Stream<Widget> fetchNewMeetings(ThemeData theme, UserData userData) async* {
  List<Connection> connections = await userHelper.fetchConnections(userData);

  for (var connection in connections) {
    yield await buildNewMeetingCards(theme, connection, userData);
  }
}

Stream<Widget> fetchRescheduledMeetings(ThemeData theme, UserData userData) async* {
  List<Connection> connections = await userHelper.fetchConnections(userData);

  for (var connection in connections) {
    yield await buildRescheduledMeetingCards(theme, connection, userData);
  }
}

Future<Widget> buildCards(ThemeData theme, Connection connection, UserData userData) async {
  bool isBuddy = userData.buddy != null;
  String personID, personName;
  (personID,personName) = await userHelper.fetchPersonFullName(connection, isBuddy);
  List<String> images = await fetchAvatars(personID, isBuddy, userData);
  connection.meetings.sort((a,b) => a.schedule.date.compareTo(b.schedule.date));
  List<Meeting> meetings = connection.meetings.where((m) =>
        isDateInNextWeek(m.schedule.date) &&
        !m.isCancelled && m.isConfirmedByBuddy && m.isConfirmedByElder).toList();
  if (meetings.isEmpty) {
    return Column();
  } else {
    Meeting meeting = meetings.first;
    return Column( 
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text(
                'Próximos encuentros',
                style: ThemeTextStyle.titleMediumInverseSurfaceTheme(theme),
              ),
            ),
          ],
        ),
        buildCard(isBuddy, personID, personName, connection, meeting, images),
      ],
    );
  }
}

//TODO que devuelva todas los encuentros reprogramados
Future<Widget> buildRescheduledMeetingCards(ThemeData theme, Connection connection, UserData userData) async {
  bool isBuddy = userData.buddy != null;
  String personID, personName;
  (personID,personName) = await userHelper.fetchPersonFullName(connection, isBuddy);
  List<String> images = await fetchAvatars(personID, isBuddy, userData);
  connection.meetings.sort((a,b) => a.schedule.date.compareTo(b.schedule.date));
  List<Meeting> meetings = connection.meetings.where((m) =>
        isDateInFuture(m.schedule.date) && m.isRescheduled &&
        !m.isCancelled && (!m.isConfirmedByBuddy || !m.isConfirmedByElder)).toList();
  if (meetings.isEmpty) {
    return Column();
  } else {
    List<Widget> meetingCards = meetings.map((meeting) {
      return buildNextEventCard(isBuddy, personID, personName, connection, meeting, images);
    }).toList();

    return Column( 
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text(
                'Encuentros reprogramados',
                style: ThemeTextStyle.titleMediumInverseSurfaceTheme(theme),
              ),
            ),
          ],
        ),
        ...meetingCards,
      ],
    );
  }
}

Future<Widget> buildNewMeetingCards(ThemeData theme, Connection connection, UserData userData) async {
  bool isBuddy = userData.buddy != null;
  String personID, personName;
  (personID,personName) = await userHelper.fetchPersonFullName(connection, isBuddy);
  List<String> images = await fetchAvatars(personID, isBuddy, userData);

  connection.meetings.sort((a,b) => a.schedule.date.compareTo(b.schedule.date));

  List<Meeting> meetings = connection.meetings.where((m) =>
      isDateInFuture(m.schedule.date) && !m.isRescheduled &&
      !m.isCancelled && !isConfirmed(m))
      .where((m) => !isBuddy || !m.isPaymentPending)
      .toList();



  if (meetings.isEmpty) {
    return Column();
  } else {
    List<Widget> meetingCards = meetings.map((meeting) {
      return buildNextEventCard(isBuddy, personID, personName, connection, meeting, images);
    }).toList();

    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text(
                'Encuentros a confirmar',
                style: ThemeTextStyle.titleMediumInverseSurfaceTheme(theme),
              ),
            ),
          ],
        ),
        ...meetingCards,
      ],
    );
  }
}

Future<List<String>> fetchAvatars(String personID, bool isBuddy, UserData userData) async {
  String? imageUser = await userHelper.loadProfileImage(isBuddy ? userData.buddy!.firebaseUID : userData.elder!.firebaseUID);
  String? imageConnection = await userHelper.loadProfileImage(personID);
  return [imageUser, imageConnection];
}

String getDayName(DateTime date) {
  return formatDayOfWeek(date.weekday);
}

String formatTime(MeetingSchedule schedule) {
  return 'De ${intToTime(schedule.startHour)} a ${intToTime(schedule.endHour)}';
}

String formatLocation(MeetingLocation location) {
  return '${location.placeName} - ${location.streetName} ${location.streetNumber}, ${location.city}';
}

BaseCardMeeting buildCard(bool isBuddy, String personID, String personName, Connection connection, Meeting meeting, List<String> images) {
  return BaseCardMeeting(
    isBuddy: isBuddy,
    isNextMeeting: false,
    connection: connection,
    meeting: meeting,
    personID: personID,
    person: personName,
    date: formatMeetingDateShort(meeting.schedule.date),
    time: formatTime(meeting.schedule),
    location: formatLocation(meeting.location),
    avatars: images,
  );
}

BaseCardMeeting buildNextEventCard(bool isBuddy,String personID, String personName, Connection connection, Meeting meeting, List<String> images) {
  return BaseCardMeeting(
    isBuddy: isBuddy,
    isNextMeeting: true,
    connection: connection,
    meeting: meeting,
    personID: personID,
    person: personName,
    date: formatMeetingDateShort(meeting.schedule.date),
    time: formatTime(meeting.schedule),
    location: formatLocation(meeting.location),
    avatars: images,
  );
}

class BaseCardMeeting extends StatelessWidget {
  final bool isBuddy;
  final bool isNextMeeting;
  final Connection connection;
  final Meeting meeting;
  final String personID;
  final String person;
  final String date;
  final String time;
  final String location;
  final List<String> avatars;

  const BaseCardMeeting({
    super.key,
    required this.isBuddy,
    required this.isNextMeeting,
    required this.connection,
    required this.meeting,
    required this.personID,
    required this.person,
    required this.date,
    required this.time,
    required this.location,
    required this.avatars,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
        color: isNextMeeting ? theme.colorScheme.primaryFixed : theme.colorScheme.tertiaryContainer,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: isNextMeeting ? theme.colorScheme.primary : theme.colorScheme.tertiary,
          onTap: () {
            debugPrint('Item tapped.');
          },
          child: Column(
            children: [
              SizedBox(
                width: 375,
                // height: 240,
                child: _buildConnectionInfo(context, theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionInfo(BuildContext context, ThemeData theme) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    final connectionService = ConnectionService();
    UserData userData = authProvider.userData!;
    
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 5, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '${meeting.activity} con $person',
                        style: ThemeTextStyle.titleMediumOnBackground(context),
                      ),
                    ),
                    // SizedBox(width: 12,),
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Reprogramar',
                          child: Text('Reprogramar'),
                        ),
                        PopupMenuItem(
                          value: 'Cancelar',
                          child: Text('Cancelar'),
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Cancelar encuentro'),
                              content: Text('¿Estás seguro de que quieres cancelar el encuentro?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () => Navigator.pop(context), 
                                ),
                                TextButton(
                                  child: Text('Confirmar'),
                                  onPressed: () async{
                                    meeting.isCancelled = true;
                                    await connectionService.updateConnectionMeetings(context, connection, meeting);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Encuentro cancelado')),
                                    );
                                    Navigator.pushNamed(context, Routes.splashScreen);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        print('Selected: $value');
                        // _bottomSheet.show(context, isBuddy, connection, meeting);
                        if (value.contains('Reprogramar')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditMeetingPage(isBuddy: isBuddy, connection: connection, meeting: meeting)),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Text(
                  '📍 $location',
                  style: ThemeTextStyle.titleSmallOnBackground(context),
                ),
                Text(
                  '🗓️ $date',
                  style: ThemeTextStyle.titleSmallOnBackground(context),
                ),
                Text(
                  '🕓 $time',
                  style: ThemeTextStyle.titleSmallOnBackground(context),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(6, 5, 10, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isNextMeeting)
                       buildNewMeetingButton(context, isBuddy, meeting, () async {
                          if (meeting.isPaymentPending) {
                            final paymentService = PaymentService();
                            PaymentHandshake? payment = await paymentService.getHandshake(connection.id!, meeting.meetingID!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MercadoPagoScreen(
                                        url: payment.sandboxInitPoint,
                                      )));
                            return;
                          }
                          final connectionService = ConnectionService();
                          if (isBuddy) {
                            meeting.isConfirmedByBuddy = true;
                          } else {
                            meeting.isConfirmedByElder = true;
                          }
                          await connectionService.updateConnectionMeetings(context, connection, meeting);
                          Navigator.pushNamed(context, Routes.splashScreen);
                        }),
                      if (!isNextMeeting)
                        buildNextMeetingButton(context, userData, () async {
                          final chatService = ChatService();
                          final chatRoomId = await chatService.createChatRoom(
                            person,
                            [personID], userData
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  ChatScreen(chatRoomId: chatRoomId)),
                          );
                        }),
                      Spacer(),
                      Container(
                        width: 150,
                        height: 60,
                        alignment: Alignment.bottomRight,
                        child: BaseAvatarStack(avatars: avatars, spacing: 50,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
