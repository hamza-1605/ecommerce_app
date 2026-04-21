class AuthUserEntity {
  final int id;
  final String email;
  final String username;
  final String token;

  AuthUserEntity({
    required this.id, 
    required this.email, 
    required this.username, 
    required this.token
  });
}