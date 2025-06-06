import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/utils/app_logger.dart';

class NotificationPermissionService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static Future<bool> checkAndRequestPermission() async {
    try {
      if (Platform.isAndroid) {
        // Android 13+ requires explicit notification permission
        if (await _isAndroid13OrHigher()) {
          final status = await Permission.notification.status;
          
          if (status.isDenied) {
            final result = await Permission.notification.request();
            return result.isGranted;
          } else if (status.isPermanentlyDenied) {
            // User has permanently denied, prompt to open settings
            await openAppSettings();
            return false;
          }
          
          return status.isGranted;
        }
        // For Android < 13, notifications are allowed by default
        return true;
      } else if (Platform.isIOS) {
        // iOS requires explicit permission
        final result = await _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        
        return result ?? false;
      }
      
      // Other platforms
      return true;
    } catch (e) {
      AppLogger.error('Error checking notification permission', e);
      return false;
    }
  }
  
  static Future<bool> _isAndroid13OrHigher() async {
    if (!Platform.isAndroid) return false;
    
    try {
      await Permission.notification.status;
      // If the permission exists, it means we're on Android 13+
      return true;
    } catch (e) {
      // Permission doesn't exist on older Android versions
      return false;
    }
  }
  
  static Future<PermissionStatus> getPermissionStatus() async {
    try {
      if (Platform.isAndroid) {
        if (await _isAndroid13OrHigher()) {
          return await Permission.notification.status;
        }
        // For Android < 13, always return granted
        return PermissionStatus.granted;
      } else if (Platform.isIOS) {
        final settings = await _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.checkPermissions();
        
        if (settings?.isEnabled ?? false) {
          return PermissionStatus.granted;
        } else {
          return PermissionStatus.denied;
        }
      }
      
      return PermissionStatus.granted;
    } catch (e) {
      AppLogger.error('Error getting permission status', e);
      return PermissionStatus.denied;
    }
  }
  
  static Future<bool> shouldShowRationale() async {
    if (Platform.isAndroid) {
      return await Permission.notification.shouldShowRequestRationale;
    }
    return false;
  }
}