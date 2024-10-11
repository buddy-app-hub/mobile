// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meeting _$MeetingFromJson(Map<String, dynamic> json) => Meeting(
      date: TimeOfDay.fromJson(json['date'] as Map<String, dynamic>),
      location:
          MeetingLocation.fromJson(json['location'] as Map<String, dynamic>),
      isCancelled: json['isCancelled'] as bool? ?? false,
      isConfirmedByBuddy: json['isConfirmedByBuddy'] as bool? ?? false,
      isConfirmedByElder: json['isConfirmedByElder'] as bool? ?? false,
      isRescheduled: json['isRescheduled'] as bool? ?? false,
      activity: json['activity'] as String,
      dateLastModification:
          DateTime.parse(json['dateLastModification'] as String),
      elderRatingForBuddy: (json['elderRatingForBuddy'] as num?)?.toInt(),
      buddyRatingForElder: (json['buddyRatingForElder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
      'date': instance.date.toJson(),
      'isCancelled': instance.isCancelled,
      'isConfirmedByBuddy': instance.isConfirmedByBuddy,
      'isConfirmedByElder': instance.isConfirmedByElder,
      'isRescheduled': instance.isRescheduled,
      'activity': instance.activity,
      'dateLastModification': instance.dateLastModification.toIso8601String(),
      'elderRatingForBuddy': instance.elderRatingForBuddy,
      'buddyRatingForElder': instance.buddyRatingForElder,
      'location': instance.location.toJson(),
    };
