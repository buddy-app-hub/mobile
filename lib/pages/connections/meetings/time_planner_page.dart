import 'package:flutter/material.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_schedule.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/pages/connections/chats/chat_screen.dart';
import 'package:mobile/utils/format_date.dart';
import 'package:time_planner/time_planner.dart';

class TimePlannerPage extends StatefulWidget {
  // final Connection connection;
  final String userID;
  final String personID;
  final bool isBuddy;
  final MeetingSchedule? meetingSchedule;

  const TimePlannerPage({Key? key, required this.userID, required this.personID, required this.isBuddy, required this.meetingSchedule,}) : super(key: key);

  @override
  _TimePlannerPageState createState() => _TimePlannerPageState();
}

class _TimePlannerPageState extends State<TimePlannerPage> {
  MeetingSchedule? selectedDay;
  bool isSelectedDay = false;
  List<TimePlannerTask> availabilityTasks = [];
  List<TimePlannerTask> meetingsTasks = [];
  List<TimePlannerTask> tasks = [];

  @override
  void initState() {
    super.initState();
    if (widget.meetingSchedule != null) {
      setState(() {
        selectedDay = widget.meetingSchedule;
        isSelectedDay = true;
      });
    } else {
      selectedDay = null;
      isSelectedDay = false;
    }
    _fetchPersonAvailability();
  }

  Future<void> _fetchPersonAvailability() async {
    final availability = await userHelper.fetchProfileAvailability(widget.personID, widget.isBuddy);
    if (availability!.isNotEmpty) {
      setState(() {
        availabilityTasks.addAll(generateUnavailabilityTasks(context, availability));
        tasks.addAll(availabilityTasks);
      });
    } else {
      setState(() {
        tasks.addAll(generateUnavailabilityTasks(context, List.empty()));
      });
    }
    _fetchPersonMeetings();
  }

  Future<void> _fetchPersonMeetings() async {
    final meetings = await userHelper.fetchMeetingCurrentWeek(widget.personID, !widget.isBuddy);
    if (meetings.isNotEmpty) {
      if (isSelectedDay) {
        setState(() {
            meetingsTasks.addAll(generateMeetingTasks(context, meetings.where((m) {
              final meetingDateMatches = selectedDay == null || m.schedule.date != selectedDay!.date;
              final timeDoesNotOverlap = selectedDay == null ||
                  m.schedule.endHour <= selectedDay!.startHour ||
                  m.schedule.startHour >= selectedDay!.endHour;

              return meetingDateMatches || timeDoesNotOverlap;
            }).toList()));
            tasks.addAll(meetingsTasks);
          });
      } else {
        setState(() {
          meetingsTasks.addAll(generateMeetingTasks(context, meetings));
        });
      }
    }
    _fetchUserMeetings();
  }

  Future<void> _fetchUserMeetings() async {
    final meetings = await userHelper.fetchMeetingCurrentWeek(widget.userID, widget.isBuddy);
    if (meetings.isNotEmpty) {
      if (isSelectedDay) {
      setState(() {
          meetingsTasks.addAll(generateUserMeetingTasks(context, meetings.where((m) {
            final meetingDateMatches = selectedDay == null || m.schedule.date != selectedDay!.date;
            final timeDoesNotOverlap = selectedDay == null ||
                m.schedule.endHour <= selectedDay!.startHour ||
                m.schedule.startHour >= selectedDay!.endHour;

            return meetingDateMatches || timeDoesNotOverlap;
          }).toList()));
          tasks.addAll(meetingsTasks);
        });
        _setSelectedDay();
      } else {
        setState(() {
          meetingsTasks.addAll(generateMeetingTasks(context, meetings));
        });
      }
      
    }
  }

  Future<void> _setSelectedDay() async {
    final meetingSchedule = widget.meetingSchedule;

    int hour = intToTimeHour(meetingSchedule!.startHour);
    int minutes = intToTimeMinutes(meetingSchedule.startHour);

    final plannerDateTime = TimePlannerDateTime(
      day: getPlannerDay(meetingSchedule.date),
      hour: hour,
      minutes: minutes,
    );

    setState(() {
      selectedDay = meetingSchedule;
      isSelectedDay = true;

      tasks.add(
        getSelectedDayTask(plannerDateTime),
      );
    });
  }

  List<TimePlannerTask> generateUnavailabilityTasks(BuildContext context, List<custom_time.TimeOfDay> availability) {
    List<TimePlannerTask> tasks = [];
    DateTime now = DateTime.now();

    Set<String> availableDays = availability.map((a) => a.dayOfWeek).toSet();

    for (int i = 0; i < 7; i++) {
      DateTime currentDate = now.add(Duration(days: i));
      String day = weekdays[currentDate.weekday - 1 ];

      //Si no tiene disponibilidad creo una task de todo el día
      if (!availableDays.contains(day)) {
        tasks.add(
          TimePlannerTask(
            color: Theme.of(context).colorScheme.secondaryFixedDim.withOpacity(0.5), 
            dateTime: TimePlannerDateTime(
              day: i,
              hour: 6, 
              minutes: 0,
            ),
            minutesDuration: 1080,
            daysDuration: 1,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'No disponible el $day',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryFixedVariant, 
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  leadingDistribution: TextLeadingDistribution.proportional,
                ),
              ),
            ),
          ),
        );
      } else {
        var daySlots = availability.where((a) => a.dayOfWeek == day).toList();
        int startHour = 6;
        int endHour = 24; 

        if (daySlots.isNotEmpty && daySlots.first.from > startHour * 100) {
          tasks.add(
            TimePlannerTask(
              color: Theme.of(context).colorScheme.secondaryFixedDim.withOpacity(0.5),
              dateTime: TimePlannerDateTime(
                day: i,
                hour: startHour,
                minutes: 0,
              ),
              minutesDuration: ((daySlots.first.from ~/ 100) - startHour) * 60 + (daySlots.first.from % 100),
              daysDuration: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  'No disponible hasta ${intToTime(daySlots.first.from)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }

        for (int j = 0; j < daySlots.length - 1; j++) {
          if (daySlots[j].to < daySlots[j + 1].from) {
            tasks.add(
              TimePlannerTask(
                color: Theme.of(context).colorScheme.secondaryFixedDim.withOpacity(0.5),
                dateTime: TimePlannerDateTime(
                  day: i,
                  hour: daySlots[j].to ~/ 100,
                  minutes: daySlots[j].to % 100,
                ),
                minutesDuration: (daySlots[j + 1].from ~/ 100 - daySlots[j].to ~/ 100) * 60 - daySlots[j].to % 100,
                daysDuration: 1,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'No disponible entre ${intToTime(daySlots[j].to)} y ${intToTime(daySlots[j + 1].from)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }
        }

        if (daySlots.isNotEmpty && daySlots.last.to < endHour * 100) {
          tasks.add(
            TimePlannerTask(
              color: Theme.of(context).colorScheme.secondaryFixedDim.withOpacity(0.5),
              dateTime: TimePlannerDateTime(
                day: i,
                hour: daySlots.last.to ~/ 100,
                minutes: daySlots.last.to % 100,
              ),
              minutesDuration: (endHour * 60 - (daySlots.last.to ~/ 100) * 60 - (daySlots.last.to % 100)),
              daysDuration: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  'No disponible después de ${intToTime(daySlots.last.to)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }
    return tasks;
  }

  List<TimePlannerTask> generateMeetingTasks(BuildContext context, List<Meeting> meetings) {
    List<TimePlannerTask> tasks = [];

    tasks = meetings.map((meeting) {
      int hour = intToTimeHour(meeting.schedule.startHour);
      int minutes = intToTimeMinutes(meeting.schedule.startHour);
      return TimePlannerTask(
        color: Theme.of(context).colorScheme.tertiaryContainer, 
        dateTime: TimePlannerDateTime(
          day: getPlannerDay(meeting.schedule.date),
          hour: hour, 
          minutes: minutes,
        ),
        minutesDuration: 60,
        daysDuration: 1,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Text(
            'Encuentro programado',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.w400,
              fontSize: 11.5,
              leadingDistribution: TextLeadingDistribution.proportional,
            ),
          ),
        ),
      );
    }).toList();

    return tasks;
  }

  List<TimePlannerTask> generateUserMeetingTasks(BuildContext context, List<Meeting> meetings) {
    List<TimePlannerTask> tasks = [];

    tasks = meetings.map((meeting) {
      int hour = intToTimeHour(meeting.schedule.startHour);
      int minutes = intToTimeMinutes(meeting.schedule.startHour);
      return TimePlannerTask(
        color: Theme.of(context).colorScheme.primaryContainer, 
        dateTime: TimePlannerDateTime(
          day: getPlannerDay(meeting.schedule.date),
          hour: hour, 
          minutes: minutes,
        ),
        minutesDuration: 60,
        daysDuration: 1,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Text(
            'Tienes un encuentro programado',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryFixed,
              fontWeight: FontWeight.w400,
              fontSize: 11.5,
              leadingDistribution: TextLeadingDistribution.proportional,
            ),
          ),
        ),
      );
    }).toList();

    return tasks;
  }

  void _openDateTimePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      helpText: 'Seleccionar un día',
      cancelText: 'Cancelar',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      // se puede agregar uno mas que sea agregar un hasta que hora
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.inputOnly,
        cancelText: 'Cancelar',
        helpText: 'Ingresar una hora',
        errorInvalidText: 'Ingresá una hora válida',
        hourLabelText: 'Hora',
        minuteLabelText: 'Minutos',
      );

      if (pickedTime != null && (pickedTime.minute != 0 && pickedTime.minute != 30)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solo se permiten cargar horas que terminen en minuto 00 o 30.\nPor favor, verifica que el horario ingresado cumpla con esta condición.'),
          ),
        );
      } else if (pickedTime != null && isSameDay(pickedDate, DateTime.now()) && isBefore(pickedTime, TimeOfDay.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No puedes seleccionar un horario anterior al actual porque hoy es el día seleccionado.\nElige un horario en el futuro.',),
          ),
        );
      } else if (pickedTime != null) {
        final plannerDateTime = TimePlannerDateTime(
          day: getPlannerDay(pickedDate),
          hour: pickedTime.hour,
          minutes: pickedTime.minute,
        );

        bool hasConflict = _checkForConflicts(plannerDateTime);

        if (!hasConflict) {
          bool unavailabilyConflict = _checkWithUnavailability(plannerDateTime);
          if (unavailabilyConflict) {
            showConfirmationDialog(context, pickedDate, pickedTime, plannerDateTime);
          } else {
            setState(() {
              selectedDay = MeetingSchedule(
                date: pickedDate,
                startHour: timeToInt(pickedTime),
                endHour: timeToInt(addOneHour(pickedTime)),
              );

              tasks.add(
                getSelectedDayTask(plannerDateTime),
              );
            });
            isSelectedDay = true;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El tiempo seleccionado se superpone con un evento previo.')),
          );
        }
      }
    }
  }

  TimePlannerTask getSelectedDayTask(TimePlannerDateTime plannerDateTime) {
    return TimePlannerTask(
      color: Theme.of(context).colorScheme.primaryFixedDim,
      dateTime: plannerDateTime,
      minutesDuration: 60,
      daysDuration: 1,
      onTap: () {
        showDeleteDialog(context, plannerDateTime);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Text(
          'Horario de encuentro',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w400,
            fontSize: 13,
            leadingDistribution: TextLeadingDistribution.proportional,
          ),
        ),
      ),
    );
  }

  bool _checkForConflicts(TimePlannerDateTime selectedDateTime) {
    final selectedStartTime = TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minutes);
    final selectedEndTime = addOneHour(selectedStartTime);
    for (final task in tasks) {
      // chequeo sea solo con los encuentros, si quiere crear en los no dispobible que sale un warning 
      if (task.minutesDuration == 60 && task.color == Theme.of(context).colorScheme.primaryContainer) {
        if (task.dateTime.day == selectedDateTime.day) {
          final taskStartTime = TimeOfDay(hour: task.dateTime.hour, minute: task.dateTime.minutes);
          final taskEndTime = addTimeToHour(taskStartTime, task.minutesDuration);

          if (isBefore(selectedStartTime, taskEndTime) && isAfter(selectedEndTime, taskStartTime)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _checkWithUnavailability(TimePlannerDateTime selectedDateTime) {
    final selectedStartTime = TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minutes);
    final selectedEndTime = addOneHour(selectedStartTime);
    for (final task in tasks) {
      // chequeo sea solo con los encuentros si quiere crear en los no dispobible que sale un warning 
      if (task.color != Theme.of(context).colorScheme.primaryContainer) {
        if (task.dateTime.day == selectedDateTime.day) {
          final taskStartTime = TimeOfDay(hour: task.dateTime.hour, minute: task.dateTime.minutes);
          final taskEndTime = addTimeToHour(taskStartTime, task.minutesDuration);

          if (isBefore(selectedStartTime, taskEndTime) && isAfter(selectedEndTime, taskStartTime)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void showConfirmationDialog(BuildContext parentContext, DateTime pickedDate, TimeOfDay pickedTime, TimePlannerDateTime plannerDateTime) {
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: Text('Aviso sobre el horario seleccionado'),
        content: Text('El horario que seleccionaste podría ser reprogramado, ya que la disponibilidad de la persona aún no ha sido confirmada.\n¿Deseas confirmar este horario de todos modos?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Confirmar'),
            onPressed: () {
              setState(() {
                selectedDay = MeetingSchedule(
                  date: pickedDate,
                  startHour: timeToInt(pickedTime),
                  endHour: timeToInt(addOneHour(pickedTime)),
                );

                tasks.add(
                  getSelectedDayTask(plannerDateTime),
                );
                isSelectedDay = true;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext parentContext, TimePlannerDateTime plannerDateTime) {
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: Text('Eliminar horario seleccionado'),
        content: Text('¿Estás seguro de que deseas eliminar este horario de encuentro?\nPodrás elegir otro horario para continuar.'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Confirmar'),
            onPressed: () async {
              setState(() {
                tasks.removeWhere(((t) => t.dateTime == plannerDateTime));
              });
              isSelectedDay = false;
              ScaffoldMessenger.of(parentContext).showSnackBar(
                SnackBar(content: Text('Horario de encuentro eliminado')),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _confirmSelection() {
    if (selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, seleccione un horario.')),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirmar selección'),
          content: Text('¿Estás seguro de que deseas agendar el encuentro para el ${formatMeetingDate(selectedDay!.date)}?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, selectedDay);
              },
            ),
          ],
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Elegí un horario'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            onPressed: _confirmSelection,
          ),
        ],
      ),
      body: Center(
        child: TimePlanner(
          startHour: 6,
          endHour: 23,
          use24HourFormat: true,
          setTimeOnAxis: false,
          style: TimePlannerStyle(
            showScrollBar: true,
            interstitialEvenColor: theme.colorScheme.outlineVariant.withOpacity(0.3),
            interstitialOddColor: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
          headers: generateWeekPlanner(),
          tasks: tasks,
        ),
      ),
      floatingActionButton: isSelectedDay ?
        null :
        FloatingActionButton(
        onPressed: () => !isSelectedDay ? _openDateTimePicker(context) : null,
        child: Icon(Icons.add),
      ),
    );
  }
}