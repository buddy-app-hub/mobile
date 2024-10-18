import 'package:flutter/material.dart';
import 'package:mobile/pages/connections/new_recommended_buddy.dart';

class NewConnectionsPage extends StatelessWidget {
  const NewConnectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.primaryContainer,
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body:  NewRecommendedBuddy(),
      ),
    );
  }
}
