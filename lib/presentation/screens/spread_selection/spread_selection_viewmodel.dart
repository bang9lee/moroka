import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/tarot_spread_model.dart';
import '../../../providers.dart';

final spreadSelectionViewModelProvider = 
    StateNotifierProvider<SpreadSelectionViewModel, SpreadSelectionState>((ref) {
  return SpreadSelectionViewModel(ref);
});

class SpreadSelectionViewModel extends StateNotifier<SpreadSelectionState> {
  final Ref _ref;
  
  SpreadSelectionViewModel(this._ref) : super(SpreadSelectionState());
  
  void selectSpread(TarotSpread spread) {
    _ref.read(selectedSpreadProvider.notifier).state = spread;
    state = state.copyWith(selectedSpread: spread);
  }
  
  void resetSelection() {
    _ref.read(selectedSpreadProvider.notifier).state = null;
    state = state.copyWith(selectedSpread: null);
  }
}

class SpreadSelectionState {
  final TarotSpread? selectedSpread;
  final List<TarotSpread> allSpreads;
  final List<TarotSpread> beginnerSpreads;
  final List<TarotSpread> intermediateSpreads;
  final List<TarotSpread> advancedSpreads;
  
  SpreadSelectionState({
    this.selectedSpread,
  }) : allSpreads = TarotSpread.allSpreads,
       beginnerSpreads = TarotSpread.getSpreadsByDifficulty(SpreadDifficulty.beginner),
       intermediateSpreads = TarotSpread.getSpreadsByDifficulty(SpreadDifficulty.intermediate),
       advancedSpreads = TarotSpread.getSpreadsByDifficulty(SpreadDifficulty.advanced);
  
  SpreadSelectionState copyWith({
    TarotSpread? selectedSpread,
  }) {
    return SpreadSelectionState(
      selectedSpread: selectedSpread ?? this.selectedSpread,
    );
  }
}