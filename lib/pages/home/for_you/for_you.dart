import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/home/for_you/your_meetings.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:provider/provider.dart';

UserHelper userHelper = UserHelper();

class ForYouPage extends StatefulWidget {
  final TabController tabController;
  final Function(int) updateSelectedIndex;
  const ForYouPage({super.key, required this.tabController, required this.updateSelectedIndex});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  late AuthSessionProvider authProvider;
   bool isProfileCompleted = false;


  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    Future.wait([
      _isProfileCompleted()
    ]);
  }

  Future<void> _isProfileCompleted() async {
    try {
      bool isComplete =
          await userHelper.isProfileCompleted(authProvider.userData!);
      setState(() {
        isProfileCompleted = isComplete;
      });
    } catch (e) {
      setState(() {
        isProfileCompleted = false;
      });
    }
  }

  Future<List<List<Widget>>> fetchAllMeetings(UserData userData, ThemeData theme) async {
      List<Connection> connections = await userHelper.fetchConnections(userData);

    return await Future.wait([
      fetchOngoingMeetingAsFuture(theme, userData, connections),
      fetchNotReviewedMeetingsAsFuture(theme, userData, connections),
      fetchConfirmedMeetingsAsFuture(theme, userData, connections),
      fetchUnconfirmedMeetingsAsFuture(theme, userData, connections),
    ]);
  }

  Widget fetchCompleteProfile(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(24),
              color: theme.colorScheme.primaryContainer.withOpacity(0.5),
            ),
            padding: EdgeInsets.all(10),
          child: Row(
          children: [
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completa tu perfil para empezar a disfrutar de los beneficios de Buddy.',
                    style: ThemeTextStyle.itemLargeOnBackground(context),
                    overflow: TextOverflow.clip,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: BaseElevatedButton(
                        text: 'Completar',
                        buttonTextStyle: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                        buttonStyle: ThemeButtonStyle.primaryFixedDimRoundedButtonStyle(context),
                        onPressed: () => {
                          // widget.tabController.animateTo(2),
                          widget.updateSelectedIndex(2)
                        },
                        height: 36,
                        width: 124,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    UserData userData = authProvider.userData!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBody: true,
      extendBodyBehindAppBar: true, 
      resizeToAvoidBottomInset: false, 
      body: Stack (
        children: [
          if(!isProfileCompleted)
            fetchCompleteProfile(theme),
          if(isProfileCompleted)
          FutureBuilder<List<List<Widget>>>(
            future: fetchAllMeetings(userData, theme),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching meetings'));
                } else {
                  List<Widget> ongoingMeetingsWidgets = snapshot.data![0];
                  List<Widget> notReviewedMeetingsWidgets = snapshot.data![1];
                  List<Widget> confirmedMeetingsWidgets = snapshot.data![2];
                  List<Widget> unconfirmedMeetingsWidgets = snapshot.data![3];

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                      child: Column(
                        children: [
                          Column(children: ongoingMeetingsWidgets),
                          Column(children: notReviewedMeetingsWidgets),
                          Column(children: confirmedMeetingsWidgets),
                          Column(children: unconfirmedMeetingsWidgets),
                        ],
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
