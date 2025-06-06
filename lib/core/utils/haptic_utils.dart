import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HapticUtils {
  static const String _prefsVibration = 'vibration_enabled';
  static bool? _vibrationEnabled;
  
  static Future<bool> _isVibrationEnabled() async {
    if (_vibrationEnabled != null) {
      return _vibrationEnabled!;
    }
    
    final prefs = await SharedPreferences.getInstance();
    _vibrationEnabled = prefs.getBool(_prefsVibration) ?? true;
    return _vibrationEnabled!;
  }
  
  static void updateVibrationSetting(bool enabled) {
    _vibrationEnabled = enabled;
  }
  static Future<void> lightImpact() async {
    if (!await _isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 30);
    }
  }

  static Future<void> mediumImpact() async {
    if (!await _isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 50);
    }
  }

  static Future<void> heavyImpact() async {
    if (!await _isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 100);
    }
  }

  static Future<void> selectionClick() async {
    if (!await _isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 10);
    }
  }

  static Future<void> successNotification() async {
    if (!await _isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(pattern: [0, 50, 50, 50]);
    }
  }

  static Future<void> warningNotification() async {
    if (!await _isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(pattern: [0, 100, 100, 100]);
    }
  }

  static Future<void> errorNotification() async {
    if (!await _isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(pattern: [0, 200, 100, 200]);
    }
  }

  static Future<void> shufflePattern() async {
    if (!await _isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(pattern: [0, 50, 100, 50, 100, 50]);
    }
  }
}