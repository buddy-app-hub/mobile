// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buddy_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuddyProfile _$BuddyProfileFromJson(Map<String, dynamic> json) => BuddyProfile(
      isOnPause: json['isOnPause'] as bool? ?? false,
      description: json['description'] as String?,
      studentDetails: json['studentDetails'] == null
          ? null
          : StudentDetails.fromJson(
              json['studentDetails'] as Map<String, dynamic>),
      workerDetails: json['workerDetails'] == null
          ? null
          : WorkerDetails.fromJson(
              json['workerDetails'] as Map<String, dynamic>),
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => Interest.fromJson(e as Map<String, dynamic>))
          .toList(),
      availability: (json['availability'] as List<dynamic>?)
          ?.map((e) => TimeOfDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      globalRating: (json['globalRating'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BuddyProfileToJson(BuddyProfile instance) =>
    <String, dynamic>{
      'isOnPause': instance.isOnPause,
      'description': instance.description,
      'studentDetails': instance.studentDetails?.toJson(),
      'workerDetails': instance.workerDetails?.toJson(),
      'interests': instance.interests?.map((e) => e.toJson()).toList(),
      'availability': instance.availability?.map((e) => e.toJson()).toList(),
      'photos': instance.photos,
      'globalRating': instance.globalRating,
    };
