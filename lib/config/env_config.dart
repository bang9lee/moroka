import '../core/utils/app_logger.dart';

abstract class EnvConfig {
  // 앱 환경 설정
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );
  
  static const bool isProduction = environment == 'production';
  static const bool isDevelopment = environment == 'development';
  
  // AdMob 광고 ID - 빌드 시 주입
  static String get interstitialAdUnitId {
    if (isDevelopment) {
      // 테스트 광고 ID
      return const String.fromEnvironment(
        'ADMOB_INTERSTITIAL_TEST_ID',
        defaultValue: 'ca-app-pub-3940256099942544/1033173712',
      );
    }
    // 프로덕션 광고 ID
    return const String.fromEnvironment(
      'ADMOB_INTERSTITIAL_ID',
      defaultValue: '', // 빌드 시 실제 ID 주입 필요
    );
  }
  
  static String get rewardedAdUnitId {
    if (isDevelopment) {
      // 테스트 광고 ID
      return const String.fromEnvironment(
        'ADMOB_REWARDED_TEST_ID',
        defaultValue: 'ca-app-pub-3940256099942544/5224354917',
      );
    }
    // 프로덕션 광고 ID
    return const String.fromEnvironment(
      'ADMOB_REWARDED_ID',
      defaultValue: '', // 빌드 시 실제 ID 주입 필요
    );
  }
  
  // Firebase 프로젝트 설정
  static String get firebaseProjectId {
    return const String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: 'your-project-id',
    );
  }
  
  // 기타 환경 변수
  static int get maxFreeDrawsPerDay {
    return const int.fromEnvironment(
      'MAX_FREE_DRAWS',
      defaultValue: 3,
    );
  }
  
  static int get maxAdDrawsPerDay {
    return const int.fromEnvironment(
      'MAX_AD_DRAWS',
      defaultValue: 5,
    );
  }
  
  // 빌드 정보
  static void printConfig() {
    AppLogger.info('=== Environment Configuration ===');
    AppLogger.info('Environment: $environment');
    AppLogger.info('Is Production: $isProduction');
    AppLogger.info('Interstitial Ad ID: ${interstitialAdUnitId.substring(0, 10)}...');
    AppLogger.info('Rewarded Ad ID: ${rewardedAdUnitId.substring(0, 10)}...');
    AppLogger.info('================================');
  }
}