import 'package:flutter/material.dart';
import 'package:mobile/models/recommended_buddy.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/new_recommended_buddy.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:provider/provider.dart';

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
