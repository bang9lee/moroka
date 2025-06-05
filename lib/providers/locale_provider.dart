// File: lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers.dart'; // sharedPreferencesProvider를 위한 import

// 지원 언어 목록
final supportedLocales = [
  const Locale('en'), // 영어
  const Locale('ko'), // 한국어
  const Locale('zh'), // 중국어
  const Locale('ja'), // 일본어
  const Locale('hi'), // 힌디어
  const Locale('pt'), // 포르투갈어
  const Locale('de'), // 독일어
  const Locale('fr'), // 프랑스어
  const Locale('th'), // 태국어
  const Locale('vi'), // 베트남어
  const Locale('es'), // 스페인어
];

// 언어 이름 매핑
final localeNames = {
  'en': 'English',
  'ko': '한국어',
  'zh': '中文',
  'ja': '日本語',
  'hi': 'हिंदी',
  'pt': 'Português',
  'de': 'Deutsch',
  'fr': 'Français',
  'th': 'ไทย',
  'vi': 'Tiếng Việt',
  'es': 'Español',
};

// 현재 로케일 Provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale?> {
  final SharedPreferences _prefs;
  
  LocaleNotifier(this._prefs) : super(null) {
    _loadSavedLocale();
  }
  
  void _loadSavedLocale() {
    final savedLocale = _prefs.getString('app_locale');
    if (savedLocale != null) {
      state = Locale(savedLocale);
    }
  }
  
  Future<void> setLocale(Locale locale) async {
    if (state != locale) {
      state = locale;
      await _prefs.setString('app_locale', locale.languageCode);
    }
  }
  
  Future<void> clearLocale() async {
    state = null;
    await _prefs.remove('app_locale');
  }
}