import 'package:flutter/services.dart';

/// 입력 유효성 검사 유틸리티 클래스
/// 사용자 입력에 대한 보안 및 유효성 검사를 담당
class InputValidator {
  // 이메일 정규식
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // 비밀번호 정규식 (최소 8자, 대소문자, 숫자, 특수문자 포함)
  static final _strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  // SQL Injection 패턴
  static final _sqlInjectionRegex = RegExp(
    r"('|(--)|;|(\*)|(<)|(>)|(\\)|(\|)|(union)|(select)|(insert)|(update)|(delete)|(drop)|(create)|(alter)|(exec)|(execute))",
    caseSensitive: false,
  );

  // XSS 패턴
  static final _xssRegex = RegExp(
    r'(<script|<iframe|javascript:|onerror=|onload=|onclick=|<img)',
    caseSensitive: false,
  );

  /// 이메일 유효성 검사
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  /// 비밀번호 강도 검사
  static PasswordStrength checkPasswordStrength(String? password) {
    if (password == null || password.isEmpty) {
      return PasswordStrength.empty;
    }

    if (password.length < 6) {
      return PasswordStrength.weak;
    }

    if (password.length < 8) {
      return PasswordStrength.medium;
    }

    if (_strongPasswordRegex.hasMatch(password)) {
      return PasswordStrength.strong;
    }

    // 8자 이상이지만 복잡도가 낮은 경우
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int complexity = 0;
    if (hasLower) complexity++;
    if (hasUpper) complexity++;
    if (hasDigit) complexity++;
    if (hasSpecial) complexity++;

    if (complexity >= 3) {
      return PasswordStrength.medium;
    }

    return PasswordStrength.weak;
  }

  /// 사용자 이름 유효성 검사
  static bool isValidUsername(String? username) {
    if (username == null || username.isEmpty) return false;
    
    // 길이 체크 (3-20자)
    if (username.length < 3 || username.length > 20) return false;
    
    // 영문, 숫자, 언더스코어만 허용
    final validUsernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return validUsernameRegex.hasMatch(username);
  }

  /// 무드(감정) 텍스트 유효성 검사
  static bool isValidMood(String? mood) {
    if (mood == null || mood.isEmpty) return false;
    
    // 길이 제한
    if (mood.length > 50) return false;
    
    // SQL Injection 체크
    if (_sqlInjectionRegex.hasMatch(mood)) return false;
    
    // XSS 체크
    if (_xssRegex.hasMatch(mood)) return false;
    
    return true;
  }

  /// 채팅 메시지 유효성 검사
  static String? validateChatMessage(String? message) {
    if (message == null || message.trim().isEmpty) {
      return '메시지를 입력해주세요.';
    }

    if (message.length > 500) {
      return '메시지는 500자 이내로 입력해주세요.';
    }

    if (_sqlInjectionRegex.hasMatch(message)) {
      return '허용되지 않은 문자가 포함되어 있습니다.';
    }

    if (_xssRegex.hasMatch(message)) {
      return '허용되지 않은 스크립트가 포함되어 있습니다.';
    }

    return null; // 유효한 경우
  }

  /// 텍스트 정화 (위험한 문자 제거)
  static String sanitizeText(String input) {
    // HTML 태그 제거
    String sanitized = input.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // 스크립트 관련 문자열 제거
    sanitized = sanitized.replaceAll(RegExp(r'javascript:', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(RegExp(r'onerror=', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(RegExp(r'onclick=', caseSensitive: false), '');
    
    // SQL 특수문자 이스케이프
    sanitized = sanitized.replaceAll("'", "''");
    
    // 앞뒤 공백 제거
    return sanitized.trim();
  }

  /// 파일 경로 유효성 검사
  static bool isValidFilePath(String? path) {
    if (path == null || path.isEmpty) return false;
    
    // Path traversal 공격 방지
    if (path.contains('..') || path.contains('~')) return false;
    
    // 절대 경로 차단
    if (path.startsWith('/') || path.contains(':')) return false;
    
    return true;
  }

  /// 숫자 입력 유효성 검사
  static bool isValidNumber(String? input, {int? min, int? max}) {
    if (input == null || input.isEmpty) return false;
    
    final number = int.tryParse(input);
    if (number == null) return false;
    
    if (min != null && number < min) return false;
    if (max != null && number > max) return false;
    
    return true;
  }

  /// 신용카드 번호 마스킹
  static String maskCreditCard(String cardNumber) {
    if (cardNumber.length < 12) return cardNumber;
    
    const visibleDigits = 4;
    final maskedLength = cardNumber.length - visibleDigits;
    final masked = '*' * maskedLength + cardNumber.substring(maskedLength);
    
    // 4자리씩 구분
    return masked.replaceAllMapped(
      RegExp(r'.{4}'),
      (match) => '${match.group(0)} ',
    ).trim();
  }

  /// 이메일 마스킹
  static String maskEmail(String email) {
    if (!isValidEmail(email)) return email;
    
    final parts = email.split('@');
    if (parts[0].length <= 3) {
      return '***@${parts[1]}';
    }
    
    final visible = parts[0].substring(0, 3);
    return '$visible***@${parts[1]}';
  }

  /// 전화번호 포맷터
  static TextInputFormatter phoneNumberFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (text.length <= 3) {
        return TextEditingValue(text: text);
      } else if (text.length <= 7) {
        return TextEditingValue(
          text: '${text.substring(0, 3)}-${text.substring(3)}',
        );
      } else if (text.length <= 11) {
        return TextEditingValue(
          text: '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}',
        );
      }
      
      return oldValue;
    });
  }

  /// 금액 포맷터 (천 단위 구분)
  static TextInputFormatter currencyFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (text.isEmpty) return newValue;
      
      final number = int.parse(text);
      final formatted = number.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );
      
      return TextEditingValue(text: formatted);
    });
  }
}

/// 비밀번호 강도 열거형
enum PasswordStrength {
  empty,
  weak,
  medium,
  strong,
}

/// 비밀번호 강도 확장
extension PasswordStrengthExtension on PasswordStrength {
  String get text {
    switch (this) {
      case PasswordStrength.empty:
        return '비밀번호를 입력해주세요';
      case PasswordStrength.weak:
        return '약함';
      case PasswordStrength.medium:
        return '보통';
      case PasswordStrength.strong:
        return '강함';
    }
  }

  double get value {
    switch (this) {
      case PasswordStrength.empty:
        return 0.0;
      case PasswordStrength.weak:
        return 0.33;
      case PasswordStrength.medium:
        return 0.66;
      case PasswordStrength.strong:
        return 1.0;
    }
  }
}