import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';
import '../../../data/repositories/ad_repository.dart';
import '../../../core/utils/app_logger.dart';

final mainViewModelProvider = StateNotifierProvider<MainViewModel, MainState>((ref) {
  final adRepository = ref.watch(adRepositoryProvider);
  return MainViewModel(ref, adRepository);
});

class MainViewModel extends StateNotifier<MainState> {
  final Ref _ref;
  final AdRepository _adRepository;

  MainViewModel(this._ref, this._adRepository) : super(MainState());

  Future<void> initializeAds() async {
    try {
      await _adRepository.initializeAds();
    } catch (e) {
      AppLogger.error('Failed to initialize ads', e);
    }
  }

  void setUserMood(String mood) {
    _ref.read(userMoodProvider.notifier).state = mood;
    state = state.copyWith(selectedMood: mood);
  }

  void resetSelection() {
    _ref.read(userMoodProvider.notifier).state = null;
    state = state.copyWith(selectedMood: null);
  }
}

class MainState {
  final String? selectedMood;
  final bool isLoading;

  MainState({
    this.selectedMood,
    this.isLoading = false,
  });

  MainState copyWith({
    String? selectedMood,
    bool? isLoading,
  }) {
    return MainState(
      selectedMood: selectedMood ?? this.selectedMood,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}