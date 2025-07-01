class Profile {
  final int id;
  final String username;
  final String email;
  final String phone;
  final bool isEmployee;
  final bool isAdmin;

  const Profile({
        required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.isEmployee,
    required this.isAdmin
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['name'] as String,
      phone: json['phone'] ?? "",
      isEmployee: json['is_employee'] == 1,
      isAdmin: json['is_admin'] == 1
    );
  }
}