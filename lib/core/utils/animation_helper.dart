import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimationHelper {
  static const String _prefsAnimations = 'animations_enabled';
  static bool? _animationsEnabled;
  
  static Future<bool> isAnimationEnabled() async {
    if (_animationsEnabled != null) {
      return _animationsEnabled!;
    }
    
    final prefs = await SharedPreferences.getInstance();
    _animationsEnabled = prefs.getBool(_prefsAnimations) ?? true;
    return _animationsEnabled!;
  }
  
  static void updateAnimationSetting(bool enabled) {
    _animationsEnabled = enabled;
  }
  
  static Duration getDuration({
    Duration normal = const Duration(milliseconds: 300),
    Duration disabled = Duration.zero,
  }) {
    if (_animationsEnabled == false) {
      return disabled;
    }
    return normal;
  }
  
  static Future<Duration> getAsyncDuration({
    Duration normal = const Duration(milliseconds: 300),
    Duration disabled = Duration.zero,
  }) async {
    if (!await isAnimationEnabled()) {
      return disabled;
    }
    return normal;
  }
  
  static Curve getCurve({
    Curve normal = Curves.easeInOut,
    Curve disabled = Curves.linear,
  }) {
    if (_animationsEnabled == false) {
      return disabled;
    }
    return normal;
  }
  
  static double getBeginValue({
    double normal = 0.0,
    double disabled = 1.0,
  }) {
    if (_animationsEnabled == false) {
      return disabled;
    }
    return normal;
  }
}