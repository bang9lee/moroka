/// 앱 전체에서 사용되는 커스텀 예외 클래스들
abstract class AppException implements Exception {
  final String code;
  final String? message;
  final dynamic originalError;

  const AppException({
    required this.code,
    this.message,
    this.originalError,
  });

  @override
  String toString() => '$runtimeType: $code${message != null ? ' - $message' : ''}';
}

/// 네트워크 관련 예외
class NetworkException extends AppException {
  const NetworkException({
    required super.code,
    super.message,
    super.originalError,
  });

  factory NetworkException.connectionTimeout() => const NetworkException(
    code: 'network_timeout',
  );

  factory NetworkException.noInternet() => const NetworkException(
    code: 'no_internet',
  );

  factory NetworkException.serverError() => const NetworkException(
    code: 'server_error',
  );
}

/// 인증 관련 예외
class AuthException extends AppException {
  const AuthException({
    required super.code,
    super.message,
    super.originalError,
  });

  factory AuthException.invalidCredentials() => const AuthException(
    code: 'invalid_credentials',
  );

  factory AuthException.userNotFound() => const AuthException(
    code: 'user_not_found',
  );

  factory AuthException.emailNotVerified() => const AuthException(
    code: 'email_not_verified',
  );

  factory AuthException.sessionExpired() => const AuthException(
    code: 'session_expired',
  );
}

/// AI/API 관련 예외
class ApiException extends AppException {
  const ApiException({
    required super.code,
    super.message,
    super.originalError,
  });

  factory ApiException.quotaExceeded() => const ApiException(
    code: 'quota_exceeded',
  );

  factory ApiException.invalidResponse() => const ApiException(
    code: 'invalid_response',
  );

  factory ApiException.rateLimitExceeded() => const ApiException(
    code: 'rate_limit_exceeded',
  );
}

/// 데이터 관련 예외
class DataException extends AppException {
  const DataException({
    required super.code,
    super.message,
    super.originalError,
  });

  factory DataException.notFound() => const DataException(
    code: 'data_not_found',
  );

  factory DataException.corrupted() => const DataException(
    code: 'data_corrupted',
  );

  factory DataException.saveFailed() => const DataException(
    code: 'save_failed',
  );
}

/// 권한 관련 예외
class PermissionException extends AppException {
  const PermissionException({
    required super.code,
    super.message,
    super.originalError,
  });

  factory PermissionException.denied() => const PermissionException(
    code: 'permission_denied',
  );

  factory PermissionException.restricted() => const PermissionException(
    code: 'permission_restricted',
  );
}