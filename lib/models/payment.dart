import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Payment {
  @JsonKey(name: '_id')
  final String id;
  final String paymentOrderId;
  final String connectionId;
  final double amount;
  final String currencyId;

  Payment({
    required this.id,
    required this.paymentOrderId,
    required this.connectionId,
    required this.amount,
    required this.currencyId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
