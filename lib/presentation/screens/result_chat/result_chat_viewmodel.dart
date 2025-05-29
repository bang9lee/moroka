import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/tarot_card_model.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../data/models/ai_interpretation_model.dart';
import '../../../data/models/tarot_reading_model.dart';
import '../../../providers.dart';

final resultChatViewModelProvider = 
    StateNotifierProvider<ResultChatViewModel, ResultChatState>((ref) {
  return ResultChatViewModel(ref);
});

class ResultChatViewModel extends StateNotifier<ResultChatState> {
  final Ref _ref;
  final _uuid = const Uuid();
  String? _currentReadingId;

  ResultChatViewModel(this._ref) : super(ResultChatState());

  Future<void> initialize({
    required TarotCardModel card,
    required String userMood,
  }) async {
    state = state.copyWith(
      selectedCard: card,
      userMood: userMood,
      isLoadingInterpretation: true,
    );

    try {
      // Get AI interpretation
      final tarotAIRepo = _ref.read(tarotAIRepositoryProvider);
      final interpretation = await tarotAIRepo.getCardInterpretation(
        card: card,
        userMood: userMood,
      );

      final interpretationModel = AIInterpretationModel(
        cardName: card.name,
        interpretation: interpretation,
        userMood: userMood,
        keywords: card.keywords,
      );

      state = state.copyWith(
        interpretation: interpretationModel,
        isLoadingInterpretation: false,
      );

      // Save to Firestore
      await _saveReading();
    } catch (e) {
      state = state.copyWith(
        isLoadingInterpretation: false,
        error: e.toString(),
      );
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessageModel(
      id: _uuid.v4(),
      message: message,
      isUser: true,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    // Increment turn count
    _ref.read(chatTurnCountProvider.notifier).state++;
    final turnCount = _ref.read(chatTurnCountProvider);

    // Check if should show ad prompt
    if (turnCount >= 3 && !state.hasShownAd) {
      state = state.copyWith(
        showAdPrompt: true,
        isTyping: false,
      );
      return;
    }

    try {
      // Get AI response
      final tarotAIRepo = _ref.read(tarotAIRepositoryProvider);
      
      final response = await tarotAIRepo.getChatResponse(
        cardName: state.selectedCard?.name ?? '',
        interpretation: state.interpretation?.interpretation ?? '',
        previousMessages: state.messages,
        userMessage: message,
      );

      // Add AI response
      final aiMessage = ChatMessageModel(
        id: _uuid.v4(),
        message: response,
        isUser: false,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isTyping: false,
      );

      // Update Firestore
      await _updateChatHistory(userMessage, aiMessage);
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: e.toString(),
      );
    }
  }

  Future<void> showAd() async {
    final adRepo = _ref.read(adRepositoryProvider);
    
    try {
      // Show interstitial ad
      adRepo.showInterstitialAd();
      
      state = state.copyWith(
        hasShownAd: true,
        showAdPrompt: false,
      );
      
      // Preload next ad
      adRepo.preloadAds();
    } catch (e) {
      // Ad failed, but continue anyway
      state = state.copyWith(
        hasShownAd: true,
        showAdPrompt: false,
      );
    }
  }

  Future<void> _saveReading() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestoreService = _ref.read(firestoreServiceProvider);
    
    final reading = TarotReadingModel(
      id: _uuid.v4(),
      userId: user.uid,
      cardName: state.selectedCard?.nameKr ?? '',
      cardImage: state.selectedCard?.imagePath ?? '',
      interpretation: state.interpretation?.interpretation ?? '',
      chatHistory: [],
      createdAt: DateTime.now(),
      userMood: state.userMood,
    );

    _currentReadingId = await firestoreService.saveTarotReading(reading);
    
    // Update user's reading count
    await firestoreService.incrementReadingCount(user.uid);
  }

  Future<void> _updateChatHistory(
    ChatMessageModel userMessage,
    ChatMessageModel aiMessage,
  ) async {
    if (_currentReadingId == null) return;

    final firestoreService = _ref.read(firestoreServiceProvider);
    
    final exchange = ChatExchange(
      userMessage: userMessage.message,
      aiResponse: aiMessage.message,
      timestamp: DateTime.now(),
    );

    await firestoreService.addChatExchange(
      readingId: _currentReadingId!,
      exchange: exchange,
    );
  }

  void reset() {
    state = ResultChatState();
    _ref.read(chatTurnCountProvider.notifier).state = 0;
    _currentReadingId = null;
  }
}

class ResultChatState {
  final TarotCardModel? selectedCard;
  final String userMood;
  final AIInterpretationModel? interpretation;
  final List<ChatMessageModel> messages;
  final bool isLoadingInterpretation;
  final bool isTyping;
  final bool showAdPrompt;
  final bool hasShownAd;
  final bool isLoading;
  final String? error;

  ResultChatState({
    this.selectedCard,
    this.userMood = '',
    this.interpretation,
    this.messages = const [],
    this.isLoadingInterpretation = false,
    this.isTyping = false,
    this.showAdPrompt = false,
    this.hasShownAd = false,
    this.isLoading = false,
    this.error,
  });

  ResultChatState copyWith({
    TarotCardModel? selectedCard,
    String? userMood,
    AIInterpretationModel? interpretation,
    List<ChatMessageModel>? messages,
    bool? isLoadingInterpretation,
    bool? isTyping,
    bool? showAdPrompt,
    bool? hasShownAd,
    bool? isLoading,
    String? error,
  }) {
    return ResultChatState(
      selectedCard: selectedCard ?? this.selectedCard,
      userMood: userMood ?? this.userMood,
      interpretation: interpretation ?? this.interpretation,
      messages: messages ?? this.messages,
      isLoadingInterpretation: isLoadingInterpretation ?? this.isLoadingInterpretation,
      isTyping: isTyping ?? this.isTyping,
      showAdPrompt: showAdPrompt ?? this.showAdPrompt,
      hasShownAd: hasShownAd ?? this.hasShownAd,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}