// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      streetName: json['streetName'] as String,
      streetNumber: (json['streetNumber'] as num?)?.toInt(),
      apartmentNumber: json['apartmentNumber'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'streetName': instance.streetName,
      'streetNumber': instance.streetNumber,
      'apartmentNumber': instance.apartmentNumber,
      'city': instance.city,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'country': instance.country,
    };
