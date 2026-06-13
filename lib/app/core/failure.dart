sealed class AppFailure {
  final String message;

  const AppFailure(this.message);
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

final class ApiFailure extends AppFailure {
  const ApiFailure(super.message);
}
