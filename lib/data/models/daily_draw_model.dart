import '../../core/constants/app_constants.dart';

class DailyDrawData {
  final DateTime lastResetDate;
  final int freeDrawsRemaining;
  final int adDrawsRemaining;
  final int totalDrawsToday;
  final int adsWatchedToday;

  DailyDrawData({
    required this.lastResetDate,
    this.freeDrawsRemaining = 1,
    this.adDrawsRemaining = 0,
    this.totalDrawsToday = 0,
    this.adsWatchedToday = 0,
  });

  // JSON 직렬화
  Map<String, dynamic> toJson() => {
    'lastResetDate': lastResetDate.toIso8601String(),
    'freeDrawsRemaining': freeDrawsRemaining,
    'adDrawsRemaining': adDrawsRemaining,
    'totalDrawsToday': totalDrawsToday,
    'adsWatchedToday': adsWatchedToday,
  };

  factory DailyDrawData.fromJson(Map<String, dynamic> json) => DailyDrawData(
    lastResetDate: DateTime.parse(json['lastResetDate'] as String),
    freeDrawsRemaining: json['freeDrawsRemaining'] as int? ?? 1,
    adDrawsRemaining: json['adDrawsRemaining'] as int? ?? 0,
    totalDrawsToday: json['totalDrawsToday'] as int? ?? 0,
    adsWatchedToday: json['adsWatchedToday'] as int? ?? 0,
  );

  // 복사 메서드
  DailyDrawData copyWith({
    DateTime? lastResetDate,
    int? freeDrawsRemaining,
    int? adDrawsRemaining,
    int? totalDrawsToday,
    int? adsWatchedToday,
  }) {
    return DailyDrawData(
      lastResetDate: lastResetDate ?? this.lastResetDate,
      freeDrawsRemaining: freeDrawsRemaining ?? this.freeDrawsRemaining,
      adDrawsRemaining: adDrawsRemaining ?? this.adDrawsRemaining,
      totalDrawsToday: totalDrawsToday ?? this.totalDrawsToday,
      adsWatchedToday: adsWatchedToday ?? this.adsWatchedToday,
    );
  }

  // 총 남은 횟수
  int get totalDrawsRemaining => freeDrawsRemaining + adDrawsRemaining;
  
  // 오늘이 리셋이 필요한지 확인
  bool needsReset(DateTime now) {
    final lastReset = DateTime(lastResetDate.year, lastResetDate.month, lastResetDate.day);
    final today = DateTime(now.year, now.month, now.day);
    return today.isAfter(lastReset);
  }
}

// 카드 뽑기 제한 상수
class DrawLimits {
  static const int dailyFreeDraws = AppConstants.dailyFreeDraws;  
  static const int maxAdDraws = AppConstants.maxDrawAdWatchCount;     
  static const int drawsPerAd = AppConstants.drawsPerAd;      
  
  static int get totalMaxDrawsPerDay => dailyFreeDraws + maxAdDraws;
}