class UserProfile {
  final String username;
  final String email;
  final String userDisplayName;
  final String gender;
  final String? location;
  final DateTime? birthday;

  UserProfile({
    required this.username,
    required this.email,
    required this.userDisplayName,
    required this.gender,
    this.location,
    this.birthday,
  });

  // Phương thức chuyển đổi UserProfile từ JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      email: json['email'],
      userDisplayName: json['userDisplayName'],
      gender: json['gender'],
      location: json['location'],
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
    );
  }

  // Phương thức chuyển đổi UserProfile thành JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'userDisplayName': userDisplayName,
      'gender': gender,
      'location': location,
      'birthday': birthday?.toIso8601String(),
    };
  }
}
