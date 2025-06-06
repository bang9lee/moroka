import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../data/services/firestore_service.dart';
import '../../../providers.dart';
import '../../../core/utils/app_logger.dart';

final statisticsViewModelProvider = 
    StateNotifierProvider<StatisticsViewModel, StatisticsState>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return StatisticsViewModel(firestoreService);
});

class StatisticsViewModel extends StateNotifier<StatisticsState> {
  final FirestoreService _firestoreService;
  
  StatisticsViewModel(this._firestoreService) : super(StatisticsState());

  Future<void> loadStatistics() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    state = state.copyWith(isLoading: true);

    try {
      // Get basic statistics
      final statistics = await _firestoreService.getUserStatistics(user.uid);
      
      // Get monthly trend
      final monthlyTrend = await _calculateMonthlyTrend(user.uid);
      
      state = state.copyWith(
        statistics: statistics,
        monthlyTrend: monthlyTrend,
        isLoading: false,
      );
    } catch (e) {
      AppLogger.error('Error loading statistics', e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Map<String, int>> _calculateMonthlyTrend(String userId) async {
    final result = await _firestoreService.getUserReadings(
      userId: userId,
      limit: 100, // Get last 100 readings for trend
    );
    
    final readings = result.readings;
    final monthlyCount = <String, int>{};
    final dateFormat = DateFormat('yyyy-MM');
    
    for (final reading in readings) {
      final monthKey = dateFormat.format(reading.createdAt);
      monthlyCount[monthKey] = (monthlyCount[monthKey] ?? 0) + 1;
    }
    
    // Sort by date and take last 6 months
    final sortedEntries = monthlyCount.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    final last6Months = sortedEntries.length > 6 
        ? sortedEntries.sublist(sortedEntries.length - 6)
        : sortedEntries;
    
    return Map.fromEntries(last6Months);
  }
}

class StatisticsState {
  final Map<String, dynamic>? statistics;
  final Map<String, int> monthlyTrend;
  final bool isLoading;
  final String? error;

  StatisticsState({
    this.statistics,
    this.monthlyTrend = const {},
    this.isLoading = false,
    this.error,
  });

  StatisticsState copyWith({
    Map<String, dynamic>? statistics,
    Map<String, int>? monthlyTrend,
    bool? isLoading,
    String? error,
  }) {
    return StatisticsState(
      statistics: statistics ?? this.statistics,
      monthlyTrend: monthlyTrend ?? this.monthlyTrend,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}