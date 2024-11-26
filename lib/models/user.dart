class User {
  final String username;
  final String email;
  final String password; // Mật khẩu có thể không cần khi lấy từ API
  final String? userDisplayName;
  final String? role;
  final DateTime? birthday;
  final String gender;
  final String? location;

  User({
    required this.username,
    required this.email,
    this.password = '', // Giá trị mặc định nếu không cần mật khẩu
    this.userDisplayName,
    this.role,
    this.birthday,
    this.gender = 'other', // Mặc định là 'other' nếu không có giá trị
    this.location,
  });

  /// Phương thức để chuyển đối tượng User thành JSON
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

  /// Phương thức để tạo đối tượng User từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] ?? '', // Gán giá trị mặc định cho password
      userDisplayName: json['userDisplayName'] as String?,
      role: json['role'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'])
          : null, // Nếu birthday null thì trả về null
      gender: json['gender'] ?? 'other', // Gán giá trị mặc định nếu gender null
      location: json['location'] as String?,
    );
  }
}
