import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/app_logger.dart';

final signUpViewModelProvider = StateNotifierProvider<SignUpViewModel, SignUpState>((ref) {
  return SignUpViewModel();
});

class SignUpViewModel extends StateNotifier<SignUpState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  SignUpViewModel() : super(SignUpState());

  void setSignUpInfo({
    required String email,
    required String password,
    required String displayName,
  }) {
    state = state.copyWith(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  void setTermsAccepted({
    required bool serviceTerms,
    required bool privacyPolicy,
    bool? marketing,
  }) {
    state = state.copyWith(
      serviceTermsAccepted: serviceTerms,
      privacyPolicyAccepted: privacyPolicy,
      marketingAccepted: marketing ?? false,
    );
  }

  // 이름 중복 확인
  Future<NameCheckResult> checkNameAvailability(String displayName) async {
    try {
      final trimmedName = displayName.trim();
      
      // 이름 길이 체크
      if (trimmedName.length < 2) {
        return NameCheckResult(
          isAvailable: false,
          message: 'errorNameTooShort',
        );
      }

      // Firestore에서 중복 확인
      final querySnapshot = await _firestore
          .collection('users')
          .where('displayName', isEqualTo: trimmedName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return NameCheckResult(
          isAvailable: true,
          message: 'nameAvailable',
        );
      } else {
        return NameCheckResult(
          isAvailable: false,
          message: 'nameAlreadyTaken',
        );
      }
    } catch (e) {
      AppLogger.error('Error checking name availability', e);
      return NameCheckResult(
        isAvailable: false,
        message: 'errorNameCheckFailed',
      );
    }
  }

  // 이메일 중복 확인
  Future<EmailCheckResult> checkEmailAvailability(String email) async {
    try {
      final trimmedEmail = email.trim().toLowerCase();
      
      // 이메일 형식 체크
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmedEmail)) {
        return EmailCheckResult(
          isAvailable: false,
          message: 'errorEmailInvalid',
        );
      }

      // Firestore에서 중복 확인
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: trimmedEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return EmailCheckResult(
          isAvailable: true,
          message: 'emailAvailable',
        );
      } else {
        return EmailCheckResult(
          isAvailable: false,
          message: 'emailAlreadyRegistered',
        );
      }
    } catch (e) {
      AppLogger.error('Error checking email availability', e);
      return EmailCheckResult(
        isAvailable: false,
        message: 'errorEmailCheckFailed',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = SignUpState();
  }
}

class SignUpState {
  final String? email;
  final String? password;
  final String? displayName;
  final bool serviceTermsAccepted;
  final bool privacyPolicyAccepted;
  final bool marketingAccepted;
  final bool isLoading;
  final String? error;

  SignUpState({
    this.email,
    this.password,
    this.displayName,
    this.serviceTermsAccepted = false,
    this.privacyPolicyAccepted = false,
    this.marketingAccepted = false,
    this.isLoading = false,
    this.error,
  });

  SignUpState copyWith({
    String? email,
    String? password,
    String? displayName,
    bool? serviceTermsAccepted,
    bool? privacyPolicyAccepted,
    bool? marketingAccepted,
    bool? isLoading,
    String? error,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      serviceTermsAccepted: serviceTermsAccepted ?? this.serviceTermsAccepted,
      privacyPolicyAccepted: privacyPolicyAccepted ?? this.privacyPolicyAccepted,
      marketingAccepted: marketingAccepted ?? this.marketingAccepted,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// 이름 중복 확인 결과
class NameCheckResult {
  final bool isAvailable;
  final String message;

  NameCheckResult({
    required this.isAvailable,
    required this.message,
  });
}

// 이메일 중복 확인 결과
class EmailCheckResult {
  final bool isAvailable;
  final String message;

  EmailCheckResult({
    required this.isAvailable,
    required this.message,
  });
}