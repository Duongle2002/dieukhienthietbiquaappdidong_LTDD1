class User {
  final String username;
  final String email;
  final String password;
  final String? userDisplayName;
  final String? role;
  final DateTime? birthday;
  final String gender;
  final String? location;

  User({
    required this.username,
    required this.email,
    required this.password,
    this.userDisplayName,
    this.role,
    this.birthday,
    this.gender = 'other', // mặc định là 'other'
    this.location,
  });

  // Phương thức để chuyển đối tượng User thành JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'userDisplayName': userDisplayName,
      'role': role,
      'birthday': birthday?.toIso8601String(),
      'gender': gender,
      'location': location,
    };
  }

  // Phương thức để tạo đối tượng User từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'], // mật khẩu có thể không cần thiết khi nhận dữ liệu từ API
      userDisplayName: json['userDisplayName'],
      role: json['role'],
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      gender: json['gender'] ?? 'other',
      location: json['location'],
    );
  }
}
