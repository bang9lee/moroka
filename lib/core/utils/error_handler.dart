import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../errors/app_exceptions.dart';
import '../../l10n/generated/app_localizations.dart';
import 'app_logger.dart';

/// 에러 처리 및 다국어 메시지 변환 유틸리티
class ErrorHandler {
  /// 예외를 사용자 친화적인 다국어 메시지로 변환
  static String getLocalizedMessage(BuildContext context, dynamic error) {
    final l10n = AppLocalizations.of(context)!;
    
    // AppException 처리
    if (error is AppException) {
      return _getAppExceptionMessage(l10n, error);
    }
    
    // Firebase Auth 예외 처리
    if (error is FirebaseAuthException) {
      return _getFirebaseAuthMessage(l10n, error.code);
    }
    
    // 기타 알려진 예외 처리
    if (error is FormatException) {
      return l10n.errorInvalidFormat;
    }
    
    if (error is TypeError) {
      return l10n.errorUnexpected;
    }
    
    // 알 수 없는 에러
    AppLogger.error('Unhandled error type', error);
    return l10n.errorUnknown;
  }

  /// AppException 에러 코드를 다국어 메시지로 변환
  static String _getAppExceptionMessage(AppLocalizations l10n, AppException error) {
    switch (error.code) {
      // Network errors
      case 'network_timeout':
        return l10n.errorNetworkTimeout;
      case 'no_internet':
        return l10n.errorNoInternet;
      case 'server_error':
        return l10n.errorServerError;
      
      // Auth errors
      case 'invalid_credentials':
        return l10n.errorInvalidCredentials;
      case 'user_not_found':
        return l10n.errorUserNotFound;
      case 'email_not_verified':
        return l10n.errorEmailNotVerified;
      case 'session_expired':
        return l10n.errorSessionExpired;
      
      // API errors
      case 'quota_exceeded':
        return l10n.errorQuotaExceeded;
      case 'invalid_response':
        return l10n.errorInvalidResponse;
      case 'rate_limit_exceeded':
        return l10n.errorRateLimitExceeded;
      
      // Data errors
      case 'data_not_found':
        return l10n.errorDataNotFound;
      case 'data_corrupted':
        return l10n.errorDataCorrupted;
      case 'save_failed':
        return l10n.errorSaveFailed;
      
      // Permission errors
      case 'permission_denied':
        return l10n.errorPermissionDenied;
      case 'permission_restricted':
        return l10n.errorPermissionRestricted;
      
      default:
        return error.message ?? l10n.errorUnknown;
    }
  }

  /// Firebase Auth 에러 코드를 다국어 메시지로 변환
  static String _getFirebaseAuthMessage(AppLocalizations l10n, String code) {
    switch (code) {
      case 'user-not-found':
        return l10n.errorUserNotFound;
      case 'wrong-password':
        return l10n.errorWrongPassword;
      case 'email-already-in-use':
        return l10n.errorEmailAlreadyInUse;
      case 'invalid-email':
        return l10n.errorInvalidEmail;
      case 'weak-password':
        return l10n.errorWeakPassword;
      case 'network-request-failed':
        return l10n.errorNetworkRequestFailed;
      case 'too-many-requests':
        return l10n.errorTooManyRequests;
      case 'user-disabled':
        return l10n.errorUserDisabled;
      case 'operation-not-allowed':
        return l10n.errorOperationNotAllowed;
      default:
        return l10n.errorAuthFailed;
    }
  }

  /// 에러를 로깅하고 다국어 메시지를 반환
  static String handleError(BuildContext context, dynamic error, [StackTrace? stackTrace]) {
    AppLogger.error('Error occurred', error, stackTrace);
    return getLocalizedMessage(context, error);
  }

  /// 스낵바로 에러 메시지 표시
  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getLocalizedMessage(context, error);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// 다이얼로그로 에러 메시지 표시
  static Future<void> showErrorDialog(BuildContext context, dynamic error) async {
    final l10n = AppLocalizations.of(context)!;
    final message = getLocalizedMessage(context, error);
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}