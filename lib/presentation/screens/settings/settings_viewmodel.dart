import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../../core/utils/app_logger.dart';
import '../../../data/services/firestore_service.dart';
import '../../../providers.dart';

final settingsViewModelProvider = 
    StateNotifierProvider<SettingsViewModel, SettingsState>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return SettingsViewModel(firestoreService);
});

class SettingsViewModel extends StateNotifier<SettingsState> {
  final FirestoreService _firestoreService;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  SettingsViewModel(this._firestoreService) : super(SettingsState()) {
    _initNotifications();
    _loadSettings();
  }

  Future<void> _initNotifications() async {
    tz.initializeTimeZones();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(initSettings);
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      state = state.copyWith(
        dailyNotification: prefs.getBool('daily_notification') ?? true,
        weeklyReport: prefs.getBool('weekly_report') ?? false,
        vibrationEnabled: prefs.getBool('vibration_enabled') ?? true,
        animationsEnabled: prefs.getBool('animations_enabled') ?? true,
      );
    } catch (e) {
      AppLogger.error('Error loading settings', e);
    }
  }

  Future<void> setDailyNotification(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('daily_notification', value);
      
      state = state.copyWith(dailyNotification: value);
      
      // Schedule/cancel daily notifications
      if (value) {
        await _scheduleDailyNotification();
        AppLogger.debug('Daily notifications enabled');
      } else {
        await _notifications.cancel(0); // Daily notification ID
        AppLogger.debug('Daily notifications disabled');
      }
    } catch (e) {
      AppLogger.error('Error setting daily notification', e);
    }
  }

  Future<void> setWeeklyReport(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('weekly_report', value);
      
      state = state.copyWith(weeklyReport: value);
      
      // Schedule/cancel weekly reports
      if (value) {
        await _scheduleWeeklyReport();
        AppLogger.debug('Weekly reports enabled');
      } else {
        await _notifications.cancel(1); // Weekly report ID
        AppLogger.debug('Weekly reports disabled');
      }
    } catch (e) {
      AppLogger.error('Error setting weekly report', e);
    }
  }

  Future<void> setVibration(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('vibration_enabled', value);
      
      state = state.copyWith(vibrationEnabled: value);
      AppLogger.debug('Vibration ${value ? 'enabled' : 'disabled'}');
    } catch (e) {
      AppLogger.error('Error setting vibration', e);
    }
  }

  Future<void> setAnimations(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('animations_enabled', value);
      
      state = state.copyWith(animationsEnabled: value);
      AppLogger.debug('Animations ${value ? 'enabled' : 'disabled'}');
    } catch (e) {
      AppLogger.error('Error setting animations', e);
    }
  }

  Future<void> clearCache() async {
    try {
      // Clear SharedPreferences cache
      final prefs = await SharedPreferences.getInstance();
      
      // Preserve settings while clearing other data
      final settings = {
        'daily_notification': state.dailyNotification,
        'weekly_report': state.weeklyReport,
        'vibration_enabled': state.vibrationEnabled,
        'animations_enabled': state.animationsEnabled,
      };
      
      // Clear all preferences
      await prefs.clear();
      
      // Restore settings
      for (final entry in settings.entries) {
        await prefs.setBool(entry.key, entry.value);
      }
      
      AppLogger.debug('Cache cleared successfully');
    } catch (e) {
      AppLogger.error('Error clearing cache', e);
      rethrow;
    }
  }

  Future<void> backupData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');
      
      // Get all user readings
      final readings = await _firestoreService.getUserReadings(
        userId: user.uid,
        limit: 1000, // Get all readings
      );
      
      // Create backup document
      await FirebaseFirestore.instance
          .collection('backups')
          .doc(user.uid)
          .set({
        'userId': user.uid,
        'backupDate': FieldValue.serverTimestamp(),
        'readingsCount': readings.length,
        'readings': readings.map((r) => r.toFirestore()).toList(),
      });
      
      AppLogger.debug('Data backed up successfully');
    } catch (e) {
      AppLogger.error('Error backing up data', e);
      rethrow;
    }
  }

  Future<void> deleteAllData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');
      
      // Delete all readings
      final readings = await _firestoreService.getUserReadings(
        userId: user.uid,
        limit: 1000,
      );
      
      for (final reading in readings) {
        await _firestoreService.deleteReading(reading.id);
      }
      
      // Clear local data
      await clearCache();
      
      AppLogger.debug('All data deleted');
    } catch (e) {
      AppLogger.error('Error deleting all data', e);
      rethrow;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        throw Exception('User not logged in');
      }
      
      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Update password
      await user.updatePassword(newPassword);
      
      AppLogger.debug('Password changed successfully');
    } catch (e) {
      AppLogger.error('Error changing password', e);
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');
      
      // Delete all user data first
      await deleteAllData();
      
      // Delete user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      
      // Delete authentication account
      await user.delete();
      
      AppLogger.debug('Account deleted successfully');
    } catch (e) {
      AppLogger.error('Error deleting account', e);
      rethrow;
    }
  }

  Future<void> _scheduleDailyNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'daily_tarot',
      '일일 타로',
      channelDescription: '매일 아침 타로 운세 알림',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Schedule for 9 AM every day
    await _notifications.zonedSchedule(
      0,
      '오늘의 타로 운세',
      '오늘 하루도 운명의 카드와 함께 시작하세요 ✨',
      _nextInstanceOfNineAM(),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleWeeklyReport() async {
    const androidDetails = AndroidNotificationDetails(
      'weekly_report',
      '주간 타로 리포트',
      channelDescription: '매주 월요일 주간 운세 리포트',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Schedule for Monday 9 AM
    await _notifications.zonedSchedule(
      1,
      '주간 타로 리포트',
      '이번 주 당신의 운명은? 지금 확인해보세요 🔮',
      _nextInstanceOfMondayNineAM(),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _nextInstanceOfNineAM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfMondayNineAM() {
    var scheduledDate = _nextInstanceOfNineAM();
    
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }
}

class SettingsState {
  final bool dailyNotification;
  final bool weeklyReport;
  final bool vibrationEnabled;
  final bool animationsEnabled;

  SettingsState({
    this.dailyNotification = true,
    this.weeklyReport = false,
    this.vibrationEnabled = true,
    this.animationsEnabled = true,
  });

  SettingsState copyWith({
    bool? dailyNotification,
    bool? weeklyReport,
    bool? vibrationEnabled,
    bool? animationsEnabled,
  }) {
    return SettingsState(
      dailyNotification: dailyNotification ?? this.dailyNotification,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }
}