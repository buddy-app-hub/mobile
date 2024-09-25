import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;

List<String> months = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto',
  'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
];

List<String> weekdays = [
  'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo' //fix acentos los trae raros
];

String formattedDate() {
  DateTime now = DateTime.now();
  
  String day = now.day.toString();
  String weekday = weekdays[now.weekday - 1];
  String month = months[now.month - 1];
  return '$weekday $day de $month';
}

String formatMeetingDate(DateTime date) {
  return '${weekdays[date.weekday - 1]} ${date.day} de ${months[date.month - 1]} del ${date.year}';
}

String formatDayOfWeek(int weekday) {
  return weekdays[weekday - 1];
}

int timeToInt(TimeOfDay time) {
  return time.hour * 100 + time.minute;
}

String intToTime(int time) {
  int hour = time ~/ 100;
  int minute = time % 100;
  
  String hourStr = hour.toString().padLeft(2, '0');
  String minuteStr = minute.toString().padLeft(2, '0');
  
  return '$hourStr:$minuteStr';
}

String getHourFromTimestamp(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  final formatter = DateFormat('HH:mm');
  return formatter.format(dateTime);
}

String getTimeFromTimestamp(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  final formatter = DateFormat('HH:mm');
  final todayDate = DateTime.now();
  final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
  final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final difference = today.difference(messageDate);
  if (today.isAtSameMomentAs(messageDate)) {
    return formatter.format(dateTime);
  } else if (difference.inDays == 1) {
    return 'Ayer';
  } else if ((difference.inDays > 1) && (difference.inDays < 7)) {
    return weekdays[messageDate.weekday - 1];
  } else {
    return '${messageDate.day}/${messageDate.month}/${messageDate.year}';
  }
}

String formatDateChat(DateTime date) {
  final todayDate = DateTime.now();
  final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
  final messageDate = DateTime(date.year, date.month, date.day);
  final difference = today.difference(messageDate);
  if (today.isAtSameMomentAs(messageDate)) {
    return 'Hoy';
  } else if (difference.inDays == 1) {
    return 'Ayer';
  } else if ((difference.inDays > 1) && (difference.inDays < 7)) {
    return weekdays[messageDate.weekday - 1];
  } else {
    return '${messageDate.day} de ${months[messageDate.month - 1]} de ${messageDate.year}';
  }
}

custom_time.TimeOfDay formatDateTimeOfDay(DateTime? date, TimeOfDay?fromTime, TimeOfDay? toTime) {
  return custom_time.TimeOfDay(
    dayOfWeek: '${weekdays[date!.weekday - 1]} ${date.day} de ${months[date.month - 1]} del ${date.year}',
    from: timeToInt(fromTime!),
    to: timeToInt(toTime!),
  );
}


DateTime formatTimeOfDayToDate(custom_time.TimeOfDay timeOfDay) {
  final List<String> dateParts = timeOfDay.dayOfWeek.split(' ');

  final int day = int.parse(dateParts[1]);
  final int month = months.indexOf(dateParts[3]) + 1;
  final int? year = int.tryParse(dateParts[5]);
  return DateTime(year!, month, day);
}

TimeOfDay formatIntToTime(int time) {
  int hour = time ~/ 100;
  int minute = time % 100;
  return TimeOfDay(hour: hour, minute: minute);
}