import 'package:flutter/material.dart';
import 'package:mobile/pages/navigation.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';

class EditBiographyPage extends StatefulWidget {
  const EditBiographyPage({super.key, required this.isEdit,});

  final bool isEdit;
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
        // title: Text('Editar Biografía'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            onPressed: () {
              final updatedDescription = _biographyController.text;
              if (authProvider.isBuddy) {
                buddyService.updateBuddyProfileDescription(context, updatedDescription);
              } else {
                elderService.updateElderProfileDescription(context, updatedDescription);
              }
              Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Navigation(index: 2)),
      );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 28, 20),
                child: Text(
                  widget.isEdit ? 'Editar Biografía' : 'Agregar Biografía',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 18),
                child: Text(
                  'Contanos un poco más sobre vos.\nEsta información ayudará a otros a conocerte mejor.',
                  style: ThemeTextStyle.titleInfoSmallOutline(context),
                  textAlign: TextAlign.left,
                ),
              ),
              TextField(
                controller: _biographyController,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Escribe tu biografía aquí...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
