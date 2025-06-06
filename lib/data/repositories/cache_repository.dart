import '../models/ai_interpretation_model.dart';
import '../models/tarot_reading_model.dart';
import '../services/cache_service.dart';
import '../../core/utils/app_logger.dart';

class CacheRepository {
  final CacheService _cacheService;
  
  CacheRepository(this._cacheService);
  
  /// Generate cache key for AI interpretation
  String _generateAIInterpretationKey({
    required String cardName,
    required String userMood,
    required String spreadType,
  }) {
    return 'ai_${cardName}_${userMood}_$spreadType'.replaceAll(' ', '_').toLowerCase();
  }
  
  /// Cache AI interpretation with automatic key generation
  Future<void> cacheAIInterpretation({
    required String cardName,
    required String userMood,
    required String spreadType,
    required AIInterpretationModel interpretation,
  }) async {
    try {
      final key = _generateAIInterpretationKey(
        cardName: cardName,
        userMood: userMood,
        spreadType: spreadType,
      );
      
      await _cacheService.cacheAIInterpretation(
        key: key,
        interpretation: interpretation,
      );
    } catch (e) {
      AppLogger.error('Failed to cache AI interpretation in repository', e);
    }
  }
  
  /// Get cached AI interpretation
  Future<AIInterpretationModel?> getCachedAIInterpretation({
    required String cardName,
    required String userMood,
    required String spreadType,
  }) async {
    try {
      final key = _generateAIInterpretationKey(
        cardName: cardName,
        userMood: userMood,
        spreadType: spreadType,
      );
      
      return await _cacheService.getCachedAIInterpretation(key);
    } catch (e) {
      AppLogger.error('Failed to get cached AI interpretation from repository', e);
      return null;
    }
  }
  
  /// Cache user's reading history
  Future<void> cacheUserReadingHistory({
    required String userId,
    required List<TarotReadingModel> readings,
  }) async {
    try {
      await _cacheService.cacheReadingHistory(
        userId: userId,
        readings: readings,
      );
    } catch (e) {
      AppLogger.error('Failed to cache reading history in repository', e);
    }
  }
  
  /// Get cached reading history
  Future<List<TarotReadingModel>?> getCachedReadingHistory(String userId) async {
    try {
      final cachedReadings = await _cacheService.getCachedReadingHistory(userId);
      // Since the cache service now properly returns the deserialized models,
      // we can return them directly
      return cachedReadings;
    } catch (e) {
      AppLogger.error('Failed to get cached reading history from repository', e);
      return null;
    }
  }
  
  /// Cache card image from URL
  Future<void> cacheCardImageFromUrl({
    required String imageUrl,
    required String cardId,
  }) async {
    try {
      await _cacheService.cacheCardImage(
        imageUrl: imageUrl,
        cardId: cardId,
      );
    } catch (e) {
      AppLogger.error('Failed to cache card image in repository', e);
    }
  }
  
  /// Get cached card image path
  Future<String?> getCachedCardImagePath(String cardId) async {
    try {
      final fileInfo = await _cacheService.getCachedCardImage(cardId);
      return fileInfo?.file.path;
    } catch (e) {
      AppLogger.error('Failed to get cached card image from repository', e);
      return null;
    }
  }
  
  /// Check if AI interpretation is cached
  Future<bool> hasAIInterpretationCache({
    required String cardName,
    required String userMood,
    required String spreadType,
  }) async {
    final cached = await getCachedAIInterpretation(
      cardName: cardName,
      userMood: userMood,
      spreadType: spreadType,
    );
    return cached != null;
  }
  
  /// Preload essential data
  Future<void> preloadEssentialData() async {
    try {
      // Get all card image paths from assets
      final List<String> cardImagePaths = [
        // Major Arcana
        ...List.generate(22, (i) => 'assets/images/cards/major/${i.toString().padLeft(2, '0')}_*.png'),
        // Minor Arcana - Cups
        ...List.generate(14, (i) => 'assets/images/cards/minor/cups/cups_${(i + 1).toString().padLeft(2, '0')}*.png'),
        // Minor Arcana - Pentacles
        ...List.generate(14, (i) => 'assets/images/cards/minor/pentacles/pentacles_${(i + 1).toString().padLeft(2, '0')}*.png'),
        // Minor Arcana - Swords
        ...List.generate(14, (i) => 'assets/images/cards/minor/swords/swords_${(i + 1).toString().padLeft(2, '0')}*.png'),
        // Minor Arcana - Wands
        ...List.generate(14, (i) => 'assets/images/cards/minor/wands/wands_${(i + 1).toString().padLeft(2, '0')}*.png'),
      ];
      
      await _cacheService.preloadAllCardImages(cardImagePaths);
    } catch (e) {
      AppLogger.error('Failed to preload essential data', e);
    }
  }
  
  /// Save user preference
  Future<void> savePreference(String key, dynamic value) async {
    await _cacheService.saveUserPreference(key, value);
  }
  
  /// Get user preference
  T? getPreference<T>(String key, {T? defaultValue}) {
    return _cacheService.getUserPreference(key, defaultValue: defaultValue) as T?;
  }
  
  /// Clear all cache
  Future<void> clearAllCache() async {
    await _cacheService.clearAllCache();
  }

  /// Clear user reading history from cache
  Future<void> clearUserReadingHistory(String userId) async {
    await _cacheService.removeCachedReading('history_$userId');
  }
  
  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStatistics() async {
    return await _cacheService.getCacheStatistics();
  }
}