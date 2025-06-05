import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';
import 'core/utils/animation_controller_manager.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'providers.dart';
import 'providers/locale_provider.dart';
import 'presentation/router/app_router.dart';
import 'l10n/generated/app_localizations.dart';
import 'core/utils/app_logger.dart';
import 'data/services/cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 시스템 UI 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.mysticPurple,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // 화면 방향 고정 (세로 모드만)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  try {
    // Firebase 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Firebase App Check 초기화
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );
    
    // Google Mobile Ads 초기화
    await MobileAds.instance.initialize();
    
    // SharedPreferences 초기화
    final sharedPreferences = await SharedPreferences.getInstance();
    
    // Google Fonts 설정
    GoogleFonts.config.allowRuntimeFetching = true;
    
    // AnimationController 매니저 초기화
    AnimationControllerManager().initialize();
    
    // 캐시 서비스 초기화
    await CacheService().initialize();
    
    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MorokaApp(),
      ),
    );
  } catch (e) {
    AppLogger.error('Failed to initialize app', e);
    runApp(const ErrorApp());
  }
}

class MorokaApp extends ConsumerWidget {
  const MorokaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);
    
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        // 텍스트 스케일 팩터 제한 (접근성)
        final mediaQueryData = MediaQuery.of(context);
        final constrainedTextScaler = 
            TextScaler.linear(mediaQueryData.textScaler.scale(1.0).clamp(0.8, 1.3));
        
        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: constrainedTextScaler,
          ),
          child: child!,
        );
      },
    );
  }
}

// 에러 발생 시 표시할 앱
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.deepViolet,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.crimsonGlow,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'errorOccurred',
                style: GoogleFonts.cinzel(
                  color: AppColors.ghostWhite,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'errorOccurred',
                style: GoogleFonts.gowunBatang(
                  color: AppColors.fogGray,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}