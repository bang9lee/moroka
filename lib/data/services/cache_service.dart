import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_interpretation_model.dart';
import '../models/tarot_reading_model.dart';
import '../../core/utils/app_logger.dart';

class CacheService {
  static const String _aiInterpretationBox = 'ai_interpretations';
  static const String _readingHistoryBox = 'reading_history';
  static const String _cacheMetadataBox = 'cache_metadata';
  
  // Cache expiration durations
  static const Duration _aiInterpretationExpiry = Duration(days: 7);
  static const Duration _imageExpiry = Duration(days: 30);
  
  // Singleton instance
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  // Hive boxes
  late Box<Map> _aiInterpretationCache;
  late Box<Map> _readingHistoryCache;
  late Box<Map> _cacheMetadata;
  
  // Image cache manager
  late DefaultCacheManager _imageCacheManager;
  
  // SharedPreferences for simple key-value storage
  late SharedPreferences _prefs;
  
  bool _isInitialized = false;

  /// Initialize the cache service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize Hive
      await Hive.initFlutter();
      
      // Open Hive boxes
      _aiInterpretationCache = await Hive.openBox<Map>(_aiInterpretationBox);
      _readingHistoryCache = await Hive.openBox<Map>(_readingHistoryBox);
      _cacheMetadata = await Hive.openBox<Map>(_cacheMetadataBox);
      
      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();
      
      // Configure custom image cache manager
      _imageCacheManager = DefaultCacheManager();
      
      // Clean expired cache on startup
      await _cleanExpiredCache();
      
      _isInitialized = true;
      AppLogger.debug('CacheService initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize CacheService', e);
      rethrow;
    }
  }

  /// Cache AI interpretation
  Future<void> cacheAIInterpretation({
    required String key,
    required AIInterpretationModel interpretation,
  }) async {
    try {
      final cacheData = {
        'data': interpretation.toMap(),
        'cachedAt': DateTime.now().toIso8601String(),
        'expiresAt': DateTime.now().add(_aiInterpretationExpiry).toIso8601String(),
      };
      
      await _aiInterpretationCache.put(key, cacheData);
      AppLogger.debug('Cached AI interpretation for key: $key');
    } catch (e) {
      AppLogger.error('Failed to cache AI interpretation', e);
    }
  }

  /// Get cached AI interpretation
  Future<AIInterpretationModel?> getCachedAIInterpretation(String key) async {
    try {
      final cachedData = _aiInterpretationCache.get(key);
      if (cachedData == null) return null;
      
      final expiresAt = DateTime.parse(cachedData['expiresAt'] as String);
      
      // Check if cache has expired
      if (DateTime.now().isAfter(expiresAt)) {
        await _aiInterpretationCache.delete(key);
        AppLogger.debug('Expired AI interpretation cache removed for key: $key');
        return null;
      }
      
      final data = Map<String, dynamic>.from(cachedData['data'] as Map);
      return AIInterpretationModel.fromMap(data);
    } catch (e) {
      AppLogger.error('Failed to get cached AI interpretation', e);
      return null;
    }
  }

  /// Cache reading history
  Future<void> cacheReadingHistory({
    required String userId,
    required List<TarotReadingModel> readings,
  }) async {
    try {
      final readingMaps = readings.map((r) => {
        'id': r.id,
        'data': r.toMap(),
      }).toList();
      await _readingHistoryCache.put(userId, {
        'readings': readingMaps,
        'cachedAt': DateTime.now().toIso8601String(),
      });
      AppLogger.debug('Cached reading history for user: $userId');
    } catch (e) {
      AppLogger.error('Failed to cache reading history', e);
    }
  }

  /// Get cached reading history
  Future<List<TarotReadingModel>?> getCachedReadingHistory(String userId) async {
    try {
      final cachedData = _readingHistoryCache.get(userId);
      if (cachedData == null) return null;
      
      final readingsList = cachedData['readings'] as List;
      return readingsList.map((reading) {
        final id = reading['id'] as String;
        final data = Map<String, dynamic>.from(reading['data'] as Map);
        return TarotReadingModel.fromMap(data, id);
      }).toList();
    } catch (e) {
      AppLogger.error('Failed to get cached reading history', e);
      return null;
    }
  }

  /// Cache tarot card image
  Future<void> cacheCardImage({
    required String imageUrl,
    required String cardId,
  }) async {
    try {
      await _imageCacheManager.downloadFile(
        imageUrl,
        key: 'tarot_card_$cardId',
      );
      
      // Store metadata
      await _cacheMetadata.put('image_$cardId', {
        'url': imageUrl,
        'cachedAt': DateTime.now().toIso8601String(),
        'expiresAt': DateTime.now().add(_imageExpiry).toIso8601String(),
      });
      
      AppLogger.debug('Cached image for card: $cardId');
    } catch (e) {
      AppLogger.error('Failed to cache card image', e);
    }
  }

  /// Get cached card image file
  Future<FileInfo?> getCachedCardImage(String cardId) async {
    try {
      final metadata = _cacheMetadata.get('image_$cardId');
      if (metadata == null) return null;
      
      final expiresAt = DateTime.parse(metadata['expiresAt'] as String);
      
      // Check if cache has expired
      if (DateTime.now().isAfter(expiresAt)) {
        await _imageCacheManager.removeFile('tarot_card_$cardId');
        await _cacheMetadata.delete('image_$cardId');
        AppLogger.debug('Expired image cache removed for card: $cardId');
        return null;
      }
      
      return await _imageCacheManager.getFileFromCache('tarot_card_$cardId');
    } catch (e) {
      AppLogger.error('Failed to get cached card image', e);
      return null;
    }
  }

  /// Preload all tarot card images
  Future<void> preloadAllCardImages(List<String> imageAssetPaths) async {
    try {
      for (final path in imageAssetPaths) {
        // For asset images, we'll use the path as the key
        final cardId = path.split('/').last.replaceAll('.png', '');
        await _cacheMetadata.put('asset_image_$cardId', {
          'path': path,
          'cachedAt': DateTime.now().toIso8601String(),
          'type': 'asset',
        });
      }
      AppLogger.debug('Preloaded ${imageAssetPaths.length} card images');
    } catch (e) {
      AppLogger.error('Failed to preload card images', e);
    }
  }

  /// Save user preferences
  Future<void> saveUserPreference(String key, dynamic value) async {
    try {
      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(key, value);
      } else {
        // For complex objects, convert to JSON
        await _prefs.setString(key, jsonEncode(value));
      }
    } catch (e) {
      AppLogger.error('Failed to save user preference', e);
    }
  }

  /// Get user preference
  dynamic getUserPreference(String key, {dynamic defaultValue}) {
    try {
      return _prefs.get(key) ?? defaultValue;
    } catch (e) {
      AppLogger.error('Failed to get user preference', e);
      return defaultValue;
    }
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    try {
      await _aiInterpretationCache.clear();
      await _readingHistoryCache.clear();
      await _cacheMetadata.clear();
      await _imageCacheManager.emptyCache();
      await _prefs.clear();
      
      AppLogger.debug('All cache cleared successfully');
    } catch (e) {
      AppLogger.error('Failed to clear cache', e);
    }
  }

  /// Clear expired cache entries
  Future<void> _cleanExpiredCache() async {
    try {
      // Clean expired AI interpretations
      final aiKeys = _aiInterpretationCache.keys.toList();
      for (final key in aiKeys) {
        final data = _aiInterpretationCache.get(key);
        if (data != null) {
          final expiresAt = DateTime.parse(data['expiresAt'] as String);
          if (DateTime.now().isAfter(expiresAt)) {
            await _aiInterpretationCache.delete(key);
          }
        }
      }
      
      // Clean expired image metadata
      final imageKeys = _cacheMetadata.keys.where((k) => k.toString().startsWith('image_')).toList();
      for (final key in imageKeys) {
        final data = _cacheMetadata.get(key);
        if (data != null && data['expiresAt'] != null) {
          final expiresAt = DateTime.parse(data['expiresAt'] as String);
          if (DateTime.now().isAfter(expiresAt)) {
            await _cacheMetadata.delete(key);
            final cardId = key.toString().replaceFirst('image_', '');
            await _imageCacheManager.removeFile('tarot_card_$cardId');
          }
        }
      }
      
      AppLogger.debug('Expired cache cleaned successfully');
    } catch (e) {
      AppLogger.error('Failed to clean expired cache', e);
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStatistics() async {
    try {
      final aiCacheSize = _aiInterpretationCache.length;
      final readingHistorySize = _readingHistoryCache.length;
      final imageMetadataSize = _cacheMetadata.keys.where((k) => k.toString().startsWith('image_')).length;
      
      // Calculate total cache size in MB (approximate)
      double totalSizeMB = 0;
      
      // Estimate sizes based on entry counts
      totalSizeMB += (aiCacheSize * 0.01); // ~10KB per interpretation
      totalSizeMB += (readingHistorySize * 0.05); // ~50KB per user history
      totalSizeMB += (imageMetadataSize * 0.5); // ~500KB per image
      
      return {
        'aiInterpretations': aiCacheSize,
        'readingHistories': readingHistorySize,
        'cachedImages': imageMetadataSize,
        'totalSizeMB': totalSizeMB.toStringAsFixed(2),
        'lastCleanup': _prefs.getString('lastCacheCleanup') ?? 'Never',
      };
    } catch (e) {
      AppLogger.error('Failed to get cache statistics', e);
      return {};
    }
  }

  /// Dispose of the cache service
  Future<void> dispose() async {
    try {
      await _aiInterpretationCache.close();
      await _readingHistoryCache.close();
      await _cacheMetadata.close();
      _isInitialized = false;
    } catch (e) {
      AppLogger.error('Failed to dispose CacheService', e);
    }
  }
}