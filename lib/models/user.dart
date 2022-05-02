import 'package:cloud_chest/models/factories/right_factory.dart';
import 'package:cloud_chest/models/right.dart';

class User {
  final String userId;
  final String email;
  String? username;
  List<Right> rights;

  User(
      {required this.userId,
      required this.email,
      required this.rights,
      this.username});

  factory User.fromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] ?? json['_id'],
      email: json['email'],
      rights:
          json['rights'] != null ? RightFactory.fromArray(json['rights']) : [],
      username: json['username'] != ''
                ? json['username']
                : null
                );

  // Takes a list of user in json format and returns a list of user objects
  static List<User> fromArray(List<dynamic> jsonArray) {
    List<User> userArray = [];

    jsonArray.forEach((json) {
      userArray.add(User.fromJson(json));
    });

    return userArray;
  }

  // Takes a list of string and uses it to create new rights objects
  void updateRights(List<String> newRights) {
    rights = RightFactory.fromArray(newRights);
    print('rights are now ' + rights.toString());
  }

  // Check within the right array if a user has a right of certain type
  bool hasRight(Type right) {
    for (Right r in rights) {
      if (r.runtimeType == right) return true;
    }
    return false;
  }

  // Returns an array of the user rights string value
  List<String> getRightValues() {
    return rights.map((right) => right.value).toList();
  }

  // Makes a deep copy of a specific user in order to change its rights before validating it
  User.clone(User user)
      : this(
            username: user.username,
            email: user.email,
            userId: user.userId,
            rights: user.rights);

  @override
  String toString() {
    return 'ID : ' +
        userId +
        ' Email : ' +
        email +
        ' Username : ' +
        (username ?? '') +
        ' Rights : ' +
        rights.toString();
  }
}
