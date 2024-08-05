// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_of_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeOfDay _$TimeOfDayFromJson(Map<String, dynamic> json) => TimeOfDay(
      dayOfWeek: json['dayOfWeek'] as String,
      from: (json['from'] as num).toInt(),
      to: (json['to'] as num).toInt(),
    );

Map<String, dynamic> _$TimeOfDayToJson(TimeOfDay instance) => <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'from': instance.from,
      'to': instance.to,
    };
