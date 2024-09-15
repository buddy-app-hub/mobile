import 'package:flutter/material.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_location.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/chat_service.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/utils/format_date.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/base_card_meeting.dart';

import 'package:provider/provider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';

//si se usa el mismo tipo que cuando se crea un nuevo encuentro
// class MeetingBottomSheet {
//   void show(BuildContext context, bool isBuddy, Connection connection, Meeting meeting) {
//     final scaffoldContext = context;

//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           // height: 1500,
//           child: 
//           MeetingPage(isBuddy: isBuddy,connection: connection, meeting: meeting, scaffoldContext: scaffoldContext,),
//         );
//       },
//     );
//   }
// }


// class MeetingPage extends StatefulWidget {
//   final bool isBuddy;
//   final Connection connection;
//   final Meeting meeting;
//   final BuildContext scaffoldContext;

//   const MeetingPage({Key? key, required this.isBuddy, required this.connection, required this.meeting, required this.scaffoldContext}) : super(key: key);
//   @override
//   _MeetingPageState createState() => _MeetingPageState();
// }

// class _MeetingPageState extends State<MeetingPage> {
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _fromController = TextEditingController();
//   final TextEditingController _toController = TextEditingController();
//   final TextEditingController _isElderHouseController = TextEditingController();
//   final TextEditingController _placeNameController = TextEditingController();
//   final TextEditingController _streetNameController = TextEditingController();
//   final TextEditingController _streetNumberController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _activityController = TextEditingController();
  
//   bool _isElderHouseSelected = false;
//   bool _isElderHouseAddress = false;
//   final chatService = ChatService();
//   final connectionService = ConnectionService();
//   DateTime? _dateTime;
//   TimeOfDay? _fromTime;
//   TimeOfDay? _toTime;

//   @override
//   void initState() {
//     super.initState();
//     final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
//     _isElderHouseController.text = 'Mi casa' ; 
//     _isElderHouseSelected = widget.meeting.location.isEldersHome;
//     _dateController.text = widget.meeting.date.dayOfWeek;
//     _fromController.text = intToTime(widget.meeting.date.from);
//     _toController.text = intToTime(widget.meeting.date.to);
//     _placeNameController.text = widget.meeting.location.placeName;
//     _streetNameController.text = widget.meeting.location.streetName;
//     _streetNumberController.text = widget.meeting.location.streetNumber.toString();
//     _cityController.text = widget.meeting.location.city;
//     _stateController.text = widget.meeting.location.state;
//     _countryController.text = widget.meeting.location.country;
//     _activityController.text = widget.meeting.activity;
//     _dateTime = formatTimeOfDayToDate(widget.meeting.date);
//     _fromTime = formatIntToTime(widget.meeting.date.from);
//     _toTime = formatIntToTime(widget.meeting.date.to);
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _dateTime,
//       firstDate: DateTime.now().subtract(const Duration(days: 7)),
//       lastDate: DateTime.now().add(const Duration(days: 7)),
//       helpText: 'Seleccionar un día',
//       cancelText: 'Cancelar',
//       initialEntryMode: DatePickerEntryMode.calendarOnly,
//     );
//     if (picked != null) {
//       setState(() {
//         _dateTime = picked;
//         _dateController.text = formatMeetingDate(picked);
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context, bool isFromTime) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialEntryMode: TimePickerEntryMode.inputOnly,
//       initialTime: isFromTime
//           ? (_fromTime ?? TimeOfDay.now())
//           : (_toTime ?? TimeOfDay.now()),
//       cancelText: 'Cancelar',
//       helpText: 'Ingresar una hora',
//       errorInvalidText: 'Ingresá una hora válida',
//       hourLabelText: 'Hora',
//       minuteLabelText: 'Minutos',
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFromTime) {
//           _fromTime = picked;
//           _fromController.text = picked.format(context);
//         } else {
//           _toTime = picked;
//           _toController.text = picked.format(context);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final authProvider = Provider.of<AuthSessionProvider>(context);
//     final BuddyService buddyService = BuddyService();
//     final ElderService elderService = ElderService();
//     final scaffoldContext = context;

//     return SingleChildScrollView(
//       child: Container(
//         margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Generar un nuevo encuentro',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     final placeName = _placeNameController.text;
//                     final streetName = _streetNameController.text;
//                     final int? streetNumber = int.tryParse(_streetNumberController.text);
//                     final city = _cityController.text;
//                     final state = _stateController.text;
//                     final country = _countryController.text;
//                     final activity = _activityController.text;
//                     if (_dateTime == null || _fromTime == null || _toTime == null ||
//                     !placeName.isNotEmpty || !streetName.isNotEmpty || streetNumber == null || streetNumber.toString().length > 4 || !city.isNotEmpty ||
//                     !state.isNotEmpty || !country.isNotEmpty || !activity.isNotEmpty) {
//                       final snackBar = SnackBar(
//                         content: Text('Por favor, complete todos los campos correctamente.'),
//                         backgroundColor: theme.colorScheme.error,
//                       );
//                       Navigator.pop(scaffoldContext);
//                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                     } else if (!validateMeetingTimeRange(_fromTime, _toTime)) {
//                       Navigator.pop(scaffoldContext);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Por favor, el encuentro tiene que ser de una hora.'),
//                         ),
//                       );
//                     } else {
//                       print('Meeting scheduled for: ${formatMeetingDate(_dateTime!)} from $_fromTime to $_toTime');
//                       final newMeeting = Meeting(
//                         date: formatDateTimeOfDay(_dateTime, _fromTime, _toTime),
//                         location: MeetingLocation(
//                           isEldersHome: _isElderHouseSelected, 
//                           placeName: placeName, 
//                           streetName: streetName, 
//                           streetNumber: streetNumber, 
//                           city: city, 
//                           state: state, 
//                           country: country), 
//                         activity: activity, 
//                         dateLastModification: widget.meeting.dateLastModification,
//                       );
//                       editMeeting(newMeeting);
//                       Navigator.pop(context);
//                       setState(() {
//                         _dateController.clear();
//                         _fromController.clear();
//                         _toController.clear();
//                         _placeNameController.clear();
//                         _streetNameController.clear();
//                         _streetNumberController.clear();
//                         _cityController.clear();
//                         _stateController.clear();
//                         _countryController.clear();
//                         _activityController.clear();
//                         _dateTime = null;
//                         _fromTime = null;
//                         _toTime = null;
//                       });
//                     }
//                   },
//                   icon: Icon(Icons.check),
//                 ),
//               ],
//             ),    
//             Row(
//               children: [
//                 const SizedBox(width: 15.0),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _dateController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: "Día",
//                       hintText: "Ingrese un día",
//                       hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
//                       suffixIcon: Icon(Icons.calendar_month, size: 24),
//                     ),
//                     onTap: () => _selectDate(context),
//                   ),
//                 ),
//                 const SizedBox(width: 15.0),
//               ],
//             ),
//             Row(
//               children: [
//                 const SizedBox(width: 15.0),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _fromController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: "Inicio",
//                       hintText: "Ingrese una hora",
//                       hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
//                       suffixIcon: Icon(Icons.access_time, size: 24),
//                     ),
//                     onTap: () => _selectTime(context, true),
//                   ),
//                 ),
//                 const SizedBox(width: 15.0),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _toController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: "Fin",
//                       hintText: "Ingrese una hora",
//                       hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
//                       suffixIcon: Icon(Icons.access_time, size: 24),
//                     ),
//                     onTap: () => _selectTime(context, false),
//                   ),
//                 ),
//                 const SizedBox(width: 15.0),
//               ],
//             ),
//             // determinar si ya con poner mi casa alcanza para que no ponga nada mas con respecto al lugar
//             Column(
//               children: [
//                 Row(
//                   children: [
//                     const SizedBox(width: 15.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _placeNameController,
//                         readOnly: _isElderHouseSelected,
//                         decoration: InputDecoration(
//                           labelText: "Nombre del lugar",
//                           hintText: "Ingrese el nombre",
//                           hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15.0),
//                     if (!widget.isBuddy)
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: _isElderHouseSelected,
//                           onChanged: (value) => setState(() {
//                             final address = authProvider.userData?.elder!.personalData.address;
//                             _isElderHouseSelected = value!;
//                             _placeNameController.text = value ? 'Casa de ${authProvider.userData?.elder!.personalData.firstName}' : '';
//                             if (value && address != null) {
//                               _isElderHouseAddress = value;
//                               _streetNameController.text = address.streetName;
//                               _streetNumberController.text = address.streetNumber as String;
//                               _cityController.text = address.city;
//                               _stateController.text = address.state;
//                               _countryController.text = address.country;
//                             }
//                           }),
//                         ),
//                         Text(_isElderHouseController.text),
//                       ],
//                     ),
//                     const SizedBox(width: 15.0),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const SizedBox(width: 15.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _streetNameController,
//                         readOnly: _isElderHouseAddress || widget.isBuddy,
//                         decoration: InputDecoration(
//                           labelText: "Calle",
//                           hintText: "Ingrese el nombre de la calle",
//                           hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _streetNumberController,
//                         readOnly: _isElderHouseAddress || widget.isBuddy,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           labelText: "Número",
//                           hintText: "Ingrese el número",
//                           hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15.0),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const SizedBox(width: 15.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _cityController,
//                         readOnly: _isElderHouseAddress || widget.isBuddy,
//                         decoration: InputDecoration(
//                           labelText: "Ciudad",
//                           hintText: "Ingrese la ciudad",
//                           hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _stateController,
//                         readOnly: _isElderHouseAddress || widget.isBuddy,
//                         decoration: InputDecoration(
//                           labelText: "Provincia",
//                           hintText: "Ingrese la provincia",
//                           hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15.0),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const SizedBox(width: 15.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _countryController,
//                         readOnly: _isElderHouseAddress || widget.isBuddy,
//                         decoration: InputDecoration(
//                           labelText: "País",
//                           hintText: "Ingrese el país",
//                           hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15.0),
//                   ]
//                 ),
//                 Row(
//                   children: [
//                     const SizedBox(width: 15.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _activityController,
//                         readOnly: widget.isBuddy,
//                         decoration: InputDecoration(
//                           labelText: "Actividad",
//                           hintText: "Ingrese la actividad a realizar",
//                           hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
//                           suffixIcon: Icon(Icons.accessibility_new_rounded, size: 24),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15.0),
//                   ]
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> editMeeting(Meeting meeting) async {
//     final combinedMessage = 'Encuentro programado el día ${meeting.date} desde ${intToTime(meeting.date.from)} hasta ${intToTime(meeting.date.from)} en ${meeting.location.placeName}';
    
//     if (combinedMessage.isNotEmpty) {
//       await connectionService.updateConnectionMeetings(context, widget.connection, meeting);
//       // await chatService.sendMessageNewMeeting(widget.chatRoomID, combinedMessage);
//     }
//   }
// }



class EditMeetingPage extends StatefulWidget {
  final bool isBuddy;
  final Connection connection;
  final Meeting meeting;

  const EditMeetingPage({Key? key, required this.isBuddy, required this.connection, required this.meeting}) : super(key: key);
  @override
  _EditMeetingPageState createState() => _EditMeetingPageState();
}

class _EditMeetingPageState extends State<EditMeetingPage> {
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
  final chatService = ChatService();
  final connectionService = ConnectionService();
  DateTime? _dateTime;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    _isElderHouseController.text = 'Mi casa' ; 
    _isElderHouseSelected = widget.meeting.location.isEldersHome;
    _dateController.text = widget.meeting.date.dayOfWeek;
    _fromController.text = intToTime(widget.meeting.date.from);
    _toController.text = intToTime(widget.meeting.date.to);
    _placeNameController.text = widget.meeting.location.placeName;
    _streetNameController.text = widget.meeting.location.streetName;
    _streetNumberController.text = widget.meeting.location.streetNumber.toString();
    _cityController.text = widget.meeting.location.city;
    _stateController.text = widget.meeting.location.state;
    _countryController.text = widget.meeting.location.country;
    _activityController.text = widget.meeting.activity;
    _dateTime = formatTimeOfDayToDate(widget.meeting.date);
    _fromTime = formatIntToTime(widget.meeting.date.from);
    _toTime = formatIntToTime(widget.meeting.date.to);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      helpText: 'Seleccionar un día',
      cancelText: 'Cancelar',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      setState(() {
        _dateTime = picked;
        _dateController.text = formatMeetingDate(picked);
      });
    }
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
    final scaffoldContext = context;

  
    return Scaffold(
      appBar: AppBar(
        title: Text('Reprogramar encuentro'),
        actions: [
          IconButton(
            onPressed: () {
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
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (!validateMeetingTimeRange(_fromTime, _toTime)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, el encuentro tiene que ser de una hora.'),
                  ),
                );
              } else {
                print('Meeting scheduled for: ${formatMeetingDate(_dateTime!)} from $_fromTime to $_toTime');
                final newMeeting = Meeting(
                  date: formatDateTimeOfDay(_dateTime, _fromTime, _toTime),
                  location: MeetingLocation(
                    isEldersHome: _isElderHouseSelected, 
                    placeName: placeName, 
                    streetName: streetName, 
                    streetNumber: streetNumber, 
                    city: city, 
                    state: state, 
                    country: country), 
                  activity: activity, 
                  dateLastModification: widget.meeting.dateLastModification,
                  isRescheduled: true,
                );
                editMeeting(newMeeting);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Encuentro modificado correctamente')),
                );
                Navigator.pushNamed(context, Routes.splashScreen);
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
                            hintText: "Ingrese un día",
                            hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                            suffixIcon: Icon(Icons.calendar_month, size: 24),
                          ),
                          onTap: () => _selectDate(context),
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
                            labelText: "Fin",
                            hintText: "Ingrese una hora",
                            hintStyle: ThemeTextStyle.titleSmallOnSecondary(context),
                            suffixIcon: Icon(Icons.access_time, size: 24),
                          ),
                          onTap: () => _selectTime(context, false),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                    ],
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
                          if (!widget.isBuddy)
                          Row(
                            children: [
                              Checkbox(
                                value: _isElderHouseSelected,
                                onChanged: (value) => setState(() {
                                  final address = authProvider.userData?.elder!.personalData.address;
                                  _isElderHouseSelected = value!;
                                  _placeNameController.text = value ? 'Casa de ${authProvider.userData?.elder!.personalData.firstName}' : '';
                                  if (value && address != null) {
                                    _isElderHouseAddress = value;
                                    _streetNameController.text = address.streetName;
                                    _streetNumberController.text = address.streetNumber as String;
                                    _cityController.text = address.city;
                                    _stateController.text = address.state;
                                    _countryController.text = address.country;
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
                              readOnly: _isElderHouseAddress || widget.isBuddy,
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
                              readOnly: _isElderHouseAddress || widget.isBuddy,
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
                              readOnly: _isElderHouseAddress || widget.isBuddy,
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
                              readOnly: _isElderHouseAddress || widget.isBuddy,
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
                              readOnly: _isElderHouseAddress || widget.isBuddy,
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
                              readOnly: widget.isBuddy,
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
        ],
      ),
    );
  }

  Future<void> editMeeting(Meeting meeting) async {
    final combinedMessage = 'Encuentro programado el día ${meeting.date} desde ${intToTime(meeting.date.from)} hasta ${intToTime(meeting.date.from)} en ${meeting.location.placeName}';
    
    if (combinedMessage.isNotEmpty) {
      await connectionService.updateConnectionMeetings(context, widget.connection, meeting);
    }
  }
}