// flutter user model (need to match the node schema)
// lib/models/user_model.dart

class User {
  final String username;
  final String email;
  final String role;
  final String? password; // optional
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.username,
    required this.email,
    required this.role,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  // Convert JSON response from API to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      password: json['password'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Convert User object to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
