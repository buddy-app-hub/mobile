// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elder_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElderProfile _$ElderProfileFromJson(Map<String, dynamic> json) => ElderProfile(
      description: json['description'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => Interest.fromJson(e as Map<String, dynamic>))
          .toList(),
      availability: (json['availability'] as List<dynamic>?)
          ?.map((e) => TimeOfDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      globalRating: (json['globalRating'] as num?)?.toDouble(),
      connectionPreferences: json['connectionPreferences'] == null
          ? null
          : ConnectionPreferences.fromJson(
              json['connectionPreferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ElderProfileToJson(ElderProfile instance) =>
    <String, dynamic>{
      'description': instance.description,
      'interests': instance.interests?.map((e) => e.toJson()).toList(),
      'availability': instance.availability?.map((e) => e.toJson()).toList(),
      'photos': instance.photos,
      'globalRating': instance.globalRating,
      'connectionPreferences': instance.connectionPreferences?.toJson(),
    };
