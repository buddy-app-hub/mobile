import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<String> months = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto',
  'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
];

List<String> weekdays = [
  'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
];

String formattedDate() {
  DateTime now = DateTime.now();
  
  String day = now.day.toString();
  String weekday = weekdays[now.weekday - 1];
  String month = months[now.month - 1];
  return '$weekday $day de $month';
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
    return '${messageDate.day}/${months[messageDate.month - 1]}/${messageDate.year}';
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