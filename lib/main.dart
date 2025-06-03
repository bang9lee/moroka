// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'presentation/router/app_router.dart';
import 'providers.dart';


/// 앱 진입점
void main() async {
  // 에러 핸들링
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.error('Flutter error', details.exception, details.stack);
  };
  
  try {
    await _initializeApp();
  } catch (e, stack) {
    AppLogger.error("Failed to initialize app", e, stack);
    
    // 초기화 실패 시 에러 화면 표시
    runApp(const _ErrorApp());
  }
}

/// 앱 초기화
Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppLogger.debug("Starting app initialization");
  
  // 1. 화면 방향 설정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  AppLogger.debug("1. Orientations set");
  
  // 2. 시스템 UI 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  AppLogger.debug("2. System UI style set");
  

  
  // 4. Firebase 초기화
  await Firebase.initializeApp();
  AppLogger.debug("4. Firebase initialized");
  
  // 5. Google Mobile Ads 초기화
  await MobileAds.instance.initialize();
  AppLogger.debug("5. Ads initialized");
  
  // 6. SharedPreferences 초기화
  final sharedPreferences = await SharedPreferences.getInstance();
  AppLogger.debug("6. SharedPreferences initialized");
  
  // 7. Google Fonts 설정
  GoogleFonts.config.allowRuntimeFetching = true;
  AppLogger.debug("7. Font config set");
  
  // 8. 앱 실행
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MorokaApp(),
    ),
  );
  
  AppLogger.debug("8. App started successfully");
}

/// 메인 앱 위젯
class MorokaApp extends ConsumerStatefulWidget {
  const MorokaApp({super.key});

  @override
  ConsumerState<MorokaApp> createState() => _MorokaAppState();
}

class _MorokaAppState extends ConsumerState<MorokaApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // AdMob 초기화
    _initializeAds();
  }
  
  Future<void> _initializeAds() async {
    try {
      await ref.read(adRepositoryProvider).initializeAds();
      AppLogger.debug('Ads initialized in app');
    } catch (e) {
      AppLogger.error('Failed to initialize ads', e);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLogger.debug('App lifecycle state changed: $state');
    
    switch (state) {
      case AppLifecycleState.resumed:
        // 앱이 다시 활성화될 때
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
        // 앱이 백그라운드로 갈 때
        _handleAppPaused();
        break;
      case AppLifecycleState.detached:
        // 앱이 종료될 때
        _handleAppDetached();
        break;
      default:
        break;
    }
  }
  
  void _handleAppResumed() {
    AppLogger.debug('App resumed');
    // 광고 재로드
    ref.read(adRepositoryProvider).preloadAds();
  }
  
  void _handleAppPaused() {
    AppLogger.debug('App paused');
    // 필요한 경우 임시 데이터 저장
  }
  
  void _handleAppDetached() {
    AppLogger.debug('App detached');
    // 광고 리소스 정리
    try {
      ref.read(adRepositoryProvider).cleanUp();
    } catch (e) {
      AppLogger.error('Error cleaning up ads on detach', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'Moroka - Ominous Whispers',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder: (context, child) {
        // 글로벌 에러 처리
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return _ErrorScreen(
            error: details.exception.toString(),
          );
        };
        
        return child ?? const SizedBox();
      },
    );
  }
}

/// 에러 앱 - 초기화 실패 시 표시
class _ErrorApp extends StatelessWidget {
  const _ErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
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
                const Text(
                  '앱을 시작할 수 없습니다',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  '잠시 후 다시 시도해주세요',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    // 앱 재시작
                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('앱 종료'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 에러 화면 - 런타임 에러 시 표시
class _ErrorScreen extends StatelessWidget {
  final String error;
  
  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning,
                color: Colors.orange,
                size: 60,
              ),
              const SizedBox(height: 24),
              const Text(
                '오류가 발생했습니다',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}