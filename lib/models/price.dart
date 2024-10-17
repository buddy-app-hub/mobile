import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'price.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Price {
  final double amount;
  final String currencyId;

  Price({
    required this.amount,
    required this.currencyId,
  });

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
  Map<String, dynamic> toJson() => _$PriceToJson(this);
}
