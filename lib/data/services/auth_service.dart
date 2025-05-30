import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/utils/app_logger.dart';

/// Firebase 인증 서비스
/// 이메일/구글 로그인, 회원가입, 프로필 관리 등을 담당합니다.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// 현재 사용자 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  /// 현재 로그인된 사용자
  User? get currentUser => _auth.currentUser;

  /// 이메일 회원가입
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      AppLogger.debug('Attempting email sign up for: $email');
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = credential.user!;
        
        // 표시 이름 업데이트
        if (displayName != null && displayName.isNotEmpty) {
          await user.updateDisplayName(displayName);
          await user.reload();
        }

        // 이메일 인증 메일 발송
        await user.sendEmailVerification();
        
        // Firestore에 사용자 프로필 생성
        final userModel = await createUserProfile(
          uid: user.uid,
          email: email,
          displayName: displayName,
        );

        AppLogger.debug('User signed up successfully: ${user.uid}');
        return userModel;
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Exception during sign up', e);
      throw _handleAuthException(e);
    } catch (e, stack) {
      AppLogger.error('Unexpected error during sign up', e, stack);
      throw Exception('회원가입 중 오류가 발생했습니다.');
    }
  }

  /// 이메일 로그인
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.debug('Attempting email sign in for: $email');
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = credential.user!;
        
        // 이메일 인증 확인
        if (!user.emailVerified) {
          AppLogger.debug('User email not verified: ${user.email}');
          return null; // LoginViewModel에서 처리
        }

        // 사용자 프로필 조회 또는 생성
        final userModel = await getUserProfile(user.uid);
        
        // 마지막 로그인 시간 업데이트
        await _updateLastLoginTime(user.uid);
        
        AppLogger.debug('User signed in successfully: ${user.uid}');
        return userModel;
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Exception during sign in', e);
      throw _handleAuthException(e);
    } catch (e, stack) {
      AppLogger.error('Unexpected error during sign in', e, stack);
      throw Exception('로그인 중 오류가 발생했습니다.');
    }
  }

  /// 구글 로그인
  Future<UserModel?> signInWithGoogle() async {
    try {
      AppLogger.debug('Attempting Google sign in');
      
      // 구글 로그인 플로우 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        AppLogger.debug('Google sign in cancelled by user');
        return null;
      }

      // 인증 정보 획득
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase 인증 자격 증명 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase 로그인
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = userCredential.user!;
        
        // 사용자 프로필 확인 및 생성
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        UserModel userModel;
        
        if (!userDoc.exists) {
          // 신규 사용자 - 프로필 생성
          userModel = await createUserProfile(
            uid: user.uid,
            email: user.email!,
            displayName: user.displayName,
            photoUrl: user.photoURL,
          );
        } else {
          // 기존 사용자 - 마지막 로그인 시간 업데이트
          await _updateLastLoginTime(user.uid);
          userModel = UserModel.fromFirestore(userDoc);
        }

        AppLogger.debug('Google sign in successful: ${user.uid}');
        return userModel;
      }
      
      return null;
    } catch (e, stack) {
      AppLogger.error('Error during Google sign in', e, stack);
      throw Exception('Google 로그인에 실패했습니다.');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      AppLogger.debug('Signing out user');
      
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      
      AppLogger.debug('User signed out successfully');
    } catch (e, stack) {
      AppLogger.error('Error during sign out', e, stack);
      throw Exception('로그아웃 중 오류가 발생했습니다.');
    }
  }

  /// 비밀번호 재설정 이메일 발송
  Future<void> resetPassword(String email) async {
    try {
      AppLogger.debug('Sending password reset email to: $email');
      
      await _auth.sendPasswordResetEmail(email: email);
      
      AppLogger.debug('Password reset email sent successfully');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Exception during password reset', e);
      throw _handleAuthException(e);
    } catch (e, stack) {
      AppLogger.error('Error sending password reset email', e, stack);
      throw Exception('비밀번호 재설정 이메일 발송에 실패했습니다.');
    }
  }

  /// 사용자 프로필 생성
  Future<UserModel> createUserProfile({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      AppLogger.debug('Creating user profile for: $uid');
      
      final userModel = UserModel(
        uid: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        totalReadings: 0,
        hasCompletedOnboarding: false,
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .set(userModel.toFirestore());

      AppLogger.debug('User profile created successfully');
      return userModel;
    } catch (e, stack) {
      AppLogger.error('Error creating user profile', e, stack);
      throw Exception('사용자 프로필 생성에 실패했습니다.');
    }
  }

  /// 사용자 프로필 조회
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      AppLogger.debug('Fetching user profile for: $uid');
      
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      
      // 프로필이 없는 경우 생성 (구글 로그인 등)
      final user = _auth.currentUser;
      if (user != null && user.uid == uid) {
        return await createUserProfile(
          uid: uid,
          email: user.email!,
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );
      }
      
      return null;
    } catch (e, stack) {
      AppLogger.error('Error fetching user profile', e, stack);
      return null;
    }
  }

  /// 사용자 프로필 업데이트
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('로그인된 사용자가 없습니다.');
      }

      AppLogger.debug('Updating user profile: ${user.uid}');

      // Firebase Auth 프로필 업데이트
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Firestore 업데이트
      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['displayName'] = displayName;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;
      if (additionalData != null) updateData.addAll(additionalData);

      if (updateData.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update(updateData);
      }

      AppLogger.debug('User profile updated successfully');
    } catch (e, stack) {
      AppLogger.error('Error updating user profile', e, stack);
      throw Exception('프로필 업데이트에 실패했습니다.');
    }
  }

  /// 온보딩 완료 처리
  Future<void> completeOnboarding() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      AppLogger.debug('Completing onboarding for: ${user.uid}');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'hasCompletedOnboarding': true});

      AppLogger.debug('Onboarding completed successfully');
    } catch (e, stack) {
      AppLogger.error('Error completing onboarding', e, stack);
    }
  }

  /// 마지막 로그인 시간 업데이트
  Future<void> _updateLastLoginTime(String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({
        'lastLoginAt': Timestamp.now(),
      });
    } catch (e, stack) {
      AppLogger.error('Error updating last login time', e, stack);
    }
  }

  /// 사용자 데이터 조회 (providers.dart 호환성을 위한 메서드)
  Future<UserModel?> getUserData(String uid) async {
    return getUserProfile(uid);
  }
  String _handleAuthException(FirebaseAuthException e) {
    AppLogger.debug('Handling auth exception: ${e.code}');
    
    switch (e.code) {
      case 'weak-password':
        return '비밀번호가 너무 약합니다. 6자 이상 입력해주세요.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'invalid-email':
        return '올바르지 않은 이메일 형식입니다.';
      case 'user-not-found':
        return '등록되지 않은 이메일입니다.';
      case 'wrong-password':
        return '비밀번호가 올바르지 않습니다.';
      case 'user-disabled':
        return '비활성화된 계정입니다. 고객센터에 문의해주세요.';
      case 'too-many-requests':
        return '너무 많은 시도가 있었습니다. 잠시 후 다시 시도해주세요.';
      case 'network-request-failed':
        return '네트워크 연결을 확인해주세요.';
      case 'invalid-credential':
        return '이메일 또는 비밀번호가 올바르지 않습니다.';
      case 'operation-not-allowed':
        return '이 로그인 방식은 현재 사용할 수 없습니다.';
      default:
        return '인증 중 오류가 발생했습니다: ${e.message ?? e.code}';
    }
  }
}