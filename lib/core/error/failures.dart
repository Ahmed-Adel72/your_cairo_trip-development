abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Thrown when the API returns field-level validation errors (422 / errors object).
class ValidationFailure extends Failure {
  /// Field-level errors keyed by field name, value is the localised error string.
  /// The map key is the field name (e.g. 'email'), value is the error message
  /// already resolved to the correct language.
  final Map<String, String> fieldErrors;

  /// Raw bilingual errors from the API: {'email': {'ar': [...], 'en': [...]}}
  final Map<String, Map<String, List<String>>> rawErrors;

  const ValidationFailure(
    super.message, {
    this.fieldErrors = const {},
    this.rawErrors = const {},
  });
}
