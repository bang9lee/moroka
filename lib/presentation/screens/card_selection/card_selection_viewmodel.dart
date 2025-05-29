import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/tarot_card_model.dart';

final cardSelectionViewModelProvider = 
    StateNotifierProvider<CardSelectionViewModel, CardSelectionState>((ref) {
  return CardSelectionViewModel();
});

class CardSelectionViewModel extends StateNotifier<CardSelectionState> {
  CardSelectionViewModel() : super(CardSelectionState());

  void shuffleCards() {
    state = state.copyWith(isShuffling: true);
    
    // Simulate shuffling
    final shuffledCards = List<TarotCardModel>.from(TarotCardModel.majorArcana)
      ..shuffle();
    
    state = state.copyWith(
      cards: shuffledCards,
      isShuffling: false,
      isReady: true,
    );
  }

  void selectCard(int index) {
    if (index < 0 || index >= state.cards.length) return;
    
    state = state.copyWith(
      selectedCardIndex: index,
      selectedCard: state.cards[index],
    );
  }

  void reset() {
    state = CardSelectionState();
  }
}

class CardSelectionState {
  final List<TarotCardModel> cards;
  final bool isShuffling;
  final bool isReady;
  final int? selectedCardIndex;
  final TarotCardModel? selectedCard;

  CardSelectionState({
    this.cards = const [],
    this.isShuffling = false,
    this.isReady = false,
    this.selectedCardIndex,
    this.selectedCard,
  });

  CardSelectionState copyWith({
    List<TarotCardModel>? cards,
    bool? isShuffling,
    bool? isReady,
    int? selectedCardIndex,
    TarotCardModel? selectedCard,
  }) {
    return CardSelectionState(
      cards: cards ?? this.cards,
      isShuffling: isShuffling ?? this.isShuffling,
      isReady: isReady ?? this.isReady,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      selectedCard: selectedCard ?? this.selectedCard,
    );
  }
}