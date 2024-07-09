import 'package:flutter/material.dart';
import 'package:mobile/routes.dart';

class ChooseUserPage extends StatelessWidget {
  const ChooseUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(42.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.wantBuddyForMyself);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                'Quiero un buddy para mi',
                style:
                    TextStyle(color: theme.colorScheme.onPrimary, fontSize: 20),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.wantBuddyForLovedOne);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                'Quiero un buddy\npara un ser querido',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.beBuddy);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                'Quiero ser buddy',
                style:
                    TextStyle(color: theme.colorScheme.onPrimary, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
