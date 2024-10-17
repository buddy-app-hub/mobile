import 'package:flutter/material.dart';
import 'package:mobile/pages/profile/complete_profile/edit_documentation.dart';
import 'package:mobile/pages/profile/my_profile.dart';
import 'package:mobile/theme/theme_text_style.dart';

List<CustomListTile> verificationListTiles = [
  CustomListTile(
    icon: Icons.document_scanner_rounded,
    title: "Cargar documento de identidad",
  ),
  CustomListTile(
    icon: Icons.photo_camera_front_rounded,
    title: "Cargar prueba de vida",
  ),
];



class IdentityVerificationPage extends StatefulWidget {
  const IdentityVerificationPage({super.key});

  @override
  State<IdentityVerificationPage> createState() => _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        // title: Text("ge"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 28, 20),
                child: Text(
                  'Verificar identidad',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 45),
                child: Text(
                  'Necesitarás tener tu documento oficial a mano y asegúrate de estar en un lugar bien iluminado.\nEsto nos ayudará a confirmar tu identidad de manera rápida y segura.',
                  style: ThemeTextStyle.titleInfoSmallOutline(context),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(
                      verificationListTiles.length,
                      (index) {
                        final tile = verificationListTiles[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Card(
                            elevation: 4,
                            shadowColor: Theme.of(context).colorScheme.surface,
                            child: ListTile(
                              leading: Icon(tile.icon),
                              title: Text(tile.title),
                              // enabled: false,
                              onTap: () => _handleTileTap(context, tile.title),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditDocumentationPage()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    "Iniciar verificación", 
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTileTap(BuildContext context, String title) {
    Widget? targetPage;

    switch (title) {
      case 'Cargar documento de identidad':
        targetPage = EditDocumentationPage();
      case 'Cargar prueba de vida':
        targetPage = EditDocumentationPage();
    }

    if (targetPage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetPage!),
      );
    }
  }
}