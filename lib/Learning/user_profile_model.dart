class UserProfile2 {
  final String name;
  final String email;
  final String? bio;

  UserProfile2({required this.name, required this.email, this.bio});

  // Convert JSON from API to Dart object
  factory UserProfile2.fromJson(Map<String, dynamic> json) {
    return UserProfile2(
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
    );
  }

  // Convert Dart object to JSON to send to API
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "bio": bio,
    };
  }
}
