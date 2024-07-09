import 'package:flutter/material.dart';
import 'package:mobile/routes.dart';

class ChooseUserPage extends StatelessWidget {
  const ChooseUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Elige tu rol'),
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
                // Navegar a la página correspondiente para "Quiero un buddy"
                Navigator.pushNamed(context, Routes.wantBuddy);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                'Quiero un buddy',
                style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 20),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página correspondiente para "Quiero ser buddy"
                Navigator.pushNamed(context, Routes.beBuddy);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                'Quiero ser buddy',
                style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
