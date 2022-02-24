class User {
  final String userId;
  final String email;
  String? username;
  final List<String> rights;

  User(
      {required this.userId,
      required this.email,
      required this.rights,
      username});
}
