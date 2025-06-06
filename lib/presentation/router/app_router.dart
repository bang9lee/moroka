import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/signup/signup_screen.dart';
import '../screens/login/terms/terms_screen.dart';
import '../screens/login/email_verification/email_verification_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/spread_selection/spread_selection_screen.dart';
import '../screens/card_selection/card_selection_screen.dart';
import '../screens/result_chat/result_chat_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/statistics/statistics_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/about/about_screen.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/generated/app_localizations.dart';

/// 앱 라우터 Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter().router;
});

/// 앱 라우터 클래스
class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: _handleRedirect,
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          state: state,
          child: const SplashScreen(),
        ),
      ),
      
      // Onboarding Screen
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      
      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          state: state,
          child: const LoginScreen(),
        ),
        routes: [
          // Sign Up
          GoRoute(
            path: 'signup',
            name: 'signup',
            pageBuilder: (context, state) => _buildPageWithSlideTransition(
              state: state,
              child: const SignUpScreen(),
            ),
          ),
          
          // Terms Agreement
          GoRoute(
            path: 'terms',
            name: 'terms',
            pageBuilder: (context, state) {
              return _buildPageWithSlideTransition(
                state: state,
                child: const TermsScreen(),
              );
            },
          ),
          
          // Email Verification
          GoRoute(
            path: 'email-verification',
            name: 'emailVerification',
            pageBuilder: (context, state) => _buildPageWithSlideTransition(
              state: state,
              child: const EmailVerificationScreen(),
            ),
          ),
        ],
      ),
      
      // Main Screen
      GoRoute(
        path: '/main',
        name: 'main',
        pageBuilder: (context, state) => _buildPageWithSlideUpTransition(
          state: state,
          child: const MainScreen(),
        ),
      ),
      
      // Tarot Reading Flow
      GoRoute(
        path: '/spread-selection',
        name: 'spreadSelection',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          state: state,
          child: const SpreadSelectionScreen(),
        ),
      ),
      
      GoRoute(
        path: '/card-selection',
        name: 'cardSelection',
        pageBuilder: (context, state) => _buildPageWithScaleTransition(
          state: state,
          child: const CardSelectionScreen(),
        ),
      ),
      
      GoRoute(
        path: '/result-chat',
        name: 'resultChat',
        pageBuilder: (context, state) {
          final selectedCards = state.extra as List<int>? ?? [];
          
          return _buildPageWithSlideTransition(
            state: state,
            child: ResultChatScreen(selectedCardIndices: selectedCards),
          );
        },
      ),
      
      // Menu Screens
      GoRoute(
        path: '/history',
        name: 'history',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          state: state,
          child: const HistoryScreen(),
        ),
      ),
      
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          state: state,
          child: const StatisticsScreen(),
        ),
      ),
      
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          state: state,
          child: const SettingsScreen(),
        ),
      ),
      
      GoRoute(
        path: '/about',
        name: 'about',
        pageBuilder: (context, state) => _buildPageWithScaleTransition(
          state: state,
          child: const AboutScreen(),
        ),
      ),
    ],
    
    errorPageBuilder: _buildErrorPage,
  );

  /// 리다이렉트 처리
  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;
    final emailVerified = user?.emailVerified ?? true;
    final location = state.matchedLocation;
    
    AppLogger.debug('Router redirect - Location: $location, LoggedIn: $isLoggedIn, EmailVerified: $emailVerified');
    
    // 스플래시 화면은 항상 접근 가능
    if (location == '/') return null;
    
    // 인증 관련 페이지들
    final authPages = [
      '/login',
      '/login/signup',
      '/login/terms',
      '/login/email-verification',
      '/onboarding',
    ];
    
    final isAuthPage = authPages.contains(location);
    
    // 로그인하지 않은 상태
    if (!isLoggedIn) {
      // 인증 페이지가 아닌 경우 스플래시로
      if (!isAuthPage) {
        AppLogger.debug('Not logged in, redirecting to splash');
        return '/';
      }
      return null;
    }
    
    // 로그인은 했지만 이메일 미인증
    if (!emailVerified && user.providerData.any((info) => info.providerId == 'password')) {
      // 이메일 인증 페이지가 아닌 경우 이메일 인증으로
      if (location != '/login/email-verification') {
        AppLogger.debug('Email not verified, redirecting to verification');
        return '/login/email-verification';
      }
      return null;
    }
    
    // 로그인 상태에서 인증 페이지 접근 시 메인으로
    if (isLoggedIn && emailVerified && isAuthPage) {
      AppLogger.debug('Already logged in, redirecting to main');
      return '/main';
    }
    
    return null;
  }

  /// 페이드 전환 애니메이션
  CustomTransitionPage<void> _buildPageWithFadeTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// 슬라이드 전환 애니메이션
  CustomTransitionPage<void> _buildPageWithSlideTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// 슬라이드 업 전환 애니메이션
  CustomTransitionPage<void> _buildPageWithSlideUpTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// 스케일 전환 애니메이션
  CustomTransitionPage<void> _buildPageWithScaleTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;
        
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return ScaleTransition(
          scale: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// 에러 페이지
  MaterialPage<void> _buildErrorPage(BuildContext context, GoRouterState state) {
    AppLogger.error('Router error', state.error);
    
    return MaterialPage<void>(
      key: state.pageKey,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 80,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)?.errorOccurred ?? 'Page not found',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.error?.toString() ?? AppLocalizations.of(context)?.errorOccurred ?? 'An unknown error occurred',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    icon: const Icon(Icons.home),
                    label: Text(AppLocalizations.of(context)?.skip ?? 'Return Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// GoRouter 새로고침을 위한 스트림 래퍼
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}