import 'package:flutter/material.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_schedule.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/chats/chat_screen.dart';
import 'package:mobile/pages/home/for_you/verify_meeting_code.dart';
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
                    meeting.startConfirmed
                        ? buildStartedChip(context, theme)
                        : buildNotStartedChip(context, theme),
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
                      ChatButton(
                          currentUserData: userData,
                          connectedPersonID: connectedPersonID,
                          connectedPersonName: connectedPersonName),
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
                !meeting.startConfirmed
                    ? Column(
                        children: [
                          SizedBox(height: 20),
                          BaseElevatedButton(
                            text: 'Comenzar encuentro',
                            buttonTextStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            onPressed: () {
                              print(
                                  "TESTING: podés usar este código para insertar: ${generateCode(meeting)}");
                              userData.elder != null
                                  ? showModalStartMeetingForElder(
                                      context, meeting)
                                  : showModalStartMeetingForBuddy(
                                      context, meeting);
                            },
                            height: 40,
                            width: 210,
                            buttonStyle:
                                ThemeButtonStyle.primaryRoundedButtonStyle(
                                    context),
                          )
                        ],
                      )
                    : SizedBox.shrink(),
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
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 234, 234, 170),
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
      );

  Widget buildStartedChip(BuildContext context, ThemeData theme) => Chip(
        label: Text(
          'Comenzado',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 170, 234, 190),
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

  // Convertir los primeros 6 caracteres del hash en un numero
  String code = digest.toString().substring(0, 6);

  return code;
}

void showModalStartMeetingForElder(BuildContext context, Meeting meeting) {
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
              generateCode(meeting),
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20.0),
            qrCodeForMeeting(meeting),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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

void showModalStartMeetingForBuddy(BuildContext context, Meeting meeting) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ingresá el código de 6 dígitos que le aparece en la app a tu mayor',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            MeetingCodeVerification(meeting: meeting),
            SizedBox(height: 20.0),
            Text(
              'o',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            BaseElevatedButton(
              text: 'Escanear QR',
              buttonTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              onPressed: () {},
              height: 40,
              width: 150,
              buttonStyle: ThemeButtonStyle.primaryRoundedButtonStyle(context),
            ),
            SizedBox(height: 20.0),
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
