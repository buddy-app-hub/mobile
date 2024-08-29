import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_location.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/models/user_data.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_avatar_stack.dart';
import 'package:mobile/widgets/base_elevated_button.dart';

UserHelper userHelper = UserHelper();

Future<List<Widget>> fetchMeetingsAsFuture(UserData userData) async {
  final stream = fetchMeetings(userData);
  return stream.toList();
}

Stream<Widget> fetchMeetings(UserData userData) async* {
  List<Connection> connections = await userHelper.fetchConnections(userData);

  for (var connection in connections) {
    yield await buildCards(connection, userData);
  }
}

Future<Column> buildCards(Connection connection, UserData userData) async {
  bool isBuddy = userData.buddy != null;
  String personName = await userHelper.fetchPersonFullName(connection, isBuddy);
  return Column(
    children: connection.meetings
        .where((m) =>
            !m.isCancelled && m.isConfirmedByBuddy && m.isConfirmedByElder)
        .map((meeting) => buildCard(personName, meeting))
        .toList(),
  );
}



Future<List<String>> fetchAvatars(String personID, bool isBuddy) async {
  return ['assets/images/avatar.png', 'assets/images/avatarBuddy.jpeg'];
}

String formatDate(custom_time.TimeOfDay date) {
  return "${date.dayOfWeek} 13 de Agosto"; //fix a que sea la fecha completa
}

String formatTime(custom_time.TimeOfDay date) {
  return 'De ${date.from} a ${date.to}';
}

String formatLocation(MeetingLocation location) {
  return '${location.placeName} - ${location.streetName} ${location.streetNumber}, ${location.city}';
}

BaseCardMeeting buildCard(String personName, Meeting meeting) {
  return BaseCardMeeting(
    activity: meeting.activity,
    person: personName,
    date: formatDate(meeting.date),
    time: formatTime(meeting.date),
    location: formatLocation(meeting.location),
    avatars: ['assets/images/avatar.png', 'assets/images/avatarBuddy.jpeg'],
  );
}

class BaseCardMeeting extends StatelessWidget {
  final String activity;
  final String person;
  final String date;
  final String time;
  final String location;
  final List<String> avatars;

  const BaseCardMeeting({
    super.key,
    required this.activity,
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
        color: theme.colorScheme.tertiaryContainer,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: theme.colorScheme.tertiary,
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
                        '$activity con $person',
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
                      BaseElevatedButton(
                        text: "Chat",
                        buttonTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onTertiary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        buttonStyle:
                            ThemeButtonStyle.tertiaryRoundedButtonStyle(
                                context),
                        onPressed: () async {
                          print('voy al chat ?');
                          // Navigator.pushReplacementNamed(context, Routes.homeContent); //fix desaparece el navbar
                        },
                        height: 40,
                        width: 100,
                      ),
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
