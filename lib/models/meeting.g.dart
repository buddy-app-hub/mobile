// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meeting _$MeetingFromJson(Map<String, dynamic> json) => Meeting(
      meetingID: json['meetingID'] as String?,
      schedule:
          MeetingSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
      location:
          MeetingLocation.fromJson(json['location'] as Map<String, dynamic>),
      isCancelled: json['isCancelled'] as bool? ?? false,
      isConfirmedByBuddy: json['isConfirmedByBuddy'] as bool? ?? false,
      isConfirmedByElder: json['isConfirmedByElder'] as bool? ?? false,
      isRescheduled: json['isRescheduled'] as bool? ?? false,
      isPaymentPending: json['isPaymentPending'] as bool? ?? false,
      activity: json['activity'] as String,
      dateLastModification:
          DateTime.parse(json['dateLastModification'] as String),
      elderRatingForBuddy: json['elderRatingForBuddy'] == null
          ? null
          : Review.fromJson(
              json['elderRatingForBuddy'] as Map<String, dynamic>),
      buddyRatingForElder: json['buddyRatingForElder'] == null
          ? null
          : Review.fromJson(
              json['buddyRatingForElder'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
      'meetingID': instance.meetingID,
      'isCancelled': instance.isCancelled,
      'isConfirmedByBuddy': instance.isConfirmedByBuddy,
      'isConfirmedByElder': instance.isConfirmedByElder,
      'isRescheduled': instance.isRescheduled,
      'isPaymentPending': instance.isPaymentPending,
      'activity': instance.activity,
      'dateLastModification': instance.dateLastModification.toIso8601String(),
      'elderRatingForBuddy': instance.elderRatingForBuddy?.toJson(),
      'buddyRatingForElder': instance.buddyRatingForElder?.toJson(),
      'location': instance.location.toJson(),
      'schedule': instance.schedule.toJson(),
    };
