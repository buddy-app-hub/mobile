// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_handshake.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentHandshake _$PaymentHandshakeFromJson(Map<String, dynamic> json) =>
    PaymentHandshake(
      id: json['id'] as String,
      initPoint: json['init_point'] as String,
      sandboxInitPoint: json['sandbox_init_point'] as String,
      notificationUrl: json['notification_url'] as String,
      backUrls:
          PaymentBackUrls.fromJson(json['back_urls'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentHandshakeToJson(PaymentHandshake instance) =>
    <String, dynamic>{
      'id': instance.id,
      'init_point': instance.initPoint,
      'sandbox_init_point': instance.sandboxInitPoint,
      'notification_url': instance.notificationUrl,
      'back_urls': instance.backUrls.toJson(),
    };
