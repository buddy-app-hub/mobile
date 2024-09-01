import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/connections.dart';
import 'package:provider/provider.dart';

class MyConnectionsPage extends StatefulWidget {
  const MyConnectionsPage({super.key});

  @override
  State<MyConnectionsPage> createState() => _MyConnectionsPageState();
}

class _MyConnectionsPageState extends State<MyConnectionsPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  Future<void>? _initializeTabController;

  @override
  void initState() {
    super.initState();
    _initializeTabController = _initializeTabControllerFuture();
  }

  Future<void> _initializeTabControllerFuture() async {
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    int tabCount = authProvider.isBuddy ? 1 : 2;
    _tabController = TabController(length: tabCount, vsync: this);
  }
    
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthSessionProvider>(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: theme.colorScheme.primaryContainer,
          title: TabBar(
            labelColor: theme.colorScheme.onPrimaryContainer,
            indicatorColor: theme.colorScheme.onPrimaryContainer,
            unselectedLabelColor: theme.colorScheme.outline,
            dividerColor: Colors.transparent,
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: Text('Mis conexiones'),
              ),
              if (!authProvider.isBuddy)
                Tab(
                  icon: Text('Nuevo Buddy'),
                ),
            ],
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: 
        FutureBuilder<void>(
          future: _initializeTabController,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      ConnectionsPage(),
                      if (!authProvider.isBuddy)
                        Center(child: Text('Nuevo Buddy...')),
                    ],
                  )
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
