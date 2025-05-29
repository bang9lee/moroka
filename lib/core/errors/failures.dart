abstract class Failure {
  final String message;
  final String? code;
  
  const Failure({
    required this.message,
    this.code,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = '네트워크 연결을 확인해주세요',
    super.code,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = '캐시 오류가 발생했습니다',
    super.code,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });
}

class AIFailure extends Failure {
  const AIFailure({
    super.message = 'AI 응답을 가져올 수 없습니다',
    super.code,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = '알 수 없는 오류가 발생했습니다',
    super.code,
  });
}