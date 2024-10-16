// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: json['_id'] as String,
      paymentOrderId: json['payment_order_id'] as String,
      connectionId: json['connection_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currencyId: json['currency_id'] as String,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      '_id': instance.id,
      'payment_order_id': instance.paymentOrderId,
      'connection_id': instance.connectionId,
      'amount': instance.amount,
      'currency_id': instance.currencyId,
    };
