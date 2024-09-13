import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_location.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/chats/chat_screen.dart';
import 'package:mobile/pages/connections/meetings/edit_meeting.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/services/chat_service.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/base_avatar_stack.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:provider/provider.dart';

UserHelper userHelper = UserHelper();

Future<List<Widget>> fetchMeetingsAsFuture(ThemeData theme, UserData userData) async {
  final stream = fetchMeetings(theme, userData);
  return stream.toList();
}

Future<List<Widget>> fetchNewMeetingsAsFuture(ThemeData theme, UserData userData) async {
  final stream = fetchNewMeetings(theme, userData);
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

Future<Widget> buildCards(ThemeData theme, Connection connection, UserData userData) async {
  bool isBuddy = userData.buddy != null;
  String personID, personName;
  (personID,personName) = await userHelper.fetchPersonFullName(connection, isBuddy);
  List<String> images = await fetchAvatars(personID, isBuddy, userData);
  connection.meetings.sort((a,b) => formatTimeOfDayToDate(a.date).compareTo(formatTimeOfDayToDate(b.date)));
  List<Meeting> meetings = connection.meetings.where((m) =>
        validateDate(m.date) &&
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

  Future<Widget> buildNewMeetingCards(ThemeData theme, Connection connection, UserData userData) async {
    bool isBuddy = userData.buddy != null;
    String personID, personName;
    (personID,personName) = await userHelper.fetchPersonFullName(connection, isBuddy);
    List<String> images = await fetchAvatars(personID, isBuddy, userData);
    connection.meetings.sort((a,b) => formatTimeOfDayToDate(a.date).compareTo(formatTimeOfDayToDate(b.date)));
    List<Meeting> meetings = connection.meetings.where((m) =>
          validateFutureDate(m.date) &&
          !m.isCancelled && (!m.isConfirmedByBuddy || !m.isConfirmedByElder)).toList();
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
                  'Encuentros a confirmar',
                  style: ThemeTextStyle.titleMediumInverseSurfaceTheme(theme),
                ),
              ),
            ],
          ),
          buildNextEventCard(isBuddy, personID, personName, connection, meeting, images),
        ],
      );
    }
  }



Future<List<String>> fetchAvatars(String personID, bool isBuddy, UserData userData) async {
  String? imageUser = await userHelper.loadProfileImage(isBuddy ? userData.buddy!.firebaseUID : userData.elder!.firebaseUID);
  String? imageConnection = await userHelper.loadProfileImage(personID);
  return [imageUser, imageConnection];
}

String formatDate(custom_time.TimeOfDay date) {
  return date.dayOfWeek;
}

String formatTime(custom_time.TimeOfDay date) {
  return 'De ${intToTime(date.from)} a ${intToTime(date.to)}';
}

String formatLocation(MeetingLocation location) {
  return '${location.placeName} - ${location.streetName} ${location.streetNumber}, ${location.city}';
}

BaseCardMeeting buildCard(bool isBuddy, String personID, String personName, Connection connection, Meeting meeting, List<String> images) {
  return BaseCardMeeting(
    isBuddy: isBuddy,
    isNextEvent: false,
    connection: connection,
    meeting: meeting,
    personID: personID,
    person: personName,
    date: formatDate(meeting.date),
    time: formatTime(meeting.date),
    location: formatLocation(meeting.location),
    avatars: images,
  );
}

BaseCardMeeting buildNextEventCard(bool isBuddy,String personID, String personName, Connection connection, Meeting meeting, List<String> images) {
  return BaseCardMeeting(
    isBuddy: isBuddy,
    isNextEvent: true,
    connection: connection,
    meeting: meeting,
    personID: personID,
    person: personName,
    date: formatDate(meeting.date),
    time: formatTime(meeting.date),
    location: formatLocation(meeting.location),
    avatars: images,
  );
}

class BaseCardMeeting extends StatelessWidget {
  final bool isBuddy;
  final bool isNextEvent;
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
    required this.isNextEvent,
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
        color: isNextEvent ? theme.colorScheme.primaryFixed : theme.colorScheme.tertiaryContainer,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: isNextEvent ? theme.colorScheme.primary : theme.colorScheme.tertiary,
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
    UserData userData = authProvider.userData!;
    // final MeetingBottomSheet _bottomSheet =
    //   MeetingBottomSheet();
      
    
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        '${meeting.activity} con $person',
                        style: ThemeTextStyle.titleMediumOnBackground(context),
                      ),
                    ),
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
                        ),
                      ],
                      onSelected: (value) {
                        print('Selected: $value');
                        // _bottomSheet.show(context, isBuddy, connection, meeting);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditMeetingPage(isBuddy: isBuddy, connection: connection, meeting: meeting)),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  '📍 $location',
                  style: ThemeTextStyle.titleSmallOnBackground(context),
                ),
                Text(
                  '📅 $date',
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
                      if (isNextEvent)
                       buildNewEventButton(context, isBuddy, meeting, () async {
                          final connectionService = ConnectionService();
                          if (isBuddy) {
                            meeting.isConfirmedByBuddy = true;
                          } else {
                            meeting.isConfirmedByElder = true;
                          }
                          await connectionService.updateConnectionMeetings(context, connection, meeting);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }),
                      if (!isNextEvent)
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
                      // BaseElevatedButton(
                      //   text: 's',
                      //   buttonTextStyle: TextStyle(
                      //     color: isNextEvent ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onTertiary,
                      //     fontSize: 13,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      //   buttonStyle: isNextEvent ? ThemeButtonStyle.primaryRoundedButtonStyle(context) :
                      //       ThemeButtonStyle.tertiaryRoundedButtonStyle(context),
                      //   onPressed: () async {
                      //     final chatService = ChatService();
                      //     final chatRoomId = await chatService.createChatRoom(
                      //       person,
                      //       [personID], userData
                      //     );
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) =>  ChatScreen(chatRoomId: chatRoomId)),
                      //     );
                      //   },
                      //   height: 40,
                      //   width: 120,
                      // ),
                      Spacer(),
                      Container(
                        width: 100,
                        height: 60,
                        alignment: Alignment.bottomRight,
                        child: BaseAvatarStack(avatars: avatars),
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
