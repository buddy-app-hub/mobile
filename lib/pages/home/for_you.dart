import 'package:flutter/material.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
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

  Future<List<List<Widget>>> fetchAllMeetings(UserData userData, ThemeData theme) async {
    return await Future.wait([
      fetchMeetingsAsFuture(theme, userData),
      fetchNewMeetingsAsFuture(theme, userData),
      fetchRescheduledMeetingsAsFuture(theme, userData),
    ]);
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
          FutureBuilder<List<List<Widget>>>(
            future: fetchAllMeetings(userData, theme),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching meetings'));
                } else {
                  List<Widget> meetingsWidgets = snapshot.data![0];
                  List<Widget> newMeetingsWidgets = snapshot.data![1];
                  List<Widget> rescheduledMeetingsWidgets = snapshot.data![2];

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                      child: Column(
                        children: [
                          Column(children: meetingsWidgets),
                          Column(children: newMeetingsWidgets),
                          Column(children: rescheduledMeetingsWidgets),
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
