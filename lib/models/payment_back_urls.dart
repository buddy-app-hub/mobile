import 'package:json_annotation/json_annotation.dart';

part 'payment_back_urls.g.dart';

@JsonSerializable(explicitToJson: true)
class PaymentBackUrls {
  final String success;
  final String pending;
  final String failure;

  PaymentBackUrls({
    required this.success,
    required this.pending,
    required this.failure,
  });

  factory PaymentBackUrls.fromJson(Map<String, dynamic> json) => _$PaymentBackUrlsFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentBackUrlsToJson(this);
}