/// 앱 전체에서 사용되는 상수값들
class AppConstants {
  // 채팅 관련
  static const int maxChatTurns = 3;           // 최대 채팅 횟수
  static const int maxChatAdWatchCount = 3;    // 채팅용 최대 광고 시청 횟수
  
  // 카드 뽑기 관련
  static const int dailyFreeDraws = 1;         // 일일 무료 뽑기 횟수
  static const int maxDrawAdWatchCount = 10;   // 카드 뽑기용 최대 광고 시청 횟수
  static const int drawsPerAd = 1;             // 광고 1회당 뽑기 횟수
  
  // 저장 제한
  static const int freeUserHistoryLimit = 5;   // 무료 사용자 히스토리 제한
  static const int premiumUserHistoryLimit = 20; // 프리미엄 사용자 히스토리 제한 (추후 적용)
  
  // 애니메이션 관련
  static const Duration quickAnimation = Duration(milliseconds: 200);
  static const Duration defaultAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 600);
  static const Duration longAnimation = Duration(seconds: 1);
  static const Duration veryLongAnimation = Duration(seconds: 3);
  
  // 기타
  static const int maxParticles = 20;          // 배경 파티클 최대 개수
  static const double glassBlur = 10.0;        // 글래스모피즘 블러 강도
  static const double glassBorderWidth = 1.5;  // 글래스모피즘 테두리 두께
}