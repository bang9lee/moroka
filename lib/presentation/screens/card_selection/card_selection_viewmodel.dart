import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/tarot_card_model.dart';
import '../../../core/utils/app_logger.dart';

final cardSelectionViewModelProvider = 
    StateNotifierProvider<CardSelectionViewModel, CardSelectionState>((ref) {
  return CardSelectionViewModel();
});

class CardSelectionViewModel extends StateNotifier<CardSelectionState> {
  CardSelectionViewModel() : super(CardSelectionState());

  void shuffleAndDeal() {
    AppLogger.debug("Shuffling and dealing cards");
    
    // 카드 섞기 애니메이션을 위한 상태
    state = state.copyWith(
      isShuffling: true,
      showingCards: false,
    );
    
    // 애니메이션 후 카드 표시
    Future.delayed(const Duration(milliseconds: 1000), () {
      state = state.copyWith(
        isShuffling: false,
        showingCards: true,
      );
    });
  }

  void selectCard(TarotCardModel card) {
    if (state.selectedCards.any((c) => c.id == card.id)) {
      AppLogger.debug("Card already selected: ${card.name}");
      return;
    }
    
    AppLogger.debug("Selecting card: ${card.name}");
    
    state = state.copyWith(
      selectedCards: [...state.selectedCards, card],
    );
  }

  void removeCard(TarotCardModel card) {
    AppLogger.debug("Removing card: ${card.name}");
    
    state = state.copyWith(
      selectedCards: state.selectedCards.where((c) => c.id != card.id).toList(),
    );
  }

  void reset() {
    AppLogger.debug("Resetting card selection");
    state = CardSelectionState();
  }
  
  // 새로운 메서드: 배열법 변경시 선택 초기화
  void clearSelection() {
    AppLogger.debug("Clearing card selection for new spread");
    state = state.copyWith(
      selectedCards: [],
      // showingCards와 isShuffling은 유지
    );
  }

  bool canProceed(int requiredCards) {
    return state.selectedCards.length >= requiredCards;
  }
}

class CardSelectionState {
  final List<TarotCardModel> selectedCards;
  final bool isShuffling;
  final bool showingCards;
  final bool isLoading;
  final String? error;

  CardSelectionState({
    this.selectedCards = const [],
    this.isShuffling = false,
    this.showingCards = false,
    this.isLoading = false,
    this.error,
  });

  CardSelectionState copyWith({
    List<TarotCardModel>? selectedCards,
    bool? isShuffling,
    bool? showingCards,
    bool? isLoading,
    String? error,
  }) {
    return CardSelectionState(
      selectedCards: selectedCards ?? this.selectedCards,
      isShuffling: isShuffling ?? this.isShuffling,
      showingCards: showingCards ?? this.showingCards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}