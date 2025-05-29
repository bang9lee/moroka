import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return LoginViewModel(authService);
});

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthService _authService;

  LoginViewModel(this._authService) : super(LoginState());

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      
      if (user != null) {
        state = state.copyWith(
          isLoading: false,
          user: user,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: '로그인에 실패했습니다.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      
      if (user != null) {
        state = state.copyWith(
          isLoading: false,
          user: user,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: '회원가입에 실패했습니다.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _authService.signInWithGoogle();
      
      if (user != null) {
        state = state.copyWith(
          isLoading: false,
          user: user,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Google 로그인에 실패했습니다.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _authService.signOut();
      state = LoginState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class LoginState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  LoginState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  LoginState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}