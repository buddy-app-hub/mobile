import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/buddy.dart';

part 'recommended_buddy.g.dart';

@JsonSerializable(explicitToJson: true)
class RecommendedBuddy {
  final Buddy? buddy;
  final int score;
  final int distanceToKM;
  final bool? isDismissed;
  final DateTime? dateDismissed;

  RecommendedBuddy({
    this.buddy,
    required this.score,
    required this.distanceToKM,
    this.isDismissed,
    this.dateDismissed,
  });

  factory RecommendedBuddy.fromJson(Map<String, dynamic> json) => _$RecommendedBuddyFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendedBuddyToJson(this);
}
