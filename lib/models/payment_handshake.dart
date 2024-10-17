import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/payment_back_urls.dart';

part 'payment_handshake.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class PaymentHandshake {
  final String id;
  final String initPoint;
  final String sandboxInitPoint;
  final String notificationUrl;
  final PaymentBackUrls backUrls;

  PaymentHandshake({
    required this.id,
    required this.initPoint,
    required this.sandboxInitPoint,
    required this.notificationUrl,
    required this.backUrls,
  });

  factory PaymentHandshake.fromJson(Map<String, dynamic> json) => _$PaymentHandshakeFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentHandshakeToJson(this);

  
}
