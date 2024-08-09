import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/my_connections.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/profile/my_profile.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MyConnectionsPage(),
    MyProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthSessionProvider>(context);
    bool userIsBuddy = authProvider.userData!.buddy != null;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: FlashyTabBar(
      backgroundColor: theme.colorScheme.surface,
      selectedIndex: _selectedIndex,
      showElevation: true,
      onItemSelected: _onItemTapped,
      items: [
          BaseDecoration.buildNavbarIconItem(context, 'Inicio', Icon(Icons.home_rounded)),
          BaseDecoration.buildNavbarIconItem(context, userIsBuddy ? 'Mayores' : 'Buddies', Icon(Icons.diversity_3)),
          BaseDecoration.buildNavbarIconItem(context, 'Perfil', Icon(Icons.person)),
        ],
    )
      // BottomNavigationBar(
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.group),
      //       label: userIsBuddy ? 'Mayores' : 'Buddies',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person_2),
      //       label: 'Perfil',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: theme.colorScheme.primary,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
