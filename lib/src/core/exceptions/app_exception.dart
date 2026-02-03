/// Base class for all application-specific exceptions.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.details});
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code, super.details});
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.details});
}

/// Exception thrown when a user is not authorized to perform an action.
///
/// This usually occurs when a user is not logged in or doesn't have the
/// necessary permissions.
class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.code, super.details});
}

/// Exception thrown when an operation times out.
class TimeoutException extends AppException {
  const TimeoutException(super.message, {super.code, super.details});
}
