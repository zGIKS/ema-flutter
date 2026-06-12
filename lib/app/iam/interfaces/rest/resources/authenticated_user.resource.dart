class AuthenticatedUserResource {
  final String accessToken;
  final String userId;
  final String username;
  final String role;

  const AuthenticatedUserResource({
    this.accessToken = '',
    required this.userId,
    required this.username,
    this.role = '',
  });

  factory AuthenticatedUserResource.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUserResource(
      accessToken: (json['access_token'] as String?) ?? '',
      userId: (json['user_id'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
      role: (json['role'] as String?) ?? '',
    );
  }
}
