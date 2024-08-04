// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map<String, dynamic> json) => Connection(
      id: json['id'] as String,
      elderID: json['elderID'] as String,
      buddyID: json['buddyID'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      meetings: (json['meetings'] as List<dynamic>)
          .map((e) => Meeting.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'elderID': instance.elderID,
      'buddyID': instance.buddyID,
      'creationDate': instance.creationDate.toIso8601String(),
      'meetings': instance.meetings.map((e) => e.toJson()).toList(),
    };
