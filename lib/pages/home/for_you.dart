import 'package:flutter/material.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_card_calendar.dart';
import 'package:mobile/widgets/base_card_meeting.dart';
import 'package:provider/provider.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    UserData userData = authProvider.userData!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBody: true,
      extendBodyBehindAppBar: true, 
      resizeToAvoidBottomInset: false, 
      body: Stack (
        children: [
          SingleChildScrollView( // Hacer que el contenido sea desplazable verticalmente
            child: Padding (
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
                        child: Text(
                          'Próximos encuentros',
                          style: ThemeTextStyle.titleMediumInverseSurface(context),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                    child: Column(
                      children: [
                        FutureBuilder<List<Widget>>(
                          future: fetchMeetingsAsFuture(userData),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Text('Error fetching meetings');
                              } else {
                                return Column(
                                  children: snapshot.data!,
                                );
                              }
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 25, 0, 5),
                        child: Text(
                          'Eventos Agendados',
                          style: ThemeTextStyle.titleMediumInverseSurface(context),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                    child: Column(
                      children: [
                        BaseCardCalendar(meetings: [],),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}