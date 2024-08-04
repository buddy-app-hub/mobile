// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Elder _$ElderFromJson(Map<String, dynamic> json) => Elder(
      firebaseUID: json['firebaseUID'] as String,
      isBlocked: json['isBlocked'] as bool,
      registrationMethod: json['registrationMethod'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      onLovedOneMode: json['onLovedOneMode'] as bool,
      lovedOne: json['lovedOne'] == null
          ? null
          : LovedOne.fromJson(json['lovedOne'] as Map<String, dynamic>),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      nationality: json['nationality'] as String,
      maritalStatus: json['maritalStatus'] as String,
      email: json['email'] as String,
      phoneNumber:
          PhoneNumber.fromJson(json['phoneNumber'] as Map<String, dynamic>),
      identityCard:
          IdentityCard.fromJson(json['identityCard'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      elderProfile:
          ElderProfile.fromJson(json['elderProfile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ElderToJson(Elder instance) => <String, dynamic>{
      'firebaseUID': instance.firebaseUID,
      'isBlocked': instance.isBlocked,
      'registrationMethod': instance.registrationMethod,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'onLovedOneMode': instance.onLovedOneMode,
      'lovedOne': instance.lovedOne?.toJson(),
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'gender': instance.gender,
      'birthDate': instance.birthDate.toIso8601String(),
      'nationality': instance.nationality,
      'maritalStatus': instance.maritalStatus,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber.toJson(),
      'identityCard': instance.identityCard.toJson(),
      'address': instance.address.toJson(),
      'elderProfile': instance.elderProfile.toJson(),
    };
