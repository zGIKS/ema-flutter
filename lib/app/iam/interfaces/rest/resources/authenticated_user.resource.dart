class AuthenticatedUserResource {
  final String accessToken;
  final String userId;
  final String username;

  const AuthenticatedUserResource({
    required this.accessToken,
    required this.userId,
    required this.username,
  });

  factory AuthenticatedUserResource.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUserResource(
      accessToken: (json['access_token'] as String?) ?? '',
      userId: (json['user_id'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
    );
  }
}
