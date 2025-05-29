import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/tarot_card_model.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../data/models/ai_interpretation_model.dart';
import '../../../data/models/tarot_reading_model.dart';
import '../../../providers.dart';
import '../../../core/utils/app_logger.dart';

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
    AppLogger.debug("ResultChatViewModel initialize - card: ${card.name}, mood: $userMood");
    
    state = state.copyWith(
      selectedCard: card,
      userMood: userMood,
      isLoadingInterpretation: true,
    );

    try {
      // Get AI interpretation
      final tarotAIRepo = _ref.read(tarotAIRepositoryProvider);
      AppLogger.debug("Getting AI interpretation...");
      
      final interpretation = await tarotAIRepo.getCardInterpretation(
        card: card,
        userMood: userMood,
      );
      
      AppLogger.debug("AI interpretation received: ${interpretation.length > 50 ? interpretation.substring(0, 50) : interpretation}...");

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

      // Save to Firestore if user is logged in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _saveReading();
      } else {
        AppLogger.warning("User not logged in, skipping Firestore save");
      }
    } catch (e, stack) {
      AppLogger.error("Error in initialize", e, stack);
      state = state.copyWith(
        isLoadingInterpretation: false,
        error: e.toString(),
      );
      
      // Set a default interpretation if API fails
      final defaultInterpretation = AIInterpretationModel(
        cardName: card.name,
        interpretation: "운명의 카드가 당신 앞에 놓였습니다. ${card.nameKr} 카드는 ${card.keywords.join(', ')}를 상징합니다. 당신의 현재 상황을 비추어 보면, 이 카드는 깊은 의미를 담고 있습니다...",
        userMood: userMood,
        keywords: card.keywords,
      );
      
      state = state.copyWith(
        interpretation: defaultInterpretation,
        error: null,
      );
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    
    AppLogger.debug("Sending message: $message");

    // Add user message
    final userMessage = ChatMessageModel(
      id: _uuid.v4(),
      message: message,
      isUser: true,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
      isLoading: true,
    );

    // Increment turn count
    _ref.read(chatTurnCountProvider.notifier).state++;
    final turnCount = _ref.read(chatTurnCountProvider);
    
    AppLogger.debug("Turn count: $turnCount");

    // Check if should show ad prompt
    if (turnCount >= 3 && !state.hasShownAd) {
      state = state.copyWith(
        showAdPrompt: true,
        isTyping: false,
        isLoading: false,
      );
      return;
    }

    try {
      // Get AI response
      final tarotAIRepo = _ref.read(tarotAIRepositoryProvider);
      
      AppLogger.debug("Getting chat response...");
      
      final response = await tarotAIRepo.getChatResponse(
        cardName: state.selectedCard?.name ?? '',
        interpretation: state.interpretation?.interpretation ?? '',
        previousMessages: state.messages,
        userMessage: message,
      );
      
      AppLogger.debug("Chat response received: ${response.length > 50 ? response.substring(0, 50) : response}...");

      // Add AI response
      final aiMessage = ChatMessageModel(
        id: _uuid.v4(),
        message: response,
        isUser: false,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isTyping: false,
        isLoading: false,
      );

      // Update Firestore if logged in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && _currentReadingId != null) {
        await _updateChatHistory(userMessage, aiMessage);
      }
    } catch (e, stack) {
      AppLogger.error("Error in sendMessage", e, stack);
      
      // Add error message
      final errorMessage = ChatMessageModel(
        id: _uuid.v4(),
        message: "죄송합니다. 운명의 실이 잠시 엉켜버렸네요. 다시 시도해 주세요.",
        isUser: false,
      );
      
      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isTyping: false,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> showAd() async {
    AppLogger.debug("Showing ad...");
    
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
      AppLogger.error("Ad failed", e);
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

    try {
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
      
      AppLogger.debug("Reading saved with ID: $_currentReadingId");
    } catch (e) {
      AppLogger.error("Error saving reading", e);
    }
  }

  Future<void> _updateChatHistory(
    ChatMessageModel userMessage,
    ChatMessageModel aiMessage,
  ) async {
    if (_currentReadingId == null) return;

    try {
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
    } catch (e) {
      AppLogger.error("Error updating chat history", e);
    }
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