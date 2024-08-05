import 'buddy.dart';
import 'elder.dart';

class UserData {
  final Buddy? buddy;
  final Elder? elder;
  final bool userWithPendingSignUp;

  UserData({
    this.buddy,
    this.elder,
    this.userWithPendingSignUp = false,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    print(json);
    if (json['userType'] == 'buddy') {
      return UserData(buddy: Buddy.fromJson(json));
    } else if (json['userType'] == 'elder') {
      return UserData(elder: Elder.fromJson(json));
    } else if (json['userType'] == 'userWithPendingSignUp') {
      return UserData(userWithPendingSignUp: true);
    } else {
      throw Exception('Unknown user type');
    }
  }

  Map<String, dynamic> toJson() {
    if (buddy != null) {
      return buddy!.toJson();
    } else if (elder != null) {
      return elder!.toJson();
    } else if (userWithPendingSignUp) {
      return {};
    } else {
      throw Exception('Unknown user type');
    }
  }
}
