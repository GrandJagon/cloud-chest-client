class User {
  final String userId;
  final String email;
  String? username;
  final List<dynamic> rights;

  User(
      {required this.userId,
      required this.email,
      required this.rights,
      username});

  factory User.fromJson(Map<String, dynamic> json) => User(
      userId: json['userId'],
      email: json['email'],
      rights: json['rights'],
      username: json['username'] ?? null);
}
