import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, SplashState>((ref) {
  return SplashViewModel();
});

class SplashViewModel extends StateNotifier<SplashState> {
  SplashViewModel() : super(SplashState());

  Future<void> initializeApp() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Simulate app initialization
      await Future.delayed(const Duration(seconds: 2));
      
      // Here you can add:
      // - Check for first launch
      // - Load user preferences
      // - Initialize services
      // - Preload assets
      
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
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