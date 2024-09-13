import 'package:flutter/material.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/utils/format_date.dart';

String? validateEmail(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Ingresá un correo electrónico válido'
      : null;
}

String? validatePassword(String? value) {
  if (value!.isEmpty) {
    return 'Ingresá una contraseña';
  }
  if (value.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }
  return null;
}

String? validateConfirmPassword(String? value, String? password) {
  if (value!.isEmpty) {
    return 'Ingresá una contraseña';
  }
  if (value.length < 6) {
    return 'Las contraseñas no coinciden';
  }
  if (password != value) {
    return 'Las contraseñas no coinciden';
  }
  return null;
}

String? validateName(String? value) {
  if (value!.isEmpty) {
    return 'Ingresá un nombre';
  }
  return null;
}

bool validateHours(int startHour, int startMinute, int endHour, int endMinute) {
  if (endHour > startHour) {
    return true;
  } else if (endHour == startHour && endMinute > startMinute) {
    return true;
  }
  return false;
}

bool validateTimeRange(TimeOfDay? from, TimeOfDay? to) {
  if (from == null || to == null) {
    return false;
  }

  final fromMilliseconds = from.hour * 3600000 + from.minute * 60000;
  final toMilliseconds = to.hour * 3600000 + to.minute * 60000;
  final differenceMilliseconds = toMilliseconds - fromMilliseconds; //quitar restriccion de que tiene que ser minimo una hora si no va

  return fromMilliseconds < toMilliseconds && differenceMilliseconds >= 3600000;
}

bool validateMeetingTimeRange(TimeOfDay? from, TimeOfDay? to) {
  if (from == null || to == null) {
    return false;
  }

  final fromMilliseconds = from.hour * 3600000 + from.minute * 60000;
  final toMilliseconds = to.hour * 3600000 + to.minute * 60000;
  final differenceMilliseconds = toMilliseconds - fromMilliseconds; // encuentros de una hora

  return fromMilliseconds < toMilliseconds && differenceMilliseconds == 3600000;
}

bool validateDate(custom_time.TimeOfDay date) {
  final formattedDate = formatTimeOfDayToDate(date);

  final currentDate = DateTime.now();
  final nextWeekDate = currentDate.add(Duration(days: 7));
  return formattedDate.isAfter(currentDate) && formattedDate.isBefore(nextWeekDate);
}

bool validateFutureDate(custom_time.TimeOfDay date) {
  final formattedDate = formatTimeOfDayToDate(date);

  final currentDate = DateTime.now();
  return formattedDate.isAfter(currentDate);
}