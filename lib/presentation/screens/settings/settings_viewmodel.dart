import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:vibration/vibration.dart';

import '../../../core/utils/app_logger.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/repositories/cache_repository.dart';
import '../../../data/services/notification_permission_service.dart';
import '../../../data/models/tarot_reading_model.dart';
import '../../../providers.dart';
import '../../../providers/locale_provider.dart';
import 'settings_state.dart';

final settingsViewModelProvider = 
    StateNotifierProvider<SettingsViewModel, SettingsState>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final cacheRepository = ref.watch(cacheRepositoryProvider);
  return SettingsViewModel(
    firestoreService: firestoreService,
    cacheRepository: cacheRepository,
    ref: ref,
  );
});

class SettingsViewModel extends StateNotifier<SettingsState> {
  final FirestoreService _firestoreService;
  final CacheRepository _cacheRepository;
  final Ref _ref;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  static const String _prefsDailyNotification = 'daily_notification';
  static const String _prefsVibration = 'vibration_enabled';
  static const String _prefsAnimations = 'animations_enabled';
  
  SettingsViewModel({
    required FirestoreService firestoreService,
    required CacheRepository cacheRepository,
    required Ref ref,
  }) : _firestoreService = firestoreService,
       _cacheRepository = cacheRepository,
       _ref = ref,
       super(const SettingsState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      await _initNotifications();
      await _loadSettings();
      await _loadCacheStatistics();
    } catch (e) {
      AppLogger.error('Error initializing settings', e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _initNotifications() async {
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Seoul')); // Adjust based on user location
      
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );
      
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
    } catch (e) {
      AppLogger.error('Failed to initialize notifications', e);
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    AppLogger.debug('Notification tapped: ${response.payload}');
    // Navigate to appropriate screen based on payload
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = FirebaseAuth.instance.currentUser;
      
      state = state.copyWith(
        notificationsEnabled: prefs.getBool(_prefsDailyNotification) ?? false,
        vibrationEnabled: prefs.getBool(_prefsVibration) ?? true,
        animationsEnabled: prefs.getBool(_prefsAnimations) ?? true,
        userEmail: user?.email,
      );
    } catch (e) {
      AppLogger.error('Error loading settings', e);
      _notifyError('errorOccurred');
    }
  }

  Future<void> _loadCacheStatistics() async {
    try {
      final stats = await _cacheRepository.getCacheStatistics();
      state = state.copyWith(cacheStatistics: stats);
    } catch (e) {
      AppLogger.error('Error loading cache statistics', e);
    }
  }

  Future<void> toggleNotifications(bool value) async {
    try {
      if (value && !await _checkNotificationPermission()) {
        _notifyError('notificationPermissionDenied');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsDailyNotification, value);
      
      state = state.copyWith(notificationsEnabled: value);
      
      if (value) {
        await _scheduleDailyNotification();
        _notifySuccess('notificationsEnabled');
      } else {
        await _notifications.cancel(0);
        _notifySuccess('notificationsDisabled');
      }
    } catch (e) {
      AppLogger.error('Error setting notifications', e);
      _notifyError('errorOccurred');
    }
  }

  void toggleVibration(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsVibration, value);
      
      state = state.copyWith(vibrationEnabled: value);
      
      // Update HapticUtils setting
      HapticUtils.updateVibrationSetting(value);
      
      if (value && await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 50);
      }
      
      _notifySuccess(value ? 'vibrationEnabled' : 'vibrationDisabled');
      AppLogger.debug('Vibration ${value ? 'enabled' : 'disabled'}');
    } catch (e) {
      AppLogger.error('Error setting vibration', e);
      _notifyError('errorOccurred');
    }
  }

  void toggleAnimations(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsAnimations, value);
      
      state = state.copyWith(animationsEnabled: value);
      
      _notifySuccess(value ? 'animationsEnabled' : 'animationsDisabled');
      AppLogger.debug('Animations ${value ? 'enabled' : 'disabled'}');
    } catch (e) {
      AppLogger.error('Error setting animations', e);
      _notifyError('errorOccurred');
    }
  }

  void changeLanguage(String languageCode) {
    try {
      _ref.read(localeProvider.notifier).setLocale(Locale(languageCode));
      _notifySuccess('languageChanged');
      AppLogger.debug('Language changed to: $languageCode');
    } catch (e) {
      AppLogger.error('Error changing language', e);
      _notifyError('errorOccurred');
    }
  }

  Future<void> clearCache() async {
    state = state.copyWith(isClearingCache: true);
    
    try {
      await _cacheRepository.clearAllCache();
      
      // Re-save current settings after clearing cache
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsDailyNotification, state.notificationsEnabled);
      await prefs.setBool(_prefsVibration, state.vibrationEnabled);
      await prefs.setBool(_prefsAnimations, state.animationsEnabled);
      
      await _loadCacheStatistics();
      
      _notifySuccess('cacheCleared');
      
      AppLogger.debug('Cache cleared successfully');
    } catch (e) {
      AppLogger.error('Error clearing cache', e);
      _notifyError('errorClearingCache');
    } finally {
      state = state.copyWith(isClearingCache: false);
    }
  }

  Future<void> backupData() async {
    state = state.copyWith(isBackingUp: true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw AuthException.userNotFound();
      }
      
      // Get all user readings in batches
      final List<TarotReadingModel> allReadings = [];
      DocumentSnapshot? lastDoc;
      bool hasMore = true;
      
      while (hasMore) {
        final result = await _firestoreService.getUserReadings(
          userId: user.uid,
          limit: 50,
          lastDocument: lastDoc,
        );
        
        if (result.readings.isEmpty) {
          hasMore = false;
        } else {
          allReadings.addAll(result.readings);
          lastDoc = result.lastDoc;
          if (result.readings.length < 50) {
            hasMore = false;
          }
        }
      }
      
      // Create backup with timestamp
      final backupId = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}';
      await FirebaseFirestore.instance
          .collection('backups')
          .doc(backupId)
          .set({
        'userId': user.uid,
        'userEmail': user.email,
        'backupDate': FieldValue.serverTimestamp(),
        'readingsCount': allReadings.length,
        'appVersion': '1.0.0', // Get from package info
        'platform': Platform.operatingSystem,
        'readings': allReadings.map((r) => r.toFirestore()).toList(),
      });
      
      _notifySuccess('dataBackedUp', 'Data backed up successfully: ${allReadings.length} readings');
      
      AppLogger.debug('Data backed up successfully: $backupId');
    } catch (e) {
      AppLogger.error('Error backing up data', e);
      _notifyError('errorBackingUp');
    } finally {
      state = state.copyWith(isBackingUp: false);
    }
  }

  Future<void> deleteAllData() async {
    state = state.copyWith(isDeletingData: true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw AuthException.userNotFound();
      }
      
      // Get and delete all readings in batches
      int deletedCount = 0;
      DocumentSnapshot? lastDoc;
      bool hasMore = true;
      
      while (hasMore) {
        final result = await _firestoreService.getUserReadings(
          userId: user.uid,
          limit: 50,
          lastDocument: lastDoc,
        );
        
        if (result.readings.isEmpty) {
          hasMore = false;
        } else {
          for (final reading in result.readings) {
            await _firestoreService.deleteReading(reading.id);
            deletedCount++;
          }
          lastDoc = result.lastDoc;
          
          if (result.readings.length < 50) {
            hasMore = false;
          }
        }
      }
      
      // Clear local data
      await clearCache();
      
      _notifySuccess('dataDeleted', 'All data deleted: $deletedCount readings');
      
      AppLogger.debug('All data deleted: $deletedCount readings');
    } catch (e) {
      AppLogger.error('Error deleting all data', e);
      _notifyError('errorDeletingData');
    } finally {
      state = state.copyWith(isDeletingData: false);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isChangingPassword: true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        throw AuthException.userNotFound();
      }
      
      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Validate new password
      if (newPassword.length < 6) {
        throw const AuthException(
          code: 'weak_password',
          message: 'Password must be at least 6 characters',
        );
      }
      
      // Update password
      await user.updatePassword(newPassword);
      
      _notifySuccess('passwordChanged');
      
      AppLogger.debug('Password changed successfully');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'wrongPassword';
          break;
        case 'weak-password':
          errorMessage = 'weakPassword';
          break;
        default:
          errorMessage = 'errorChangingPassword';
      }
      _notifyError(errorMessage);
    } catch (e) {
      AppLogger.error('Error changing password', e);
      _notifyError('errorChangingPassword');
    } finally {
      state = state.copyWith(isChangingPassword: false);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await FirebaseAuth.instance.signOut();
      await _cacheRepository.clearAllCache();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      _notifySuccess('logoutSuccess');
      state = state.copyWith(navigationRoute: '/login');
      
      AppLogger.debug('User logged out successfully');
    } catch (e) {
      AppLogger.error('Error logging out', e);
      _notifyError('errorOccurred');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw AuthException.userNotFound();
      }
      
      // Delete all user data first in batches
      DocumentSnapshot? lastDoc;
      bool hasMore = true;
      
      while (hasMore) {
        final result = await _firestoreService.getUserReadings(
          userId: user.uid,
          limit: 50,
          lastDocument: lastDoc,
        );
        
        if (result.readings.isEmpty) {
          hasMore = false;
        } else {
          for (final reading in result.readings) {
            await _firestoreService.deleteReading(reading.id);
          }
          lastDoc = result.lastDoc;
          
          if (result.readings.length < 50) {
            hasMore = false;
          }
        }
      }
      
      // Delete user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      
      // Delete backups
      final backups = await FirebaseFirestore.instance
          .collection('backups')
          .where('userId', isEqualTo: user.uid)
          .get();
      
      for (final doc in backups.docs) {
        await doc.reference.delete();
      }
      
      // Clear local data
      await _cacheRepository.clearAllCache();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Delete authentication account
      await user.delete();
      
      _notifySuccess('deleteAccountSuccess');
      state = state.copyWith(navigationRoute: '/login');
      
      AppLogger.debug('Account deleted successfully');
    } catch (e) {
      AppLogger.error('Error deleting account', e);
      _notifyError('errorOccurred');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> _checkNotificationPermission() async {
    return await NotificationPermissionService.checkAndRequestPermission();
  }

  Future<void> _scheduleDailyNotification() async {
    
    const androidDetails = AndroidNotificationDetails(
      'daily_tarot',
      'Daily Tarot',
      channelDescription: 'Daily tarot reading notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Schedule for 9 AM every day
    await _notifications.zonedSchedule(
      0,
      'Daily Tarot Reading',
      'Time for your daily tarot insight',
      _nextInstanceOfTime(9, 0),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reading',
    );
  }


  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }


  void _notifySuccess(String messageKey, [String? customMessage]) {
    state = state.copyWith(
      notification: SettingsNotification(
        type: NotificationType.success,
        messageKey: messageKey,
        customMessage: customMessage,
      ),
    );
    // Clear notification after showing
    Future.delayed(const Duration(milliseconds: 100), () {
      state = state.copyWith(clearNotification: true);
    });
  }

  void _notifyError(String messageKey, [String? customMessage]) {
    state = state.copyWith(
      notification: SettingsNotification(
        type: NotificationType.error,
        messageKey: messageKey,
        customMessage: customMessage,
      ),
    );
    // Clear notification after showing
    Future.delayed(const Duration(milliseconds: 100), () {
      state = state.copyWith(clearNotification: true);
    });
  }

}