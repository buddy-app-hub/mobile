import 'package:flutter/material.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';
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
  final List<String> days = [
    'Seleccionar un dia', 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'
  ]; // fix cuando lo traiga de la base de datos ponga el acento bien
  late String selectedDay;
  final List<custom_time.TimeOfDay> _availabilities = [];
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;

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

  Future<void> _selectTime(BuildContext context, bool isFromTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: isFromTime
          ? (_fromTime ?? TimeOfDay.now())
          : (_toTime ?? TimeOfDay.now()),
      cancelText: 'Cancelar',
      helpText: 'Ingresar una hora',
      errorInvalidText: 'Ingresá una hora válida',
      hourLabelText: 'Hora',
      minuteLabelText: 'Minutos',
    );
    if (picked != null) {
      setState(() {
        if (isFromTime) {
          _fromTime = picked;
          _fromController.text = picked.format(context);
        } else {
          _toTime = picked;
          _toController.text = picked.format(context);
        }
      });
    }
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
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
                                if (day.contains('Seleccionar') || _fromTime == null || _toTime == null) {
                                  final snackBar = SnackBar(
                                    content: Text('Por favor, complete todos los campos correctamente.'),
                                    backgroundColor: theme.colorScheme.error,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else if (!validateTimeRange(_fromTime, _toTime)) {
                                  final snackBar = SnackBar(
                                    content: Text('El rango de horas debe ser de al menos una hora.'),
                                    backgroundColor: theme.colorScheme.error,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else {
                                  setState(() {
                                    _availabilities.add(custom_time.TimeOfDay(
                                      dayOfWeek: day,
                                      from: timeToInt(_fromTime!),
                                      to: timeToInt(_toTime!),
                                    ));
                                    selectedDay = days[0];
                                    _fromController.clear();
                                    _toController.clear();
                                    _fromTime = null;
                                    _toTime = null;
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
                        child: TextFormField(
                          controller: _fromController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Desde",
                            hintText: "Ingrese una hora",
                            hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                            suffixIcon: Icon(Icons.access_time, size: 24),
                          ),
                          onTap: () => _selectTime(context, true),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: TextFormField(
                          controller: _toController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Hasta",
                            hintText: "Ingrese una hora",
                            hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                            suffixIcon: Icon(Icons.access_time, size: 25),
                          ),
                          onTap: () => _selectTime(context, false),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  BaseDecoration.buildTitleProfile(context, 'Horarios cargados'), //no se si va
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
          ),
        ],
      ),
    );
  }
}
