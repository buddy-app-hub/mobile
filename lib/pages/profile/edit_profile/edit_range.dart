import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/pages/navigation.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';

class EditRangePage extends StatefulWidget {
  const EditRangePage({super.key, required this.isEdit,});

  final bool isEdit;
  @override
  _EditRangePageState createState() => _EditRangePageState();
}

class _EditRangePageState extends State<EditRangePage> {
  late TextEditingController _rangeController;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    _rangeController = TextEditingController(
      text: authProvider.isBuddy
          ? '${authProvider.userData!.buddy!.buddyProfile!.connectionPreferences!.maxDistanceKM}'
          : '${authProvider.userData!.elder!.elderProfile!.connectionPreferences!.maxDistanceKM}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);
    final BuddyService buddyService = BuddyService();
    final ElderService elderService = ElderService();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            onPressed: () {
              int updatedRange = int.parse(_rangeController.text);
              if (authProvider.isBuddy) {
                buddyService.updateBuddyProfileRangeKms(context, updatedRange);
              } else {
                elderService.updateElderProfileRangeKms(context, updatedRange);
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
                  widget.isEdit ? 'Editar Rango de búsqueda (KMs)' : 'Agregar Rango de búsqueda (KMs)',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 18),
                child: Text(
                  'Contanos cuál es tu rango de búsqueda (kms) máximo.\nEsta información ayudará a encontrar una mejor conexión.',
                  style: ThemeTextStyle.titleInfoSmallOutline(context),
                  textAlign: TextAlign.left,
                ),
              ),
              TextFormField(
                controller: _rangeController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Escribe tu máximo rango de búsqueda aquí...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                  )
                ),
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
