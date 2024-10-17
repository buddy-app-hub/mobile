// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_back_urls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentBackUrls _$PaymentBackUrlsFromJson(Map<String, dynamic> json) =>
    PaymentBackUrls(
      success: json['success'] as String,
      pending: json['pending'] as String,
      failure: json['failure'] as String,
    );

Map<String, dynamic> _$PaymentBackUrlsToJson(PaymentBackUrls instance) =>
    <String, dynamic>{
      'success': instance.success,
      'pending': instance.pending,
      'failure': instance.failure,
    };
