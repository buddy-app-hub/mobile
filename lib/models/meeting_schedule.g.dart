// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingSchedule _$MeetingScheduleFromJson(Map<String, dynamic> json) =>
    MeetingSchedule(
      date: DateTime.parse(json['date'] as String),
      startHour: (json['startHour'] as num).toInt(),
      endHour: (json['endHour'] as num).toInt(),
    );

Map<String, dynamic> _$MeetingScheduleToJson(MeetingSchedule instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'startHour': instance.startHour,
      'endHour': instance.endHour,
    };
