import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'presentation/router/app_router.dart';
import 'providers.dart';
import 'core/utils/app_logger.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    AppLogger.debug("1. Flutter binding initialized");
    
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    AppLogger.debug("2. Orientations set");
    
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    
    AppLogger.debug("3. System UI style set");
    
    // Load environment variables
    await dotenv.load(fileName: ".env");
    
    AppLogger.debug("4. Environment loaded - GEMINI_API_KEY: ${dotenv.env['GEMINI_API_KEY']?.substring(0, 10)}...");
    
    // Initialize Firebase
    await Firebase.initializeApp();
    
    AppLogger.debug("5. Firebase initialized");
    
    // Initialize Google Mobile Ads
    await MobileAds.instance.initialize();
    
    AppLogger.debug("6. Ads initialized");
    
    // Initialize SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    
    AppLogger.debug("7. SharedPreferences initialized");
    
    // Preload fonts - 이 부분 제거 또는 true로 변경
    GoogleFonts.config.allowRuntimeFetching = true;
    
    AppLogger.debug("8. Font config set");
    
    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MorokaApp(),
      ),
    );
    
    AppLogger.debug("9. App started");
  } catch (e, stack) {
    AppLogger.error("Error in main", e, stack);
  }
}

class MorokaApp extends ConsumerWidget {
  const MorokaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'Moroka - Ominous Whispers',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}