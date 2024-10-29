import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_location.dart';
import 'package:mobile/models/meeting_schedule.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/meetings/edit_meeting.dart';
import 'package:mobile/pages/payment/mercadopago.dart';
import 'package:mobile/pages/profile/review/add_review.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/services/payment_service.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';
import 'package:mobile/widgets/base_avatar_stack.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:provider/provider.dart';

BaseCardMeeting buildMeetingCard(
    bool isBuddy,
    String personID,
    String personName,
    Connection connection,
    Meeting meeting,
    List<String> images,
    bool isConfirmedByBoth) {
  return BaseCardMeeting(
    isBuddy: isBuddy,
    isConfirmedByBoth: isConfirmedByBoth,
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

BaseAlertCartMeeting buildPendingReviewCard(bool isBuddy, String personID, String personName, Connection connection, Meeting meeting, String image) {
  return BaseAlertCartMeeting(
    isBuddy: isBuddy,
    connection: connection,
    meeting: meeting,
    personID: personID,
    person: personName,
    date: formatMeetingDateShort(meeting.schedule.date),
    time: formatTime(meeting.schedule),
    location: formatLocation(meeting.location),
    avatar: image,
  );
}

class BaseCardMeeting extends StatelessWidget {
  final bool isBuddy;
  final bool isConfirmedByBoth;
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
    required this.isConfirmedByBoth,
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
        color: isConfirmedByBoth
            ? theme.colorScheme.primaryFixed
            : theme.colorScheme.tertiaryContainer,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: isConfirmedByBoth
              ? theme.colorScheme.primary
              : theme.colorScheme.tertiary,
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
                Wrap(
                  spacing: 4.0, // Espacio horizontal entre los chips
                  runSpacing: 1.0, // Espacio vertical cuando se wrapee
                  children: [
                    meeting.isRescheduled && !isConfirmedByBoth
                        ? buildRescheduledChip(context, theme)
                        : SizedBox.shrink(),
                    isUnconfirmedByYou(meeting, authProvider.isBuddy)
                        ? buildUnconfirmedByYouChip(context, theme)
                        : SizedBox.shrink(),
                    isUnconfirmedByYourConn(meeting, authProvider.isBuddy)
                        ? buildUnconfirmedByYourConnectionChip(
                            context, theme, authProvider.isBuddy)
                        : SizedBox.shrink(),
                  ]
                      .where((widget) => widget is! SizedBox)
                      .toList(), // Filtrar SizedBox.shrink()
                ),
                SizedBox(
                  height: 5,
                ),
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
                              content: Text(
                                  '¿Estás seguro de que quieres cancelar el encuentro?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text('Confirmar'),
                                  onPressed: () async {
                                    meeting.isCancelled = true;
                                    await connectionService
                                        .updateMeetingOfConnection(
                                            context, connection, meeting);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Encuentro cancelado')),
                                    );
                                    Navigator.pushNamed(
                                        context, Routes.splashScreen);
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
                            MaterialPageRoute(
                                builder: (context) => EditMeetingPage(
                                    isBuddy: isBuddy,
                                    connection: connection,
                                    meeting: meeting)),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isBuddy && meeting.isPaymentPending)
                            PaymentButton(
                                meeting: meeting, connectionId: connection.id!),
                          if (!meeting.isPaymentPending &&
                              meeting.isConfirmedByElder)
                            ChatButton(
                                currentUserData: userData,
                                connectedPersonID: personID,
                                connectedPersonName: person),
                          if (!meeting.isPaymentPending &&
                              meeting.isConfirmedByElder &&
                              ((isBuddy && !meeting.isConfirmedByBuddy) ||
                                  (!isBuddy && !meeting.isConfirmedByElder)))
                            SizedBox(
                                height:
                                    10), // Espaciado condicional solo cuando ambos botones de Chat y Confirmar estan presentes
                          if ((isBuddy && !meeting.isConfirmedByBuddy) ||
                              !isBuddy &&
                                  !meeting.isConfirmedByElder &&
                                  !meeting.isPaymentPending)
                            ConfirmButton(
                                isBuddy: isBuddy,
                                connection: connection,
                                meeting: meeting),
                        ],
                      ),
                      Spacer(),
                      Container(
                        width: 150,
                        height: 60,
                        alignment: Alignment.bottomRight,
                        child: BaseAvatarStack(
                          avatars: avatars,
                          spacing: 50,
                        ),
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

  Widget buildRescheduledChip(BuildContext context, ThemeData theme) => Chip(
        label: Text(
          'Reprogramado',
          style: TextStyle(
            color: theme.colorScheme.onTertiary,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        backgroundColor: theme.colorScheme.tertiary,
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
      );

  Widget buildUnconfirmedByYouChip(BuildContext context, ThemeData theme) =>
      Chip(
        label: Text(
          'A confirmar por vos',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
      );

  Widget buildUnconfirmedByYourConnectionChip(
          BuildContext context, ThemeData theme, bool isCurrUserBuddy) =>
      Chip(
        label: Text(
          isCurrUserBuddy
              ? 'A confirmar por tu mayor'
              : 'A confirmar por tu Buddy',
          style: TextStyle(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        backgroundColor: theme.colorScheme.secondary,
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
      );
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

bool isUnconfirmedByYou(Meeting m, bool isCurrUserBuddy) {
  return (isCurrUserBuddy && m.isConfirmedByBuddy == false) ||
      (!isCurrUserBuddy && m.isConfirmedByElder == false);
}

bool isUnconfirmedByYourConn(Meeting m, bool isCurrUserBuddy) {
  return (isCurrUserBuddy && m.isConfirmedByElder == false) ||
      (!isCurrUserBuddy && m.isConfirmedByBuddy == false);
}

class BaseAlertCartMeeting extends StatelessWidget {
  final bool isBuddy;
  final Connection connection;
  final Meeting meeting;
  final String personID;
  final String person;
  final String date;
  final String time;
  final String location;
  final String avatar;

  const BaseAlertCartMeeting({
    super.key,
    required this.isBuddy,
    required this.connection,
    required this.meeting,
    required this.personID,
    required this.person,
    required this.date,
    required this.time,
    required this.location,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.tertiary,
        ),
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.tertiaryContainer.withOpacity(0.5),
      ),
      padding: EdgeInsets.all(12),
      child: _buildConnectionInfo(context, theme),
    );
  }

  Widget _buildConnectionInfo(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundImage: avatar.isEmpty
              ? AssetImage('assets/images/default_user.jpg')
              : CachedNetworkImageProvider(avatar) as ImageProvider,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Opina sobre ${meeting.activity.toLowerCase()} con $person',
                style: ThemeTextStyle.itemLargeOnBackground(context),
                overflow: TextOverflow.clip,
              ),
              // SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: BaseElevatedButton(
                    text: 'Opinar',
                    buttonTextStyle: TextStyle(
                      color: theme.colorScheme.onTertiaryContainer,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                    buttonStyle: ThemeButtonStyle.tertiaryFixedRoundedButtonStyle(context),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddReviewPage(
                          isBuddy: isBuddy,
                          connection: connection,
                          meeting: meeting,
                          personID: personID,
                          personName: person,
                        ),
                      ),
                    ),
                    height: 36,
                    width: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}