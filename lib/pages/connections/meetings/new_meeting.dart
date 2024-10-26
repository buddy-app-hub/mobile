import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_location.dart';
import 'package:mobile/models/meeting_schedule.dart';
import 'package:mobile/pages/auth/splash_screen.dart';
import 'package:mobile/pages/connections/meetings/time_planner_page.dart';
import 'package:mobile/services/chat_service.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/widgets/base_card_meeting.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';


class NewMeetingPage extends StatefulWidget {
  final Connection connection;
  final bool isBuddy;
  // final MeetingSchedule? selectedDay;

  const NewMeetingPage({Key? key, required this.connection, required this.isBuddy,}) : super(key: key);
  @override
  _NewMeetingPageState createState() => _NewMeetingPageState();
}

class _NewMeetingPageState extends State<NewMeetingPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _isElderHouseController = TextEditingController();
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  
  bool _isElderHouseSelected = false;
  bool _isElderHouseAddress = false;
  UserHelper userHelper = UserHelper();
  final chatService = ChatService();
  final connectionService = ConnectionService();
  MeetingSchedule? selectedDay;
  DateTime? _dateTime;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;

  @override
  void initState() {
    super.initState();
    _fetchNearestAvailableTime();
    _isElderHouseController.text = 'Mi casa'; 
    _countryController.text = 'Argentina';
  }

  Future<void> _fetchNearestAvailableTime() async {
    final availability = await userHelper.fetchProfileAvailability(widget.connection.buddyID, widget.isBuddy);
    final meetings = await userHelper.fetchMeetingCurrentWeek(widget.connection.buddyID, !widget.isBuddy);
    final meetingsElder = await userHelper.fetchMeetingCurrentWeek(widget.connection.elderID, widget.isBuddy);

    if (availability!.isNotEmpty) {
      final nearestAvailableTime = findNearestAvailableMeetingSchedule(availability, meetings, meetingsElder);
      if (nearestAvailableTime != null) {
        final startTime = formatIntToTime(nearestAvailableTime.startHour);
        final endTime = addOneHour(startTime);
        selectedDay = MeetingSchedule(date: nearestAvailableTime.date, startHour: nearestAvailableTime.startHour, endHour: timeToInt(endTime));
        setState(() {
          _dateTime = nearestAvailableTime.date;
          _dateController.text = formatMeetingDate(nearestAvailableTime.date);
          _fromTime = startTime;
          _fromController.text = timeToString(startTime);
          _toTime = endTime;
          _toController.text = timeToString(endTime);
        });
      }
    }
  }

  Future<void> _navigateAndUpdateSchedule(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimePlannerPage(
          userID: widget.isBuddy ? widget.connection.buddyID : widget.connection.elderID,
          personID: widget.isBuddy ? widget.connection.elderID : widget.connection.buddyID,
          isBuddy: widget.isBuddy,
          meetingSchedule: selectedDay!,
        ),
      ),
    );

    if (result != null && result is MeetingSchedule) {
      setState(() {
        selectedDay = result;
      });

      final startTime = formatIntToTime(selectedDay!.startHour);
      final endTime = addOneHour(startTime);
      selectedDay = MeetingSchedule(date: selectedDay!.date, startHour: selectedDay!.startHour, endHour: timeToInt(endTime));
      setState(() {
        _dateTime = selectedDay!.date;
        _dateController.text = formatMeetingDate(selectedDay!.date);
        _fromTime = startTime;
        _fromController.text = timeToString(startTime);
        _toTime = endTime;
        _toController.text = timeToString(endTime);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El horario del encuentro ha sido actualizado a ${formatMeetingDate(selectedDay!.date)} con éxito.')),
      );
    }
  }

  MeetingSchedule? findNearestAvailableMeetingSchedule(
    List<custom_time.TimeOfDay> availability,
    List<Meeting> meetings,
    List<Meeting> meetingsElder,
  ) {
    List<MeetingSchedule> schedules = [];
    DateTime now = DateTime.now();
    Set<String> availableDays = availability.map((a) => a.dayOfWeek).toSet();

    DateTime fixedStartOfDay = DateTime(now.year, now.month, now.day);

    for (int i = 0; i < 7; i++) {
      DateTime currentDate = fixedStartOfDay.add(Duration(days: i));
      String day = weekdays[currentDate.weekday - 1];

      if (availableDays.contains(day)) {
        var daySlots = availability.where((a) => a.dayOfWeek == day).toList();

        for (var slot in daySlots) {
          DateTime slotStart = currentDate.add(Duration(hours: slot.from ~/ 100, minutes: slot.from % 100));
          DateTime slotEnd = currentDate.add(Duration(hours: slot.to ~/ 100, minutes: slot.to % 100));

          for (var meeting in meetings) {
            if (meeting.schedule.date.weekday == slotStart.weekday) {
              DateTime meetingStart = meeting.schedule.date.add(Duration(hours: meeting.schedule.startHour ~/ 100));
              DateTime meetingEnd = meeting.schedule.date.add(Duration(hours: meeting.schedule.endHour ~/ 100));

              if ((meetingStart.isBefore(slotEnd) && meetingEnd.isAfter(slotStart))) {
                if (meetingStart.isAfter(slotStart)) {
                  slotEnd = meetingStart;
                } else if (meetingEnd.isBefore(slotEnd)) {
                  slotStart = meetingEnd;
                } else {
                  slotStart = slotEnd;
                }
              }
            }
          }

          for (var meeting in meetingsElder) {
            if (meeting.schedule.date.weekday == slotStart.weekday) {
              DateTime meetingStart = meeting.schedule.date.add(Duration(hours: meeting.schedule.startHour ~/ 100));
              DateTime meetingEnd = meeting.schedule.date.add(Duration(hours: meeting.schedule.endHour ~/ 100));

              if ((meetingStart.isBefore(slotEnd) && meetingEnd.isAfter(slotStart))) {
                if (meetingStart.isAfter(slotStart)) {
                  slotEnd = meetingStart;
                } else if (meetingEnd.isBefore(slotEnd)) {
                  slotStart = meetingEnd;
                } else {
                  slotStart = slotEnd;
                }
              }
            }
          }

          if (slotStart.isBefore(slotEnd)) {
            schedules.add(MeetingSchedule(
              date: slotStart,
              startHour: slotStart.hour * 100 + slotStart.minute,
              endHour: slotEnd.hour * 100 + slotEnd.minute,
            ));
          }
        }
      }
    }

    List<MeetingSchedule> oneHourSchedules = schedules
        .where((schedule) => schedule.endHour - schedule.startHour >= 100)
        .toList();
    
    oneHourSchedules.sort((a, b) => a.date.compareTo(b.date));

    return oneHourSchedules.isNotEmpty ? oneHourSchedules.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthSessionProvider>(context);
    final scaffoldContext = context;

    return Scaffold(
      appBar: AppBar(
        title: Text('Programar encuentro'),
        actions: [
          IconButton(
            onPressed: () async {
              final placeName = _placeNameController.text;
              final streetName = _streetNameController.text;
              final int? streetNumber = int.tryParse(_streetNumberController.text);
              final city = _cityController.text;
              final state = _stateController.text;
              final country = _countryController.text;
              final activity = _activityController.text;
              if (_dateTime == null || _fromTime == null || _toTime == null ||
              !placeName.isNotEmpty || !streetName.isNotEmpty || streetNumber == null || streetNumber.toString().length > 4 || !city.isNotEmpty ||
              !state.isNotEmpty || !country.isNotEmpty || !activity.isNotEmpty) {
                final snackBar = SnackBar(
                  content: Text('Por favor, complete todos los campos correctamente.'),
                  backgroundColor: theme.colorScheme.error,
                );
                // Navigator.pop(scaffoldContext);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (!validateMeetingTimeRange(_fromTime, _toTime)) {
                // Navigator.pop(scaffoldContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, el encuentro tiene que ser de una hora.'),
                  ),
                );
              } else {
                print('Meeting scheduled for: ${formatMeetingDate(_dateTime!)} from $_fromTime to $_toTime');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Encuentro creado correctamente')),
                );
                final meeting = Meeting(
                  schedule: MeetingSchedule(
                    date: _dateTime ?? DateTime.now(), 
                    startHour: timeToInt(_fromTime!), 
                    endHour: timeToInt(_toTime!)
                  ),
                  location: MeetingLocation(
                    isEldersHome: _isElderHouseSelected, 
                    placeName: placeName, 
                    streetName: streetName, 
                    streetNumber: streetNumber, 
                    city: city, 
                    state: state, 
                    country: country), 
                  activity: activity, 
                  dateLastModification: DateTime.now(),
                  isPaymentPending: true,
                );
                await sendNewMeeting(meeting);
                //Navigator.pop(scaffoldContext);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Día",
                              hintText: "Seleccione un día",
                              hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                              suffixIcon: Icon(Icons.calendar_month, size: 24),
                            ),
                            // onTap: () => _selectDate(context),
                          ),
                        ),
                        const SizedBox(width: 15.0),
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
                              labelText: "Inicio",
                              hintText: "Seleccione una hora",
                              hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                              suffixIcon: Icon(Icons.access_time, size: 24),
                            ),
                            // onTap: () {
                            //   if (_dateTime != null) {
                            //     _selectTime(context, true);
                            //   } else {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(content: Text('Por favor selecciona un día primero')),
                            //     );
                            //   }
                            // },
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: TextFormField(
                            controller: _toController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Fin",
                              hintText: "Seleccione una hora",
                              hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                              suffixIcon: Icon(Icons.access_time, size: 24),
                            ),
                            // onTap: () {
                            //   if (_dateTime != null) {
                            //     _selectTime(context, false);
                            //   } else {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(content: Text('Por favor selecciona un día primero')),
                            //     );
                            //   }
                            // },
                          ),
                        ),
                        const SizedBox(width: 15.0),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(18, 20, 18, 20),
                      child: Center(
                        child: BaseElevatedButton(
                          text: 'Ver otros horarios',
                          buttonTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          buttonStyle: ThemeButtonStyle.primaryContainerRoundedButtonStyle(context),
                          onPressed: () => _navigateAndUpdateSchedule(context),
                          height: 40,
                          width: 200,
                        ),
                      ),
                    ),
                    // determinar si ya con poner mi casa alcanza para que no ponga nada mas con respecto al lugar
                    Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: TextFormField(
                                controller: _placeNameController,
                                readOnly: _isElderHouseSelected,
                                decoration: InputDecoration(
                                  labelText: "Nombre del lugar",
                                  hintText: "Ingrese el nombre",
                                  hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isElderHouseSelected,
                                  onChanged: (value) => setState(() {
                                    final address = authProvider.userData?.elder!.personalData.address;
                                    _isElderHouseSelected = value!;
                                    _isElderHouseAddress = value;
                                    _placeNameController.text = value ? 'Casa de ${authProvider.userData?.elder!.personalData.firstName}' : '';
                                    if (value && address != null) {
                                      _streetNameController.text = address.streetName;
                                      _streetNumberController.text = address.streetNumber.toString();
                                      _cityController.text = address.city;
                                      _stateController.text = address.state;
                                      _countryController.text = address.country;
                                    } else {
                                      _streetNameController.text = '';
                                      _streetNumberController.text = '';
                                      _cityController.text = '';
                                      _stateController.text = '';
                                    }
                                  }),
                                ),
                                Text(_isElderHouseController.text),
                              ],
                            ),
                            const SizedBox(width: 15.0),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: TextFormField(
                                controller: _streetNameController,
                                readOnly: _isElderHouseAddress,
                                decoration: InputDecoration(
                                  labelText: "Calle",
                                  hintText: "Ingrese el nombre de la calle",
                                  hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: TextFormField(
                                controller: _streetNumberController,
                                readOnly: _isElderHouseAddress,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Número",
                                  hintText: "Ingrese el número",
                                  hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: TextFormField(
                                controller: _cityController,
                                readOnly: _isElderHouseAddress,
                                decoration: InputDecoration(
                                  labelText: "Ciudad",
                                  hintText: "Ingrese la ciudad",
                                  hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: TextFormField(
                                controller: _stateController,
                                readOnly: _isElderHouseAddress,
                                decoration: InputDecoration(
                                  labelText: "Provincia",
                                  hintText: "Ingrese la provincia",
                                  hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: TextFormField(
                                controller: _countryController,
                                readOnly: _isElderHouseAddress,
                                decoration: InputDecoration(
                                  labelText: "País",
                                  hintText: "Ingrese el país",
                                  hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                          ]
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: TextFormField(
                                controller: _activityController,
                                decoration: InputDecoration(
                                  labelText: "Actividad",
                                  hintText: "Ingrese la actividad a realizar",
                                  hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                                  suffixIcon: Icon(Icons.accessibility_new_rounded, size: 24),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                          ]
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendNewMeeting(Meeting meeting) async {
    final combinedMessage = 'Encuentro programado el día ${getDayName(meeting.schedule.date)} desde ${intToTime(meeting.schedule.startHour)} hasta ${intToTime(meeting.schedule.endHour)} en ${meeting.location.placeName}';
    
    if (combinedMessage.isNotEmpty) {
      await connectionService.createMeetingOfConnection(context, widget.connection, meeting);
      // await chatService.sendMessageNewMeeting(widget.chatRoomID, combinedMessage);
    }
  }
}