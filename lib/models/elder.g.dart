// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Elder _$ElderFromJson(Map<String, dynamic> json) => Elder(
      firebaseUID: json['firebaseUID'] as String,
      isBlocked: json['isBlocked'] as bool? ?? false,
      registrationMethod: json['registrationMethod'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      onLovedOneMode: json['onLovedOneMode'] as bool,
      lovedOne: json['lovedOne'] == null
          ? null
          : LovedOne.fromJson(json['lovedOne'] as Map<String, dynamic>),
      personalData:
          PersonalData.fromJson(json['personalData'] as Map<String, dynamic>),
      email: json['email'] as String,
      phoneNumber:
          PhoneNumber.fromJson(json['phoneNumber'] as Map<String, dynamic>),
      identityCard: json['identityCard'] == null
          ? null
          : IdentityCard.fromJson(json['identityCard'] as Map<String, dynamic>),
      elderProfile: json['elderProfile'] == null
          ? null
          : ElderProfile.fromJson(json['elderProfile'] as Map<String, dynamic>),
      recommendedBuddy: (json['recommendedBuddy'] as List<dynamic>?)
          ?.map((e) => RecommendedBuddy.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ElderToJson(Elder instance) => <String, dynamic>{
      'firebaseUID': instance.firebaseUID,
      'isBlocked': instance.isBlocked,
      'registrationMethod': instance.registrationMethod,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'onLovedOneMode': instance.onLovedOneMode,
      'lovedOne': instance.lovedOne?.toJson(),
      'personalData': instance.personalData.toJson(),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber.toJson(),
      'identityCard': instance.identityCard?.toJson(),
      'elderProfile': instance.elderProfile?.toJson(),
      'recommendedBuddy':
          instance.recommendedBuddy?.map((e) => e.toJson()).toList(),
    };
