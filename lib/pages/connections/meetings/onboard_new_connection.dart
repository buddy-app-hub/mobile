import 'package:flutter/material.dart';
import 'package:mobile/models/buddy.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/pages/connections/meetings/new_meeting.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_avatar_stack.dart';
import 'package:mobile/widgets/base_card_meeting.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';

class OnboardNewConnectionPage extends StatefulWidget {
  final Connection connection;
  final Buddy buddy;

  const OnboardNewConnectionPage(
      {Key? key, required this.connection, required this.buddy})
      : super(key: key);

  @override
  _OnboardNewConnectionPageState createState() =>
      _OnboardNewConnectionPageState();
}

class _OnboardNewConnectionPageState extends State<OnboardNewConnectionPage> {
  List<String> avatars = List.empty();

  @override
  void initState() {
    super.initState();

    _loadAvatars();
  }

  Future<void> _loadAvatars() async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    List<String> fetchedAvatars = await fetchAvatars(
        widget.buddy.firebaseUID, false, authProvider.userData!);

    setState(() {
      avatars = fetchedAvatars;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(28, 30, 28, 10),
            child: Text(
              'Conectaste con \n${widget.buddy.personalData.firstName}',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 350,
            height: 120,
            alignment: Alignment.center,
            child: BaseAvatarStack(avatars: avatars, spacing: 100, parentContainerHeight: 120,),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 40),
            child: Text(
              'Ahora programá tu primer encuentro con ${widget.buddy.personalData.firstName}. Tendrás que elegir una fecha, hora y lugar para la experiencia. También, podés sugerir realizar una actividad con la cual compartir el momento. Suerte!',
              style: ThemeTextStyle.titleSmallOutline(context),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewMeetingPage(
                    connection: widget.connection,
                    isBuddy: false,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Programar Encuentro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
