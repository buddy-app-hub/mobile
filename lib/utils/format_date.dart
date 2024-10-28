import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_planner/time_planner.dart';
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

String formatMeetingDateShort(DateTime date) {
  return 'Próximo ${weekdays[date.weekday - 1]} ${date.day} de ${months[date.month - 1]}';
}

String formatDayOfWeek(int weekday) {
  return weekdays[weekday - 1];
}

int timeToInt(TimeOfDay time) {
  return time.hour * 100 + time.minute;
}

String timeToString(TimeOfDay time) {
  String hourStr = time.hour.toString().padLeft(2, '0');
  String minuteStr = time.minute.toString().padLeft(2, '0');
  return '$hourStr:$minuteStr';
}

String intToTime(int time) {
  int hour = time ~/ 100;
  int minute = time % 100;
  
  String hourStr = hour.toString().padLeft(2, '0');
  String minuteStr = minute.toString().padLeft(2, '0');
  
  return '$hourStr:$minuteStr';
}

int intToTimeHour(int time) {
  int hour = time ~/ 100;
  return hour;
}

int intToTimeMinutes(int time) {
  int minute = time % 100;
  return minute;
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

String formatDateWallet(DateTime date) {
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
  } else if (today.year == messageDate.year) {
    return '${messageDate.day} ${months[messageDate.month - 1]}';
  } else {
    return '${messageDate.day} ${months[messageDate.month - 1]} ${messageDate.year}';
  }
}

TimeOfDay formatIntToTime(int time) {
  int hour = time ~/ 100;
  int minute = time % 100;

  return TimeOfDay(hour: hour, minute: minute);
}

TimeOfDay addOneHour(TimeOfDay time) {
  final int totalMinutes = time.hour * 60 + time.minute + 60;
  final int newHour = totalMinutes ~/ 60 % 24;
  final int newMinute = totalMinutes % 60;
  return TimeOfDay(hour: newHour, minute: newMinute);
}

TimeOfDay addTimeToHour(TimeOfDay time, int minutes) {
  final int totalMinutes = time.hour * 60 + time.minute + minutes;
  final int newHour = totalMinutes ~/ 60 % 24;
  final int newMinute = totalMinutes % 60;
  return TimeOfDay(hour: newHour, minute: newMinute);
}

bool isAfter(TimeOfDay t1, TimeOfDay t2) {
  return t1.hour > t2.hour || (t1.hour == t2.hour && t1.minute > t2.minute);
}

bool isBefore(TimeOfDay t1, TimeOfDay t2) {
  return t1.hour < t2.hour || (t1.hour == t2.hour && t1.minute < t2.minute);
}

bool isSameDay(DateTime d1, DateTime d2) {
  return d1.year == d2.year &&
         d1.month == d2.month &&
         d1.day == d2.day;
}

List<TimePlannerTitle> generateWeekPlanner() {
  DateTime now = DateTime.now();

  List<TimePlannerTitle> weekPlanner = [];

  for (int i = 0; i < 7; i++) {
    DateTime currentDate = now.add(Duration(days: i));
    String formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
    String title = weekdays[currentDate.weekday - 1];
    weekPlanner.add(TimePlannerTitle(date: formattedDate, title: title));
  }

  return weekPlanner;
}

int getPlannerDay(DateTime day) {
  DateTime now = DateTime.now();
  
  DateTime normalizedNow = DateTime(now.year, now.month, now.day);

  int differenceInDays = day.difference(normalizedNow).inDays;

  if (differenceInDays >= 0 && differenceInDays < 7) {
    return differenceInDays;
  } else {
    return -1;
  }
}