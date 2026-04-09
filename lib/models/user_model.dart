class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'student', 'teacher', 'principal'
  final String password;
  final Map<String, dynamic> extraData;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.password,
    this.extraData = const {},
  });
}
