import 'package:flutter/material.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_schedule.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/chats/chat_screen.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/chat_service.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';
import 'package:mobile/widgets/base_avatar_stack.dart';
import 'package:mobile/widgets/base_card_meeting.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

OngoingMeetingCard buildOngoingMeetingCard(
  String connectedPersonID,
  String connectedPersonName,
  Connection connection,
  Meeting meeting,
  List<String> images,
) {
  return OngoingMeetingCard(
    connectedPersonID: connectedPersonID,
    connectedPersonName: connectedPersonName,
    connection: connection,
    meeting: meeting,
    date: formatMeetingDateShort(meeting.schedule.date),
    time: formatTime(meeting.schedule),
    location: formatLocation(meeting.location),
    avatars: images,
  );
}

class OngoingMeetingCard extends StatelessWidget {
  final String connectedPersonID;
  final String connectedPersonName;
  final Connection connection;
  final Meeting meeting;
  final String date;
  final String time;
  final String location;
  final List<String> avatars;

  const OngoingMeetingCard({
    super.key,
    required this.connectedPersonID,
    required this.connectedPersonName,
    required this.connection,
    required this.meeting,
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
        color: theme.colorScheme.primaryFixed,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: theme.colorScheme.primary,
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
                    true
                        ? buildNotStartedChip(context, theme)
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
                        '${meeting.activity} con $connectedPersonName',
                        style: ThemeTextStyle.titleMediumOnBackground(context),
                      ),
                    ),
                    // SizedBox(width: 12,),
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Notificar ausencia de $connectedPersonName',
                          child: Text(
                              'Notificar ausencia de $connectedPersonName'),
                        ),
                        PopupMenuItem(
                          value: 'Cancelar y notificar a $connectedPersonName',
                          child: Text(
                              'Cancelar y notificar a $connectedPersonName'),
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Cancelar encuentro'),
                              content: Text(
                                  '¿Estás seguro de que querés cancelar el encuentro en curso? Esto puede llegar a penalizarte si no tenés un motivo.'),
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
                        if (value.contains('Notificar ausencia')) {
                          print("TODO: implementar");
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
                      buildNextMeetingButton(context, userData, () async {
                        final chatService = ChatService();
                        final chatRoomId = await chatService.createChatRoom(
                          connectedPersonName,
                          connectedPersonID,
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
                SizedBox(height: 20),
                  BaseElevatedButton(
                    text: 'Comenzar encuentro',
                    buttonTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    onPressed: () {
                      showModalStartMeeting(context, meeting);
                    },
                    height: 40,
                    width: 220,
                    buttonStyle:
                        ThemeButtonStyle.primaryRoundedButtonStyle(context),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNotStartedChip(BuildContext context, ThemeData theme) => Chip(
        label: Text(
          'No comenzado',
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
}

Widget qrCodeForMeeting(Meeting meeting) {
  String deadline = getMeetingEndDateTime(meeting.schedule).toString();
  String qrData =
      'meetingID:${meeting.meetingID},connectionID:${meeting.connection!.id},deadline:$deadline';

  return Center(
      child: QrImageView(
    data: qrData,
    version: QrVersions.auto,
    size: 220.0,
    // embeddedImage: AssetImage('assets/icons/Buddy.png'),
    // embeddedImageStyle: QrEmbeddedImageStyle(
    //   size: Size(480, 480),
    // ),
    errorStateBuilder: (cxt, err) {
      return Center(
        child: Text(
          'Error al validar el QR...',
          textAlign: TextAlign.center,
        ),
      );
    },
  ));
}

DateTime getMeetingEndDateTime(MeetingSchedule schedule) {
  DateTime date = schedule.date;

  int hours = schedule.endHour ~/ 100;
  int minutes = schedule.endHour % 100;

  return DateTime(date.year, date.month, date.day, hours, minutes);
}

String generateCode(Meeting meeting) {
  var bytes = utf8.encode(meeting.meetingID! + meeting.connection!.id!);
  var digest = sha256.convert(bytes);

  // Convertir los primeros 6 caracteres del hash en un número
  String code = digest.toString().substring(0, 6);

  return code;
}

void showModalStartMeeting(BuildContext context, Meeting meeting) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mostrá el código de 6 dígitos o el QR a tu buddy para comenzar el encuentro',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              generateCode(meeting), // Aquí se genera el código de 6 dígitos
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20.0),
            qrCodeForMeeting(meeting), // Aquí se muestra el QR generado
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar modal
              },
              child: Text('Cerrar'),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      );
    },
  );
}
