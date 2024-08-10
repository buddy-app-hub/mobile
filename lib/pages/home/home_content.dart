import 'package:flutter/material.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/home/for_you.dart';
import 'package:mobile/pages/home/social_hub.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:provider/provider.dart';

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0 ,0),
          child: Row(
            children: [
              Text(
                authProvider.userData != null
                    ? buildGreeting(authProvider.userData!)
                    : 'No logueado',
                style: ThemeTextStyle.titleLargePrimary700(context),
              ),
            ],
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Text('Para vos'),
            ),
            Tab(
              icon: Text('Hub Social'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ForYouPage(),
          SocialHubPage(),
        ],
      ),
    );
  }

  String buildGreeting(UserData userData) {
    String greeting = 'Hola!';
    
    userData.toJson().forEach((key, value) {
      if (key.contains('firstName') && value != null) {
        greeting = 'Hola, $value!';
      }
    });

    return greeting;
  }
}
