import 'package:flutter/material.dart';

String formattedDate() {
  DateTime now = DateTime.now();
  List<String> months = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto',
    'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];
  List<String> weekdays = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];
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