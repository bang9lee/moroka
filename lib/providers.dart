// File: lib/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'core/utils/app_logger.dart';
import 'data/repositories/tarot_ai_repository.dart';
import 'data/repositories/ad_repository.dart';
import 'data/repositories/local_storage_repository.dart';
import 'data/repositories/cache_repository.dart';
import 'data/services/gemini_service.dart';
import 'data/services/admob_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/firestore_service.dart';
import 'data/services/cache_service.dart';
import 'data/models/user_model.dart';
import 'data/models/daily_draw_model.dart';
import 'data/models/tarot_spread_model.dart';

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

/// 캐시 서비스 Provider (싱글톤)
final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
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

/// 캐시 리포지토리 Provider
final cacheRepositoryProvider = Provider<CacheRepository>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  return CacheRepository(cacheService);
});

/// Gemini AI 서비스 Provider
final geminiServiceProvider = Provider<GeminiService>((ref) {
  final cacheRepository = ref.watch(cacheRepositoryProvider);
  return GeminiService(cacheRepository: cacheRepository);
});

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

/// 사용자가 선택한 기분 Provider
final userMoodProvider = StateProvider<String?>((ref) => null);

/// 선택된 타로 스프레드 Provider
final selectedSpreadProvider = StateProvider<TarotSpread?>((ref) => null);

/// 채팅 횟수 카운터 Provider (광고 표시용)
final chatTurnCountProvider = StateProvider<int>((ref) {
  AppLogger.debug('Chat turn count initialized');
  return 0;
});

/// 일일 카드 뽑기 데이터 Provider
final dailyDrawDataProvider = StateNotifierProvider<DailyDrawNotifier, AsyncValue<DailyDrawData>>((ref) {
  return DailyDrawNotifier(ref);
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

// ========== Daily Draw Management ==========

/// 일일 카드 뽑기 관리 Notifier
class DailyDrawNotifier extends StateNotifier<AsyncValue<DailyDrawData>> {
  final Ref ref;
  
  DailyDrawNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadData();
  }
  
  Future<void> _loadData() async {
    try {
      final localStorage = ref.read(localStorageRepositoryProvider);
      final data = await localStorage.getDailyDrawData();
      state = AsyncValue.data(data);
      AppLogger.debug('Daily draw data loaded: ${data.totalDrawsRemaining} draws remaining');
    } catch (e, stack) {
      AppLogger.error('Failed to load daily draw data', e, stack);
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// 카드 뽑기 사용
  Future<bool> useCardDraw() async {
    try {
      final currentData = state.value;
      if (currentData == null || currentData.totalDrawsRemaining <= 0) {
        return false;
      }
      
      state = const AsyncValue.loading();
      
      final localStorage = ref.read(localStorageRepositoryProvider);
      final updatedData = await localStorage.useCardDraw();
      
      state = AsyncValue.data(updatedData);
      AppLogger.debug('Card draw used. Remaining: ${updatedData.totalDrawsRemaining}');
      
      return true;
    } catch (e, stack) {
      AppLogger.error('Failed to use card draw', e, stack);
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
  
  /// 광고 시청 후 뽑기 횟수 추가
  Future<void> addAdDraw() async {
    try {
      state = const AsyncValue.loading();
      
      final localStorage = ref.read(localStorageRepositoryProvider);
      final updatedData = await localStorage.addAdDraw();
      
      state = AsyncValue.data(updatedData);
      AppLogger.debug('Ad draw added. Remaining: ${updatedData.totalDrawsRemaining}');
    } catch (e, stack) {
      AppLogger.error('Failed to add ad draw', e, stack);
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// 데이터 새로고침
  Future<void> refresh() async {
    await _loadData();
  }
  
  /// 개발/테스트용 - 무료 횟수 추가
  Future<void> addFreeDrawsForTesting(int draws) async {
    try {
      state = const AsyncValue.loading();
      
      final localStorage = ref.read(localStorageRepositoryProvider);
      final updatedData = await localStorage.addFreeDrawsForTesting(draws);
      
      state = AsyncValue.data(updatedData);
      AppLogger.debug('Test draws added: $draws. Total remaining: ${updatedData.totalDrawsRemaining}');
    } catch (e, stack) {
      AppLogger.error('Failed to add test draws', e, stack);
      state = AsyncValue.error(e, stack);
    }
  }
}