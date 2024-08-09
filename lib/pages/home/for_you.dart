import 'package:flutter/material.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_card_connection.dart';

class ForYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(
                          'Próximos encuentros',
                          style: ThemeTextStyle.titleMediumInverseSurface(context),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        BaseCardConnection(
                          activity: 'Paseo por el parque',
                          person: 'Ana Rodriguez',
                          location: 'Pilar', 
                          date: 'Miercoles 14 de Agosto', 
                          time: 'Jueves de 17.00 a 18.30',
                          avatars: List<String>.from(<String>['assets/images/avatar.png', 'assets/images/avatarBuddy.jpeg']),
                        ),
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

  List<Widget> buildUserDetails(UserData userData) {
    List<Widget> details = [];

    if (userData.buddy != null) {
      details.add(Text("User Type: Buddy"));
    } else if (userData.elder != null) {
      details.add(Text("User Type: Elder"));
    }

    userData.toJson().forEach((key, value) {
      if (value != null) {
        details.add(Text("$key: $value"));
      }
    });

    return details;
  }
}