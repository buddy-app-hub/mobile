import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_avatar_stack.dart';
import 'package:mobile/widgets/base_elevated_button.dart';

class BaseCardConnection extends StatelessWidget {
  final String activity;
  final String person;
  final String date;
  final String time;
  final String location;
  final List<String> avatars;

  const BaseCardConnection({
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
          child: SizedBox(
            width: 375,
            height: 230,
            child: _buildConnectionInfo(context, theme),
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
                Text(
                  '$activity con $person',
                  style: ThemeTextStyle.titleMediumOnBackground(context),
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
                        buttonStyle: ThemeButtonStyle.tertiaryRoundedButtonStyle(context),
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