import 'package:flutter/material.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';

class EditBiographyPage extends StatefulWidget {
  @override
  _EditBiographyPageState createState() => _EditBiographyPageState();
}

class _EditBiographyPageState extends State<EditBiographyPage> {
  late TextEditingController _biographyController;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    _biographyController = TextEditingController(
      text: authProvider.isBuddy
          ? authProvider.userData!.buddy!.buddyProfile!.description
          : authProvider.userData!.elder!.elderProfile!.description,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    final BuddyService buddyService = BuddyService();
    final ElderService elderService = ElderService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Biografía'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              final updatedDescription = _biographyController.text;
              if (authProvider.isBuddy) {
                buddyService.updateBuddyProfileDescription(context, updatedDescription);
              } else {
                elderService.updateElderProfileDescription(context, updatedDescription);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _biographyController,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Escribe tu biografía aquí...',
          ),
        ),
      ),
    );
  }
}
