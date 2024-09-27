import 'package:flutter/material.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/new_buddy.dart';
import 'package:provider/provider.dart';

class NewConnectionPage extends StatefulWidget {
  const NewConnectionPage({super.key});

  @override
  State<NewConnectionPage> createState() => _NewConnectionState();
}

class _NewConnectionState extends State<NewConnectionPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    UserData userData = authProvider.userData!;
    final theme = Theme.of(context);

    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.primaryContainer,
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: 
        // Stack(
        //   children: [
        //     Column(
        //       children: [
        //         Row(
        //           children: [
        //             Container(
        //               margin: EdgeInsets.fromLTRB(
        //                   22, MediaQuery.of(context).padding.top + 18, 0, 18),
        //               child: Text('Te presentamos a tu nuevo \nBuddy ideal',
        //                   style: ThemeTextStyle.titleMediumOnPrimaryContainer(
        //                     context,
        //                   )),
        //             ),
        //           ],
        //         ),
            
                NewBuddy(),
              // ],
            ),
        //   ],
        // ),
      // ),
    );
  }
}
