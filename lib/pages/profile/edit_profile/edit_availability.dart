import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';

class EditAvailabilityPage extends StatefulWidget {
  late final List<custom_time.TimeOfDay> initialAvailabilities = [];
  @override
  _EditAvailabilityPageState createState() => _EditAvailabilityPageState();
}

class _EditAvailabilityPageState extends State<EditAvailabilityPage> {
  final List<String> days = ['Seleccionar un dia', 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo']; //fix cuando lo traiga de la base de datos ponga el acento bien
  late String selectedDay;
  final List<custom_time.TimeOfDay> _availabilities = [];
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  @override
  void initState() {
  super.initState();
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    _availabilities.addAll((authProvider.isBuddy
    ? authProvider.userData?.buddy?.buddyProfile?.availability
    : authProvider.userData?.elder?.elderProfile?.availability) as Iterable<custom_time.TimeOfDay>? ?? []);
    _availabilities.addAll(widget.initialAvailabilities);
    selectedDay = days[0];
  }

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final authProvider = Provider.of<AuthSessionProvider>(context);
  final BuddyService buddyService = BuddyService();
  final ElderService elderService = ElderService();

  return Scaffold(
    appBar: AppBar(
      title: Text('Editar Disponibilidad'),
      actions: [
        IconButton(
          icon: Icon(Icons.check),
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          onPressed: () {
            final updatedAvailability = _availabilities;
            if (authProvider.isBuddy) {
              buddyService.updateProfileAvailability(context, updatedAvailability);
            } else {
              elderService.updateProfileAvailability(context, updatedAvailability);
            }
            Navigator.pop(context);
          },
        ),
      ],
    ),
    body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: DropdownButton<String>(
                          value: selectedDay,
                          items: days.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDay = newValue!;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final day = selectedDay;
                          final int startHour = int.tryParse(_fromController.text.trim()) ?? 0;
                          final int endHour = int.tryParse(_toController.text.trim()) ?? 0;
                          if (!day.contains('Seleccionar') && validateHours(startHour, endHour)) {
                            setState(() {
                              _availabilities.add(custom_time.TimeOfDay(dayOfWeek: day, from: startHour, to: endHour));
                              selectedDay = days[0];
                              _fromController.clear();
                              _toController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 15.0),
                Expanded(
                  child: TextField(
                    controller: _fromController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: 'Desde',
                      errorText: _validateHour(_fromController.text) ? null : 'Ingresá una hora válida',
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: TextField(
                    controller: _toController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: 'Hasta',
                      errorText: _validateHour(_toController.text) ? null : 'Ingresá una hora válida',
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 15.0),
              ],
            ),
            const SizedBox(height: 35.0),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 4.0,
              runSpacing: 8.0,
              children: _availabilities.map((timeOfDay) => 
                BaseDecoration.buildEditableAvailabilityTag(context, timeOfDay, theme, (tag) {
                  setState(() {
                    _availabilities.remove(tag);
                  });
                })).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

bool _validateHour(String value) {
  if (value.isEmpty) return true; // Allow empty fields
  final hour = int.tryParse(value);
  return hour != null && hour >= 1 && hour <= 24;
}