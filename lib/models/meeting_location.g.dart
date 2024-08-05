// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingLocation _$MeetingLocationFromJson(Map<String, dynamic> json) =>
    MeetingLocation(
      isEldersHome: json['isEldersHome'] as bool,
      placeName: json['placeName'] as String,
      streetName: json['streetName'] as String,
      streetNumber: (json['streetNumber'] as num).toInt(),
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$MeetingLocationToJson(MeetingLocation instance) =>
    <String, dynamic>{
      'isEldersHome': instance.isEldersHome,
      'placeName': instance.placeName,
      'streetName': instance.streetName,
      'streetNumber': instance.streetNumber,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
    };
