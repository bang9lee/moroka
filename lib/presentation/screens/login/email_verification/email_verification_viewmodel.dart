import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/app_logger.dart';

final emailVerificationViewModelProvider = 
    StateNotifierProvider<EmailVerificationViewModel, EmailVerificationState>((ref) {
  return EmailVerificationViewModel();
});

class EmailVerificationViewModel extends StateNotifier<EmailVerificationState> {
  EmailVerificationViewModel() : super(EmailVerificationState()) {
    _initializeUser();
  }

  void _initializeUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      state = state.copyWith(
        userEmail: user.email,
        isVerified: user.emailVerified,
      );
    }
  }

  Future<void> checkEmailVerified() async {
    state = state.copyWith(isChecking: true, error: null);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 사용자 정보 새로고침
        await user.reload();
        
        // 새로고침된 사용자 정보 가져오기
        final refreshedUser = FirebaseAuth.instance.currentUser;
        
        if (refreshedUser != null && refreshedUser.emailVerified) {
          AppLogger.debug('Email verified successfully');
          state = state.copyWith(
            isVerified: true,
            isChecking: false,
          );
        } else {
          state = state.copyWith(isChecking: false);
        }
      }
    } catch (e) {
      AppLogger.error('Error checking email verification', e);
      state = state.copyWith(
        isChecking: false,
        error: 'Error checking email verification.',
      );
    }
  }

  Future<void> resendVerificationEmail() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        
        AppLogger.debug('Verification email resent');
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
        
        // 성공 메시지는 UI에서 처리 (스낵바 등)
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later.';
          break;
        default:
          errorMessage = 'Error sending verification email.';
      }
      
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e) {
      AppLogger.error('Error resending verification email', e);
      state = state.copyWith(
        isLoading: false,
        error: 'Error sending verification email.',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      AppLogger.debug('User signed out from email verification');
    } catch (e) {
      AppLogger.error('Error signing out', e);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class EmailVerificationState {
  final String? userEmail;
  final bool isVerified;
  final bool isChecking;
  final bool isLoading;
  final String? error;

  EmailVerificationState({
    this.userEmail,
    this.isVerified = false,
    this.isChecking = false,
    this.isLoading = false,
    this.error,
  });

  EmailVerificationState copyWith({
    String? userEmail,
    bool? isVerified,
    bool? isChecking,
    bool? isLoading,
    String? error,
  }) {
    return EmailVerificationState(
      userEmail: userEmail ?? this.userEmail,
      isVerified: isVerified ?? this.isVerified,
      isChecking: isChecking ?? this.isChecking,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}