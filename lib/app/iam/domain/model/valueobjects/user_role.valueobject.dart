enum UserRole {
  user,
  admin;

  String get value => name;

  String get label => switch (this) {
    UserRole.user => 'User',
    UserRole.admin => 'Admin',
  };

  static UserRole fromValue(String value) {
    final normalized = value.trim().toLowerCase();
    for (final role in UserRole.values) {
      if (role.value == normalized) {
        return role;
      }
    }
    throw ArgumentError('Unsupported user role');
  }
}
