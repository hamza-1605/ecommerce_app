import 'package:ekart/features/auth/domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  AuthUserModel({
    required super.id, 
    required super.email, 
    required super.username, 
    required super.token,
    required super.isAdmin,
  });
  
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id:       json['user']['id'],
      email:    json['user']['email'],
      username: json['user']['username'],
      token:    json['jwt'],     
      isAdmin:  json['user']['isAdmin'] ?? "false",
    );
  }
}