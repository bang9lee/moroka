import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../providers.dart';

final termsViewModelProvider = StateNotifierProvider<TermsViewModel, TermsState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return TermsViewModel(authService);
});

class TermsViewModel extends StateNotifier<TermsState> {
  final AuthService _authService;

  TermsViewModel(this._authService) : super(TermsState());

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Firebase 회원가입
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user != null) {
        // 사용자 이름 업데이트
        await user.updateDisplayName(displayName);
        
        // 이메일 인증 메일 발송
        await user.sendEmailVerification();
        
        // Firestore에 사용자 정보 저장
        await _authService.createUserProfile(
          uid: user.uid,
          email: email,
          displayName: displayName,
        );
        
        state = state.copyWith(
          isLoading: false,
          isSignUpComplete: true,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = '비밀번호가 너무 약합니다.';
          break;
        case 'email-already-in-use':
          errorMessage = '이미 사용 중인 이메일입니다.';
          break;
        case 'invalid-email':
          errorMessage = '올바르지 않은 이메일 형식입니다.';
          break;
        default:
          errorMessage = '회원가입 중 오류가 발생했습니다: ${e.message}';
      }
      
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '회원가입 중 오류가 발생했습니다: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class TermsState {
  final bool isLoading;
  final bool isSignUpComplete;
  final String? error;

  TermsState({
    this.isLoading = false,
    this.isSignUpComplete = false,
    this.error,
  });

  TermsState copyWith({
    bool? isLoading,
    bool? isSignUpComplete,
    String? error,
  }) {
    return TermsState(
      isLoading: isLoading ?? this.isLoading,
      isSignUpComplete: isSignUpComplete ?? this.isSignUpComplete,
      error: error,
    );
  }
}