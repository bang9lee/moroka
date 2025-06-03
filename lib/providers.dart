// File: lib/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'core/utils/app_logger.dart';
import 'data/repositories/tarot_ai_repository.dart';
import 'data/repositories/ad_repository.dart';
import 'data/repositories/local_storage_repository.dart';
import 'data/services/gemini_service.dart';
import 'data/services/admob_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/firestore_service.dart';
import 'data/models/user_model.dart';

/// Dio HTTP 클라이언트 Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  
  // 타임아웃 설정
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  
  // 인터셉터 설정
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
    logPrint: (log) => AppLogger.debug('[DIO] $log'),
  ));
  
  return dio;
});

/// SharedPreferences Provider
/// main.dart에서 override 필요
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main');
});

// ========== Services ==========

/// 인증 서비스 Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Gemini AI 서비스 Provider
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

/// AdMob 서비스 Provider (Singleton)
final admobServiceProvider = Provider<AdmobService>((ref) {
  return AdmobService();
});

/// Firestore 서비스 Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// ========== Repositories ==========

/// 타로 AI 리포지토리 Provider
final tarotAIRepositoryProvider = Provider<TarotAIRepository>((ref) {
  final geminiService = ref.watch(geminiServiceProvider);
  return TarotAIRepository(geminiService);
});

/// 광고 리포지토리 Provider
final adRepositoryProvider = Provider<AdRepository>((ref) {
  final admobService = ref.watch(admobServiceProvider);
  return AdRepository(admobService);
});

/// 로컬 스토리지 리포지토리 Provider
final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LocalStorageRepository(sharedPreferences);
});

// ========== Auth State ==========

/// Firebase 인증 상태 스트림 Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// 현재 사용자 정보 Provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final authService = ref.watch(authServiceProvider);
  
  return authState.when(
    data: (user) async {
      if (user != null) {
        try {
          final userData = await authService.getUserData(user.uid);
          AppLogger.debug('Current user loaded: ${user.uid}');
          return userData;
        } catch (e) {
          AppLogger.error('Failed to load user data', e);
          return null;
        }
      }
      return null;
    },
    loading: () => null,
    error: (error, stack) {
      AppLogger.error('Auth state error', error, stack);
      return null;
    },
  );
});

// ========== App State Providers ==========

/// 첫 실행 여부 Provider
final isFirstLaunchProvider = FutureProvider<bool>((ref) async {
  try {
    final localStorage = ref.watch(localStorageRepositoryProvider);
    final isFirst = await localStorage.isFirstLaunch();
    AppLogger.debug('Is first launch: $isFirst');
    return isFirst;
  } catch (e) {
    AppLogger.error('Failed to check first launch', e);
    return true;
  }
});

/// 선택된 카드 인덱스 Provider
final selectedCardIndexProvider = StateProvider<int?>((ref) => null);

/// 채팅 횟수 카운터 Provider (광고 표시용)
final chatTurnCountProvider = StateProvider<int>((ref) {
  AppLogger.debug('Chat turn count initialized');
  return 0;
});

/// 글로벌 로딩 상태 Provider
final isLoadingProvider = StateProvider<bool>((ref) => false);

/// 앱 설정 Provider
final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier(ref);
});

// ========== App Settings ==========

/// 앱 설정 상태
class AppSettings {
  final bool vibrationEnabled;
  final bool animationsEnabled;
  final bool soundEnabled;
  
  const AppSettings({
    this.vibrationEnabled = true,
    this.animationsEnabled = true,
    this.soundEnabled = true,
  });
  
  AppSettings copyWith({
    bool? vibrationEnabled,
    bool? animationsEnabled,
    bool? soundEnabled,
  }) {
    return AppSettings(
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

/// 앱 설정 상태 관리자
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final Ref ref;
  
  AppSettingsNotifier(this.ref) : super(const AppSettings()) {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      
      state = AppSettings(
        vibrationEnabled: prefs.getBool('vibration_enabled') ?? true,
        animationsEnabled: prefs.getBool('animations_enabled') ?? true,
        soundEnabled: prefs.getBool('sound_enabled') ?? true,
      );
      
      AppLogger.debug('App settings loaded');
    } catch (e) {
      AppLogger.error('Failed to load app settings', e);
    }
  }
  
  Future<void> setVibration(bool enabled) async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool('vibration_enabled', enabled);
      state = state.copyWith(vibrationEnabled: enabled);
      AppLogger.debug('Vibration setting updated: $enabled');
    } catch (e) {
      AppLogger.error('Failed to update vibration setting', e);
    }
  }
  
  Future<void> setAnimations(bool enabled) async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool('animations_enabled', enabled);
      state = state.copyWith(animationsEnabled: enabled);
      AppLogger.debug('Animations setting updated: $enabled');
    } catch (e) {
      AppLogger.error('Failed to update animations setting', e);
    }
  }
  
  Future<void> setSound(bool enabled) async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool('sound_enabled', enabled);
      state = state.copyWith(soundEnabled: enabled);
      AppLogger.debug('Sound setting updated: $enabled');
    } catch (e) {
      AppLogger.error('Failed to update sound setting', e);
    }
  }
}