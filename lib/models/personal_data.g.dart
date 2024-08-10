// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalData _$PersonalDataFromJson(Map<String, dynamic> json) => PersonalData(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      nationality: json['nationality'] as String?,
      maritalStatus: json['maritalStatus'] as String?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PersonalDataToJson(PersonalData instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'gender': instance.gender,
      'birthDate': instance.birthDate?.toIso8601String(),
      'nationality': instance.nationality,
      'maritalStatus': instance.maritalStatus,
      'address': instance.address?.toJson(),
    };
