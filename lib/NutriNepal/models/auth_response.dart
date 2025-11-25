import 'user_model.dart';

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String,dynamic> j) => AuthResponse(
    token: j['token'],
    user: User.fromJson(j['user'] ?? j),
  );
}
