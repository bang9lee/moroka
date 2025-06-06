import 'dart:async';
import 'dart:math';
import 'app_logger.dart';
import '../errors/app_exceptions.dart';

/// 재시도 정책 설정
class RetryPolicy {
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final double backoffMultiplier;
  final bool exponentialBackoff;
  final Set<Type> retryableExceptions;

  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
    this.exponentialBackoff = true,
    this.retryableExceptions = const {
      NetworkException,
      TimeoutException,
    },
  });

  /// 기본 정책
  static const RetryPolicy standard = RetryPolicy();

  /// 빠른 재시도 정책 (짧은 지연)
  static const RetryPolicy fast = RetryPolicy(
    maxAttempts: 3,
    initialDelay: Duration(milliseconds: 500),
    maxDelay: Duration(seconds: 5),
  );

  /// 느린 재시도 정책 (긴 지연)
  static const RetryPolicy slow = RetryPolicy(
    maxAttempts: 5,
    initialDelay: Duration(seconds: 2),
    maxDelay: Duration(minutes: 1),
  );

  /// 재시도 없음
  static const RetryPolicy none = RetryPolicy(maxAttempts: 1);
}

/// 재시도 헬퍼 클래스
class RetryHelper {
  /// 재시도 로직이 적용된 함수 실행
  static Future<T> execute<T>({
    required Future<T> Function() operation,
    RetryPolicy policy = RetryPolicy.standard,
    String? operationName,
    Function(int attempt, dynamic error)? onRetry,
  }) async {
    int attempt = 0;
    Duration nextDelay = policy.initialDelay;

    while (attempt < policy.maxAttempts) {
      try {
        attempt++;
        AppLogger.debug('${operationName ?? 'Operation'} attempt $attempt/${policy.maxAttempts}');
        
        return await operation();
      } catch (error, stackTrace) {
        final isLastAttempt = attempt >= policy.maxAttempts;
        final isRetryable = _isRetryable(error, policy);

        if (isLastAttempt || !isRetryable) {
          AppLogger.error(
            '${operationName ?? 'Operation'} failed after $attempt attempts',
            error,
            stackTrace,
          );
          rethrow;
        }

        AppLogger.warning(
          '${operationName ?? 'Operation'} failed (attempt $attempt), retrying in ${nextDelay.inSeconds}s: $error',
        );

        // 재시도 콜백 호출
        onRetry?.call(attempt, error);

        // 지연 후 재시도
        await Future.delayed(nextDelay);

        // 다음 지연 시간 계산
        if (policy.exponentialBackoff) {
          nextDelay = _calculateExponentialDelay(
            policy.initialDelay,
            attempt,
            policy.backoffMultiplier,
            policy.maxDelay,
          );
        }
      }
    }

    // 이론상 도달하지 않는 코드
    throw StateError('Retry logic error');
  }

  /// 스트림에 재시도 로직 적용
  static Stream<T> executeStream<T>({
    required Stream<T> Function() operation,
    RetryPolicy policy = RetryPolicy.standard,
    String? operationName,
  }) {
    return _RetryStream<T>(
      operation: operation,
      policy: policy,
      operationName: operationName,
    ).stream;
  }

  /// 에러가 재시도 가능한지 확인
  static bool _isRetryable(dynamic error, RetryPolicy policy) {
    // 재시도 가능한 예외 타입 확인
    for (final exceptionType in policy.retryableExceptions) {
      if (error.runtimeType == exceptionType) {
        return true;
      }
    }

    // 네트워크 관련 에러 문자열 패턴 확인
    final errorString = error.toString().toLowerCase();
    final retryablePatterns = [
      'timeout',
      'connection',
      'network',
      'socket',
      'temporary',
      'unavailable',
      '503',
      '504',
    ];

    return retryablePatterns.any((pattern) => errorString.contains(pattern));
  }

  /// 지수 백오프 지연 시간 계산
  static Duration _calculateExponentialDelay(
    Duration initialDelay,
    int attempt,
    double multiplier,
    Duration maxDelay,
  ) {
    final exponentialDelay = initialDelay.inMilliseconds * pow(multiplier, attempt - 1);
    final jitteredDelay = exponentialDelay * (0.5 + Random().nextDouble() * 0.5);
    final clampedDelay = min(jitteredDelay, maxDelay.inMilliseconds.toDouble());
    
    return Duration(milliseconds: clampedDelay.toInt());
  }
}

/// 재시도 로직이 적용된 스트림
class _RetryStream<T> {
  final Stream<T> Function() operation;
  final RetryPolicy policy;
  final String? operationName;
  
  late final StreamController<T> _controller;
  StreamSubscription<T>? _subscription;
  int _attempt = 0;

  _RetryStream({
    required this.operation,
    required this.policy,
    this.operationName,
  }) {
    _controller = StreamController<T>(
      onListen: _startListening,
      onCancel: _stopListening,
    );
  }

  Stream<T> get stream => _controller.stream;

  void _startListening() {
    _attemptConnection();
  }

  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _attemptConnection() async {
    if (_attempt >= policy.maxAttempts) {
      _controller.addError(
        const NetworkException(
          code: 'max_retries_exceeded',
          message: 'Maximum retry attempts exceeded',
        ),
      );
      return;
    }

    _attempt++;
    AppLogger.debug('${operationName ?? 'Stream'} attempt $_attempt/${policy.maxAttempts}');

    try {
      final stream = operation();
      _subscription = stream.listen(
        _controller.add,
        onError: (error, stackTrace) async {
          final isRetryable = RetryHelper._isRetryable(error, policy);
          
          if (!isRetryable || _attempt >= policy.maxAttempts) {
            _controller.addError(error, stackTrace);
            return;
          }

          AppLogger.warning(
            '${operationName ?? 'Stream'} error (attempt $_attempt), retrying: $error',
          );

          await _subscription?.cancel();
          
          final delay = RetryHelper._calculateExponentialDelay(
            policy.initialDelay,
            _attempt,
            policy.backoffMultiplier,
            policy.maxDelay,
          );
          
          await Future.delayed(delay);
          _attemptConnection();
        },
        onDone: _controller.close,
      );
    } catch (error, stackTrace) {
      if (_attempt < policy.maxAttempts) {
        final delay = RetryHelper._calculateExponentialDelay(
          policy.initialDelay,
          _attempt,
          policy.backoffMultiplier,
          policy.maxDelay,
        );
        
        await Future.delayed(delay);
        _attemptConnection();
      } else {
        _controller.addError(error, stackTrace);
      }
    }
  }
}