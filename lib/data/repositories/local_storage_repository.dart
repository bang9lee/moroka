import 'package:shared_preferences/shared_preferences.dart';

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
  
  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}