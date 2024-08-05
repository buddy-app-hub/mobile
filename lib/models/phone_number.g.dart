// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_number.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneNumber _$PhoneNumberFromJson(Map<String, dynamic> json) => PhoneNumber(
      number: json['number'] as String,
      countryCode: json['countryCode'] as String,
    );

Map<String, dynamic> _$PhoneNumberToJson(PhoneNumber instance) =>
    <String, dynamic>{
      'number': instance.number,
      'countryCode': instance.countryCode,
    };
