import 'package:json_annotation/json_annotation.dart';

part 'identity_card.g.dart';

@JsonSerializable(explicitToJson: true)
class IdentityCard {
  final String number;
  final String country;

  IdentityCard({
    required this.number,
    required this.country,
  });

  factory IdentityCard.fromJson(Map<String, dynamic> json) => _$IdentityCardFromJson(json);
  Map<String, dynamic> toJson() => _$IdentityCardToJson(this);
}
