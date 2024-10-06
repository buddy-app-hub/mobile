// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_buddy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedBuddy _$RecommendedBuddyFromJson(Map<String, dynamic> json) =>
    RecommendedBuddy(
      buddy: json['buddy'] == null
          ? null
          : Buddy.fromJson(json['buddy'] as Map<String, dynamic>),
      score: (json['score'] as num).toInt(),
      distanceToKM: (json['distanceToKM'] as num).toInt(),
      isDismissed: json['isDismissed'] as bool?,
      dateDismissed: json['dateDismissed'] == null
          ? null
          : DateTime.parse(json['dateDismissed'] as String),
    );

Map<String, dynamic> _$RecommendedBuddyToJson(RecommendedBuddy instance) =>
    <String, dynamic>{
      'buddy': instance.buddy?.toJson(),
      'score': instance.score,
      'distanceToKM': instance.distanceToKM,
      'isDismissed': instance.isDismissed,
      'dateDismissed': instance.dateDismissed?.toIso8601String(),
    };
