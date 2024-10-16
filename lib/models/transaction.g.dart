// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tx _$TxFromJson(Map<String, dynamic> json) => Tx(
      paymentId: json['payment_id'] as String,
      status: json['status'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      currencyId: json['currency_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TxToJson(Tx instance) => <String, dynamic>{
      'payment_id': instance.paymentId,
      'status': instance.status,
      'type': instance.type,
      'description': instance.description,
      'amount': instance.amount,
      'currency_id': instance.currencyId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
