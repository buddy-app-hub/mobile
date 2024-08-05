import 'package:json_annotation/json_annotation.dart';

part 'interest.g.dart';

@JsonSerializable(explicitToJson: true)
class Interest {
  final String name;
  
  Interest({
    required this.name,
  });

  factory Interest.fromJson(Map<String, dynamic> json) => _$InterestFromJson(json);
  Map<String, dynamic> toJson() => _$InterestToJson(this);
}
