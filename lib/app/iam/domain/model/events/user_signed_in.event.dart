class UserSignedInEvent {
  final String userId;
  final String username;
  final DateTime occurredOn;

  UserSignedInEvent({
    required this.userId,
    required this.username,
    DateTime? occurredOn,
  }) : occurredOn = occurredOn ?? DateTime.now();
}
