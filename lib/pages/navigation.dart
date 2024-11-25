import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/my_connections.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/profile/my_profile.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key, required this.index,});

  final int index;
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex =  0;

  @override
  void initState() {
    super.initState();
    _selectedIndex =  widget.index;
    _tabController = TabController(vsync: this, length: 3, initialIndex: _selectedIndex);
  }

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });
  }

  List<Widget> _widgetOptions() {
    return <Widget>[
      HomePage(tabController: _tabController, updateSelectedIndex: updateSelectedIndex),
      MyConnectionsPage(),
      MyProfilePage(tabController: _tabController, updateSelectedIndex: updateSelectedIndex),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthSessionProvider>(context);

    return Scaffold(
      body: Center(
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: _widgetOptions(),
        ),
      ),
      bottomNavigationBar: FlashyTabBar(
        backgroundColor: theme.colorScheme.surface,
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: _onItemTapped,
        items: [
          BaseDecoration.buildNavbarIconItem(context, 'Inicio', Icon(Icons.home_rounded)),
          BaseDecoration.buildNavbarIconItem(
            context, 
            authProvider.isBuddy ? 'Mayores' : 'Buddies',
            Icon(Icons.diversity_3),
          ),
          BaseDecoration.buildNavbarIconItem(context, 'Perfil', Icon(Icons.person)),
        ],
      ),
    );
  }
}
