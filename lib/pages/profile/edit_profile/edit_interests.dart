import 'package:flutter/material.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';

class EditInterestsPage extends StatefulWidget {
  late final List<Interest> initialInterests = [];
  @override
  _EditInterestsPageState createState() => _EditInterestsPageState();
}

class _EditInterestsPageState extends State<EditInterestsPage> {

  final List<Interest> _interests = [];
  final TextEditingController _interestController = TextEditingController();

  @override
  void initState() {
  super.initState();
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    _interests.addAll((authProvider.isBuddy
    ? authProvider.userData?.buddy?.buddyProfile?.interests
    : authProvider.userData?.elder?.elderProfile?.interests) as Iterable<Interest>? ?? []);
    _interests.addAll(widget.initialInterests);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthSessionProvider>(context);
    final BuddyService buddyService = BuddyService();
    final ElderService elderService = ElderService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Intereses'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            onPressed: () {
              final updatedInterest = _interests;
              if (authProvider.isBuddy) {
                buddyService.updateProfileInterests(context, updatedInterest);
              } else {
                elderService.updateProfileInterests(context, updatedInterest);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Column(
                children: [
                  Row(
                    children: [
                    Expanded(
                    child: TextField(
                      controller: _interestController,
                      decoration: const InputDecoration(
                      hintText: 'Agregar interés...',
                      ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final interest = _interestController.text.trim();
                        if (interest.isNotEmpty) {
                          setState(() {
                            _interests.add(Interest(name: interest));
                            _interestController.clear();
                          });
                        } else {
                          final snackBar = SnackBar(
                            content: Text(
                              'Por favor, complete el campo.',
                              style: ThemeTextStyle.titleSmallOnError(context),
                            ),
                            backgroundColor: theme.colorScheme.error,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4.0,
                    runSpacing: 8.0,
                    children: _interests.map((interest) => 
                      BaseDecoration.buildEditableInterestTag(context, interest, theme, (tag) {
                        setState(() {
                          _interests.remove(tag);
                        });
                      })).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}