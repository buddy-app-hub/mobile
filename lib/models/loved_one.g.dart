// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loved_one.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LovedOne _$LovedOneFromJson(Map<String, dynamic> json) => LovedOne(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      age: (json['age'] as num).toInt(),
      phoneNumber:
          PhoneNumber.fromJson(json['phoneNumber'] as Map<String, dynamic>),
      email: json['email'] as String,
      relationshipToElder: json['relationshipToElder'] as String,
    );

Map<String, dynamic> _$LovedOneToJson(LovedOne instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'relationshipToElder': instance.relationshipToElder,
    };
