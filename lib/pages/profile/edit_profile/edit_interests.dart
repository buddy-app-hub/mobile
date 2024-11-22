import 'package:flutter/material.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/pages/navigation.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/emoji_interest.dart';
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
  final List<String> interests = getInterestsList();
  late String selectedInterest;

  @override
  void initState() {
  super.initState();
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    _interests.addAll((authProvider.isBuddy
    ? authProvider.userData?.buddy?.buddyProfile?.interests
    : authProvider.userData?.elder?.elderProfile?.interests) as Iterable<Interest>? ?? []);
    _interests.addAll(widget.initialInterests);
    selectedInterest = interests[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthSessionProvider>(context);
    final BuddyService buddyService = BuddyService();
    final ElderService elderService = ElderService();

    return Scaffold(
      appBar: AppBar(
      // title: Text('Editar Intereses'),
      actions: [
        IconButton(
          icon: Icon(Icons.check),
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          onPressed: () {
            final updatedInterest = _interests;
            if (updatedInterest.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, agregue sus intereses para poder guardar.'),
                ),
              );
            } else {
              if (authProvider.isBuddy) {
                buddyService.updateProfileInterests(context, updatedInterest);
              } else {
                elderService.updateProfileInterests(context, updatedInterest);
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Navigation(index: 2)),
              );
            }
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 0, 28, 20),
                    child: Text(
                      'Editar Intereses',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 18),
                    child: Text(
                      'Esta información nos permitirá conectarte con personas que compartan tus intereses.',
                      style: ThemeTextStyle.titleInfoSmallOutline(context),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: DropdownButton<String>(
                          value: selectedInterest,
                          isExpanded: true,
                          items: interests.map((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedInterest = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final interest = extractInterest(selectedInterest.trim());
                        if (!interest.contains('Seleccionar') || interest.isNotEmpty) {
                          setState(() {
                            _interests.add(Interest(name: interest));
                            selectedInterest = interests[0];
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