import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/home/for_you/for_you.dart';
import 'package:mobile/pages/home/loved_one_mode_preference.dart';
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
  bool isLovedOneModeOn = false; // Solo util para elders
  final LovedOneModePreference _modePreference = LovedOneModePreference();

  @override
  void initState() {
    super.initState();
    _loadIsLovedOneModeOn();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadIsLovedOneModeOn() async {
    bool mode = await _modePreference.getMode();
    setState(() {
      isLovedOneModeOn = mode;
    });
  }

  void _toggleMode() async {
    setState(() {
      isLovedOneModeOn = !isLovedOneModeOn;
    });

    if (isLovedOneModeOn) {
      print("Modo LovedOne Activado");
    } else {
      print("Modo Elder Activado");
    }
    await _modePreference
        .saveMode(isLovedOneModeOn); // Guardamos preferencia en el dispositivo
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: [
              authProvider.isElder &&
                      isLovedOneModeOn &&
                      authProvider.userData!.elder!.lovedOne != null
                  ? Text(
                      authProvider.userData != null
                          ? 'Hola, ${authProvider.userData!.elder!.lovedOne!.firstName}!'
                          : 'No logueado',
                      style: ThemeTextStyle.titleLargeTertiary700(context),
                    )
                  : Text(
                      authProvider.userData != null
                          ? 'Hola, ${authProvider.personalData.firstName}!'
                          : 'No logueado',
                      style: ThemeTextStyle.titleLargePrimary700(context),
                    ),
              Spacer(),
              authProvider.isElder &&
                      authProvider.userData!.elder!.lovedOne !=
                          null // Mostramos el switch si el elder tiene modo loved one
                  ? Row(
                      children: [
                        Icon(
                          Icons
                              .emoji_people, // iconos posibles: elderly, emoji_people
                          color: !isLovedOneModeOn
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        SizedBox(width: 2),
                        Switch(
                          value: isLovedOneModeOn,
                          onChanged: (value) {
                            _toggleMode();
                          },
                          activeColor: Theme.of(context).colorScheme.tertiary,
                          activeTrackColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          inactiveThumbColor: Theme.of(context).primaryColor,
                          inactiveTrackColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons
                              .supervisor_account, // iconos posibles: family_restroom, supervisor_account
                          color: !isLovedOneModeOn
                              ? Colors.grey
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
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
}
