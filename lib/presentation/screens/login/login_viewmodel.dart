import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../core/utils/app_logger.dart';

/// AuthService Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// LoginViewModel Provider
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return LoginViewModel(authService);
});

/// 로그인 화면의 상태 관리를 담당하는 ViewModel
class LoginViewModel extends StateNotifier<LoginState> {
  final AuthService _authService;

  LoginViewModel(this._authService) : super(LoginState()) {
    // 초기화 시 현재 로그인 상태 확인
    _checkCurrentUser();
  }

  /// 현재 로그인된 사용자 확인
  void _checkCurrentUser() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        AppLogger.debug('Current user found: ${firebaseUser.uid}');
        
        // 이메일 인증 확인
        if (!firebaseUser.emailVerified && firebaseUser.providerData.any((info) => info.providerId == 'password')) {
          AppLogger.debug('User email not verified');
          state = state.copyWith(needsEmailVerification: true);
          return;
        }
        
        // 사용자 프로필 조회
        final userModel = await _authService.getUserProfile(firebaseUser.uid);
        if (userModel != null) {
          state = state.copyWith(user: userModel);
        }
      }
    } catch (e, stack) {
      AppLogger.error('Error checking current user', e, stack);
    }
  }

  /// 이메일로 로그인
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // 유효성 검사
    if (email.trim().isEmpty) {
      state = state.copyWith(error: '이메일을 입력해주세요.');
      return;
    }
    
    if (password.isEmpty) {
      state = state.copyWith(error: '비밀번호를 입력해주세요.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      AppLogger.debug('Attempting email sign in');
      
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // 이메일 인증 확인
        if (!firebaseUser.emailVerified) {
          AppLogger.debug('Email not verified for user: ${firebaseUser.email}');
          
          // 인증 메일 재발송
          await firebaseUser.sendEmailVerification();
          
          state = state.copyWith(
            isLoading: false,
            needsEmailVerification: true,
            error: null,
          );
          return;
        }
        
        // 인증된 사용자 - UserModel 생성
        final user = await _authService.getUserProfile(firebaseUser.uid);
        
        if (user != null) {
          AppLogger.debug('Login successful for user: ${user.uid}');
          
          state = state.copyWith(
            isLoading: false,
            user: user,
            error: null,
          );
        } else {
          throw Exception('사용자 정보를 불러올 수 없습니다.');
        }
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Exception during login', e);
      
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = '등록되지 않은 이메일입니다.';
          break;
        case 'wrong-password':
          errorMessage = '비밀번호가 올바르지 않습니다.';
          break;
        case 'invalid-email':
          errorMessage = '올바르지 않은 이메일 형식입니다.';
          break;
        case 'user-disabled':
          errorMessage = '비활성화된 계정입니다.';
          break;
        case 'too-many-requests':
          errorMessage = '너무 많은 시도가 있었습니다. 잠시 후 다시 시도해주세요.';
          break;
        case 'invalid-credential':
          errorMessage = '이메일 또는 비밀번호가 올바르지 않습니다.';
          break;
        default:
          errorMessage = '로그인 중 오류가 발생했습니다: ${e.message ?? e.code}';
      }
      
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e, stack) {
      AppLogger.error('Unexpected error during login', e, stack);
      
      state = state.copyWith(
        isLoading: false,
        error: '로그인 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
    }
  }

  /// 구글로 로그인
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      AppLogger.debug('Attempting Google sign in');
      
      final user = await _authService.signInWithGoogle();
      
      if (user != null) {
        AppLogger.debug('Google login successful for user: ${user.uid}');
        
        state = state.copyWith(
          isLoading: false,
          user: user,
          error: null,
        );
      } else {
        // 사용자가 로그인 취소
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
      }
    } catch (e, stack) {
      AppLogger.error('Error during Google sign in', e, stack);
      
      state = state.copyWith(
        isLoading: false,
        error: 'Google 로그인에 실패했습니다. 다시 시도해주세요.',
      );
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      AppLogger.debug('Attempting sign out');
      
      await _authService.signOut();
      
      AppLogger.debug('Sign out successful');
      
      // 상태 초기화
      state = LoginState();
    } catch (e, stack) {
      AppLogger.error('Error during sign out', e, stack);
      
      state = state.copyWith(
        isLoading: false,
        error: '로그아웃 중 오류가 발생했습니다.',
      );
    }
  }

  /// 비밀번호 재설정 이메일 발송
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty) {
      state = state.copyWith(error: '이메일을 입력해주세요.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      AppLogger.debug('Sending password reset email to: $email');
      
      await _authService.resetPassword(email.trim());
      
      state = state.copyWith(
        isLoading: false,
        passwordResetSent: true,
        error: null,
      );
    } catch (e, stack) {
      AppLogger.error('Error sending password reset email', e, stack);
      
      state = state.copyWith(
        isLoading: false,
        error: '비밀번호 재설정 이메일 발송에 실패했습니다.',
      );
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 비밀번호 재설정 상태 초기화
  void clearPasswordResetStatus() {
    state = state.copyWith(passwordResetSent: false);
  }

  /// 상태 초기화
  void reset() {
    state = LoginState();
  }
}

/// 로그인 화면의 상태
class LoginState {
  final bool isLoading;
  final UserModel? user;
  final String? error;
  final bool needsEmailVerification;
  final bool passwordResetSent;

  LoginState({
    this.isLoading = false,
    this.user,
    this.error,
    this.needsEmailVerification = false,
    this.passwordResetSent = false,
  });

  LoginState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
    bool? needsEmailVerification,
    bool? passwordResetSent,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      needsEmailVerification: needsEmailVerification ?? this.needsEmailVerification,
      passwordResetSent: passwordResetSent ?? this.passwordResetSent,
    );
  }

  @override
  String toString() {
    return 'LoginState(isLoading: $isLoading, user: ${user?.uid}, '
        'needsEmailVerification: $needsEmailVerification, '
        'passwordResetSent: $passwordResetSent, '
        'error: $error)';
  }
}