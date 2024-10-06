import 'package:flutter/material.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/meeting_location.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';

class BaseCardCalendar extends StatefulWidget {
  final List<Meeting> meetings;

  const BaseCardCalendar({super.key, required this.meetings});

  @override
  State<BaseCardCalendar> createState() => _BaseCardCalendarState();
}

class _BaseCardCalendarState extends State<BaseCardCalendar> {
  Future<List<Meeting>>? _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
        color: theme.colorScheme.surfaceVariant,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: theme.colorScheme.outline,
          onTap: () {
            debugPrint('Item tapped.');
          },
          child: SizedBox(
            width: 375,
            height: 230,
            child: _buildCalendarInfo(context, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarInfo(BuildContext context, ThemeData theme) {
    return FutureBuilder<List<Meeting>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error fetching events');
        } else {
          return _buildUpNextList(context, theme, snapshot.data!); // Use events
        }
      },
    );
  }

  Widget _buildUpNextList(BuildContext context, ThemeData theme, List<Meeting> meetings) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Text(
                  'Hoy, ${formattedDate()}',
                  style: ThemeTextStyle.titleMediumOnBackground(context),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ListView.builder(
              itemCount: meetings.length,
              itemBuilder: (context, index) {
                final meeting = meetings[index];
                return ListTile(
                  title: Text(meeting.date.dayOfWeek),
                  subtitle: Text(meeting.activity),
                  trailing: Text('${meeting.date.from} - ${meeting.date.to}'),
                  leading: Icon(Icons.calendar_today_outlined),
                  leadingAndTrailingTextStyle: ThemeTextStyle.titleSmallOnTertiaryContainer(context),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<List<Meeting>> fetchEvents() async {
    await Future.delayed(Duration(seconds: 1)); //cambiar a que se llame a la api
    return [
      Meeting(
        date: custom_time.TimeOfDay(dayOfWeek: 'Lunes', from: 14, to: 15),
        activity: 'Taller de Bordado', 
        isCancelled: false,
        isConfirmedByBuddy: true,
        isConfirmedByElder: true,
        isRescheduled: false,
        dateLastModification: DateTime.now(),
        location: MeetingLocation(
          isEldersHome: false,
          placeName: 'Taller',
          streetName: 'Av. 9 de Julio',
          streetNumber: 1234,
          city: 'CABA',
          state: 'CABA',
          country: 'Argentina'
        ),
      ),
      Meeting(
        date: custom_time.TimeOfDay(dayOfWeek: 'Martes', from: 16, to: 17),
        activity: 'Caminata por el parque', 
        isCancelled: false,
        isConfirmedByBuddy: true,
        isConfirmedByElder: true,
        isRescheduled: false,
        dateLastModification: DateTime.now(),
        location: MeetingLocation(
          isEldersHome: false,
          placeName: 'Parque Saavedra',
          streetName: 'Saavedra',
          streetNumber: 5312,
          city: 'CABA',
          state: 'CABA',
          country: 'Argentina'
        ),
      ),
    ];
  }
}
