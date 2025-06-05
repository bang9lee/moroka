import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/tarot_reading_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/repositories/cache_repository.dart';
import '../../../providers.dart';
import '../../../core/utils/app_logger.dart';

final historyViewModelProvider = 
    StateNotifierProvider<HistoryViewModel, HistoryState>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final cacheRepository = ref.watch(cacheRepositoryProvider);
  return HistoryViewModel(firestoreService, cacheRepository);
});

class HistoryViewModel extends StateNotifier<HistoryState> {
  final FirestoreService _firestoreService;
  final CacheRepository _cacheRepository;
  DocumentSnapshot? _lastDocument;
  
  HistoryViewModel(this._firestoreService, this._cacheRepository) : super(HistoryState());

  Future<void> loadReadings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    state = state.copyWith(isLoading: true);

    try {
      // Try to get cached readings first
      final cachedReadings = await _cacheRepository.getCachedReadingHistory(user.uid);
      if (cachedReadings != null && cachedReadings.isNotEmpty) {
        AppLogger.debug('Using cached reading history');
        state = state.copyWith(
          readings: cachedReadings,
          isLoading: false,
          hasMore: cachedReadings.length >= 10,
        );
        return;
      }

      // If no cache, fetch from Firestore
      final readings = await _firestoreService.getUserReadings(
        userId: user.uid,
        limit: 10,
      );

      if (readings.isNotEmpty) {
        // Get last document for pagination
        final lastReadingId = readings.last.id;
        final lastDoc = await FirebaseFirestore.instance
            .collection('readings')
            .doc(lastReadingId)
            .get();
        _lastDocument = lastDoc;
        
        // Cache the readings
        await _cacheRepository.cacheUserReadingHistory(
          userId: user.uid,
          readings: readings,
        );
      }

      state = state.copyWith(
        readings: readings,
        isLoading: false,
        hasMore: readings.length >= 10,
      );
    } catch (e) {
      AppLogger.error('Error loading readings', e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMoreReadings() async {
    if (state.isLoadingMore || !state.hasMore || _lastDocument == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final moreReadings = await _firestoreService.getUserReadings(
        userId: user.uid,
        limit: 10,
        lastDocument: _lastDocument,
      );

      if (moreReadings.isNotEmpty) {
        // Update last document
        final lastReadingId = moreReadings.last.id;
        final lastDoc = await FirebaseFirestore.instance
            .collection('readings')
            .doc(lastReadingId)
            .get();
        _lastDocument = lastDoc;
      }

      final updatedReadings = [...state.readings, ...moreReadings];
      
      // Update cache with all readings
      await _cacheRepository.cacheUserReadingHistory(
        userId: user.uid,
        readings: updatedReadings,
      );
      
      state = state.copyWith(
        readings: updatedReadings,
        isLoadingMore: false,
        hasMore: moreReadings.length >= 10,
      );
    } catch (e) {
      AppLogger.error('Error loading more readings', e);
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshReadings() async {
    _lastDocument = null;
    state = state.copyWith(readings: [], hasMore: true);
    await loadReadings();
  }

  Future<void> deleteReading(String readingId) async {
    try {
      await _firestoreService.deleteReading(readingId);
      
      // Remove from local state
      state = state.copyWith(
        readings: state.readings.where((r) => r.id != readingId).toList(),
      );
      
      AppLogger.debug('Reading deleted: $readingId');
    } catch (e) {
      AppLogger.error('Error deleting reading', e);
      state = state.copyWith(error: e.toString());
    }
  }
}

class HistoryState {
  final List<TarotReadingModel> readings;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;

  HistoryState({
    this.readings = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  HistoryState copyWith({
    List<TarotReadingModel>? readings,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
  }) {
    return HistoryState(
      readings: readings ?? this.readings,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}