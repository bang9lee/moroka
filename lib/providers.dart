import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'data/repositories/tarot_ai_repository.dart';
import 'data/repositories/ad_repository.dart';
import 'data/repositories/local_storage_repository.dart';
import 'data/services/gemini_service.dart';
import 'data/services/admob_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/firestore_service.dart';
import 'data/models/user_model.dart';

// Services
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
  ));
  return dio;
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main');
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

final admobServiceProvider = Provider<AdmobService>((ref) {
  return AdmobService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Repositories
final tarotAIRepositoryProvider = Provider<TarotAIRepository>((ref) {
  final geminiService = ref.watch(geminiServiceProvider);
  return TarotAIRepository(geminiService);
});

final adRepositoryProvider = Provider<AdRepository>((ref) {
  final admobService = ref.watch(admobServiceProvider);
  return AdRepository(admobService);
});

final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LocalStorageRepository(sharedPreferences);
});

// Auth State
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final authService = ref.watch(authServiceProvider);
  
  return authState.when(
    data: (user) async {
      if (user != null) {
        return await authService.getUserData(user.uid);
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// App State Providers
final isFirstLaunchProvider = FutureProvider<bool>((ref) async {
  final localStorage = ref.watch(localStorageRepositoryProvider);
  return await localStorage.isFirstLaunch();
});

final selectedCardIndexProvider = StateProvider<int?>((ref) => null);

final chatTurnCountProvider = StateProvider<int>((ref) => 0);

final isLoadingProvider = StateProvider<bool>((ref) => false);