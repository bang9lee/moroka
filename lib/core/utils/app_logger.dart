import 'package:flutter/foundation.dart';

class AppLogger {
  static const String _prefix = '[MOROKA]';
  
  static void debug(String message, [dynamic data]) {
    if (kDebugMode) {
      print('$_prefix [DEBUG] $message');
      if (data != null) {
        print('$_prefix [DATA] $data');
      }
    }
  }
  
  static void info(String message, [dynamic data]) {
    if (kDebugMode) {
      print('$_prefix [INFO] $message');
      if (data != null) {
        print('$_prefix [DATA] $data');
      }
    }
  }
  
  static void warning(String message, [dynamic data]) {
    if (kDebugMode) {
      print('$_prefix [WARNING] $message');
      if (data != null) {
        print('$_prefix [DATA] $data');
      }
    }
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('$_prefix [ERROR] $message');
      if (error != null) {
        print('$_prefix [ERROR DETAIL] $error');
      }
      if (stackTrace != null) {
        print('$_prefix [STACK TRACE] $stackTrace');
      }
    }
  }
  
  static void api(String endpoint, {
    String? method,
    dynamic request,
    dynamic response,
    int? statusCode,
  }) {
    if (kDebugMode) {
      print('$_prefix [API] ${method ?? 'GET'} $endpoint');
      if (request != null) {
        print('$_prefix [API REQUEST] $request');
      }
      if (response != null) {
        print('$_prefix [API RESPONSE] $response');
      }
      if (statusCode != null) {
        print('$_prefix [API STATUS] $statusCode');
      }
    }
  }
}