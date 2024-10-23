import 'package:flutter/material.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_location.dart';
import 'package:mobile/models/meeting_schedule.dart';
import 'package:mobile/models/payment_handshake.dart';
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
    isNextMeeting: isConfirmedByBoth,
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
        color: isNextMeeting
            ? theme.colorScheme.primaryFixed
            : theme.colorScheme.tertiaryContainer,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: isNextMeeting
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
                meeting.isRescheduled
                    ? buildRescheduledChip(context, theme)
                    : SizedBox.shrink(),
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
                      if (isNextMeeting)
                        buildNewMeetingButton(context, isBuddy, meeting,
                            () async {
                          if (meeting.isPaymentPending) {
                            final paymentService = PaymentService();
                            PaymentHandshake? payment =
                                await paymentService.getHandshake(
                                    connection.id!, meeting.meetingID!);
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
                          await connectionService.updateMeetingOfConnection(
                              context, connection, meeting);
                          Navigator.pushNamed(context, Routes.splashScreen);
                        }),
                      if (!isNextMeeting)
                        buildNextMeetingButton(context, userData, () async {
                          final chatService = ChatService();
                          final chatRoomId = await chatService.createChatRoom(
                            person,
                            personID,
                            userData,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(chatRoomId: chatRoomId)),
                          );
                        }),
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
          ),
        ),
        backgroundColor: theme.colorScheme.tertiary,
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
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