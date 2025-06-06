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
          errorMessage = 'Password is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        default:
          errorMessage = 'An error occurred during sign up: ${e.message}';
      }
      
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred during sign up: $e',
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