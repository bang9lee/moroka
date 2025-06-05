import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/cache_repository.dart';
import '../../../providers.dart';
import '../../../core/utils/app_logger.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, SplashState>((ref) {
  final cacheRepository = ref.watch(cacheRepositoryProvider);
  return SplashViewModel(cacheRepository);
});

class SplashViewModel extends StateNotifier<SplashState> {
  final CacheRepository _cacheRepository;
  
  SplashViewModel(this._cacheRepository) : super(SplashState());

  Future<void> initializeApp() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Initialize app with proper progress tracking
      await Future.wait([
        _initializeCache(),
        _minimumSplashDuration(),
      ]);
      
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
      );
    } catch (e) {
      AppLogger.error('Failed to initialize app', e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  Future<void> _initializeCache() async {
    try {
      // Preload essential data
      await _cacheRepository.preloadEssentialData();
      AppLogger.info('Cache preloaded successfully');
    } catch (e) {
      AppLogger.error('Failed to preload cache', e);
      // Don't throw - cache preload failure shouldn't prevent app launch
    }
  }
  
  Future<void> _minimumSplashDuration() async {
    // Ensure splash screen shows for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));
  }

  void completeInitialization() {
    state = state.copyWith(isInitialized: true);
  }
}

class SplashState {
  final bool isLoading;
  final bool isInitialized;
  final String? error;

  SplashState({
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
  });

  SplashState copyWith({
    bool? isLoading,
    bool? isInitialized,
    String? error,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error ?? this.error,
    );
  }
}