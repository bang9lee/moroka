import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/daily_draw_model.dart';

class LocalStorageRepository {
  final SharedPreferences _prefs;
  
  LocalStorageRepository(this._prefs);
  
  // Keys
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyLastReadingDate = 'last_reading_date';
  static const String _keyDailyReadingCount = 'daily_reading_count';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyVibrationEnabled = 'vibration_enabled';
  static const String _keyDailyDrawData = 'daily_draw_data';
  
  // First launch
  Future<bool> isFirstLaunch() async {
    return _prefs.getBool(_keyFirstLaunch) ?? true;
  }
  
  Future<void> setFirstLaunchComplete() async {
    await _prefs.setBool(_keyFirstLaunch, false);
  }
  
  // Onboarding
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }
  
  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_keyOnboardingCompleted, true);
  }
  
  // Daily reading tracking
  Future<int> getDailyReadingCount() async {
    final lastDate = _prefs.getString(_keyLastReadingDate);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    
    if (lastDate != today) {
      // Reset count for new day
      await _prefs.setString(_keyLastReadingDate, today);
      await _prefs.setInt(_keyDailyReadingCount, 0);
      return 0;
    }
    
    return _prefs.getInt(_keyDailyReadingCount) ?? 0;
  }
  
  Future<void> incrementDailyReadingCount() async {
    final currentCount = await getDailyReadingCount();
    await _prefs.setInt(_keyDailyReadingCount, currentCount + 1);
  }
  
  // Settings
  Future<bool> isSoundEnabled() async {
    return _prefs.getBool(_keySoundEnabled) ?? true;
  }
  
  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_keySoundEnabled, enabled);
  }
  
  Future<bool> isVibrationEnabled() async {
    return _prefs.getBool(_keyVibrationEnabled) ?? true;
  }
  
  Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs.setBool(_keyVibrationEnabled, enabled);
  }
  
  // Daily Draw Management
  Future<DailyDrawData> getDailyDrawData() async {
    final jsonString = _prefs.getString(_keyDailyDrawData);
    if (jsonString == null) {
      // 처음이면 기본값 반환
      final defaultData = DailyDrawData(
        lastResetDate: DateTime.now(),
        freeDrawsRemaining: DrawLimits.dailyFreeDraws,
      );
      await saveDailyDrawData(defaultData);
      return defaultData;
    }
    
    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      var data = DailyDrawData.fromJson(jsonMap);
      
      // 날짜가 바뀌었으면 리셋
      if (data.needsReset(DateTime.now())) {
        data = DailyDrawData(
          lastResetDate: DateTime.now(),
          freeDrawsRemaining: DrawLimits.dailyFreeDraws,
          adDrawsRemaining: 0,
          totalDrawsToday: 0,
          adsWatchedToday: 0,
        );
        await saveDailyDrawData(data);
      }
      
      return data;
    } catch (e) {
      // 파싱 실패시 기본값
      final defaultData = DailyDrawData(
        lastResetDate: DateTime.now(),
        freeDrawsRemaining: DrawLimits.dailyFreeDraws,
      );
      await saveDailyDrawData(defaultData);
      return defaultData;
    }
  }
  
  Future<void> saveDailyDrawData(DailyDrawData data) async {
    final jsonString = json.encode(data.toJson());
    await _prefs.setString(_keyDailyDrawData, jsonString);
  }
  
  // 카드 뽑기 사용
  Future<DailyDrawData> useCardDraw() async {
    var data = await getDailyDrawData();
    
    if (data.freeDrawsRemaining > 0) {
      // 무료 뽑기 사용
      data = data.copyWith(
        freeDrawsRemaining: data.freeDrawsRemaining - 1,
        totalDrawsToday: data.totalDrawsToday + 1,
      );
    } else if (data.adDrawsRemaining > 0) {
      // 광고 뽑기 사용
      data = data.copyWith(
        adDrawsRemaining: data.adDrawsRemaining - 1,
        totalDrawsToday: data.totalDrawsToday + 1,
      );
    }
    
    await saveDailyDrawData(data);
    return data;
  }
  
  // 광고 시청 후 뽑기 횟수 추가
  Future<DailyDrawData> addAdDraw() async {
    var data = await getDailyDrawData();
    
    // 오늘 광고 시청 횟수가 최대치 미만인 경우만
    if (data.adsWatchedToday < DrawLimits.maxAdDraws) {
      data = data.copyWith(
        adDrawsRemaining: data.adDrawsRemaining + DrawLimits.drawsPerAd,
        adsWatchedToday: data.adsWatchedToday + 1,
      );
      await saveDailyDrawData(data);
    }
    
    return data;
  }
  
  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}