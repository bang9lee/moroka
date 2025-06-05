import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/tarot_card_model.dart';
import '../../../data/models/tarot_spread_model.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../data/models/tarot_reading_model.dart';
import '../../../providers.dart';
import '../../../providers/locale_provider.dart';
import '../../../core/utils/app_logger.dart';

final resultChatViewModelProvider = 
    StateNotifierProvider<ResultChatViewModel, ResultChatState>((ref) {
  return ResultChatViewModel(ref);
});

// 광고 시청 횟수 추적
final adWatchCountProvider = StateProvider<int>((ref) => 0);

// 채팅 턴 카운트 추적
final chatTurnCountProvider = StateProvider<int>((ref) => 0);

class ResultChatViewModel extends StateNotifier<ResultChatState> {
  final Ref _ref;
  final _uuid = const Uuid();
  String? _currentReadingId;

  ResultChatViewModel(this._ref) : super(ResultChatState());

  // 단일 카드 초기화 (원카드용)
  Future<void> initialize({
    required TarotCardModel card,
    required String userMood,
  }) async {
    AppLogger.debug("ResultChatViewModel initialize - single card: ${card.name}, mood: $userMood");
    
    state = state.copyWith(
      selectedCards: [card],
      userMood: userMood,
      isLoadingInterpretation: true,
    );

    try {
      final tarotAIRepo = _ref.read(tarotAIRepositoryProvider);
      
      // 현재 언어 가져오기
      final locale = _ref.read(localeProvider);
      final language = locale?.languageCode ?? 'en';
      
      AppLogger.debug("Getting AI interpretation for language: $language");
      
      final interpretation = await tarotAIRepo.getCardInterpretation(
        card: card,
        userMood: userMood,
        language: language, // language 파라미터 추가
      );
      
      AppLogger.debug("AI interpretation received");

      state = state.copyWith(
        spreadInterpretation: interpretation,
        isLoadingInterpretation: false,
      );

      await _saveReading();
    } catch (e, stack) {
      AppLogger.error("Error in initialize", e, stack);
      state = state.copyWith(
        isLoadingInterpretation: false,
        error: e.toString(),
      );
    }
  }

  // 배열법 초기화
  Future<void> initializeWithSpread({
    required List<TarotCardModel> cards,
    required String userMood,
    required TarotSpread spread,
  }) async {
    AppLogger.debug("ResultChatViewModel initialize - spread: ${spread.name}, cards: ${cards.length}, mood: $userMood");
    
    state = state.copyWith(
      selectedCards: cards,
      userMood: userMood,
      spread: spread,
      spreadType: spread.type,
      isLoadingInterpretation: true,
    );

    try {
      final geminiService = _ref.read(geminiServiceProvider);
      final locale = _ref.read(localeProvider);
      final language = locale?.languageCode ?? 'en';
      
      AppLogger.debug("Getting spread interpretation for language: $language");
      
      final interpretation = await geminiService.generateSpreadInterpretation(
        spreadType: spread.type,
        drawnCards: cards,
        userMood: userMood,
        spread: spread,
        language: language,
      );
      
      AppLogger.debug("Spread interpretation received");

      state = state.copyWith(
        spreadInterpretation: interpretation,
        isLoadingInterpretation: false,
      );

      await _saveReading();
    } catch (e, stack) {
      AppLogger.error("Error in initializeWithSpread", e, stack);
      state = state.copyWith(
        isLoadingInterpretation: false,
        error: e.toString(),
        spreadInterpretation: _getDefaultSpreadInterpretation(cards, spread, userMood),
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

    // 채팅 턴 카운트 증가
    _ref.read(chatTurnCountProvider.notifier).state++;
    final turnCount = _ref.read(chatTurnCountProvider);
    
    AppLogger.debug("Turn count: $turnCount");

    try {
      final geminiService = _ref.read(geminiServiceProvider);
      final locale = _ref.read(localeProvider);
      final language = locale?.languageCode ?? 'en';
      
      AppLogger.debug("Getting chat response for language: $language");
      
      // 배열법에 따라 다른 컨텍스트 제공 - 현재 언어에 맞는 카드 이름 사용
      final cardContext = state.spreadType != null && state.selectedCards.length > 1
          ? state.selectedCards.map((c) => c.getLocalizedName(language)).join(', ')
          : state.selectedCards.first.getLocalizedName(language);
      
      final response = await geminiService.generateChatResponse(
        cardName: cardContext,
        interpretation: state.spreadInterpretation ?? '',
        previousMessages: state.messages,
        userMessage: message,
        spreadType: state.spreadType,
        language: language,
      );
      
      AppLogger.debug("Chat response received");

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
      
      // 광고 시청 횟수 확인
      final adWatchCount = _ref.read(adWatchCountProvider);
      
      // 매 메시지 후 광고 표시 (최대 3회까지)
      // turnCount는 1부터 시작하므로 1, 2, 3번째 메시지 후에 광고 표시
      if (turnCount <= 3 && adWatchCount < turnCount) {
        AppLogger.debug("Showing ad prompt - turn: $turnCount, adWatchCount: $adWatchCount");
        state = state.copyWith(
          showAdPrompt: true,
        );
      } else if (turnCount > 3 && adWatchCount < 3) {
        // 3회 채팅 완료했지만 광고를 모두 시청하지 않은 경우
        AppLogger.debug("Chat limit reached without watching all ads");
        state = state.copyWith(
          chatLimitReached: true,
        );
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
      adRepo.showInterstitialAd();
      
      // 광고 시청 횟수 증가
      _ref.read(adWatchCountProvider.notifier).state++;
      final adWatchCount = _ref.read(adWatchCountProvider);
      
      AppLogger.debug("Ad watched - count: $adWatchCount");
      
      state = state.copyWith(
        hasShownAd: true,
        showAdPrompt: false,
      );
      
      // 3회 광고 시청 완료 시
      if (adWatchCount >= 3) {
        state = state.copyWith(
          chatLimitReached: true,
        );
      }
      
      adRepo.preloadAds();
    } catch (e) {
      AppLogger.error("Ad failed", e);
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
      
      // 배열법에 따른 카드 정보 저장 - 영어 이름을 기본으로 저장 (범용성을 위해)
      final cardNames = state.selectedCards.map((c) => c.name).join(', ');
      final cardImages = state.selectedCards.map((c) => c.imagePath).join(',');
      
      final reading = TarotReadingModel(
        id: _uuid.v4(),
        userId: user.uid,
        cardName: cardNames,
        cardImage: cardImages,
        interpretation: state.spreadInterpretation ?? '',
        chatHistory: [],
        createdAt: DateTime.now(),
        userMood: state.userMood,
        spreadType: state.spreadType?.toString(),
        cardCount: state.selectedCards.length,
      );

      _currentReadingId = await firestoreService.saveTarotReading(reading);
      
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

  String _getDefaultSpreadInterpretation(
    List<TarotCardModel> cards,
    TarotSpread spread,
    String userMood,
  ) {
    final cardNames = cards.map((c) => c.nameKr).join(', ');
    return '''
${spread.nameKr} 배열이 펼쳐졌습니다.

선택하신 카드들: $cardNames

이 카드들이 만들어내는 에너지가 당신의 $userMood 마음과 공명하고 있습니다.
각 카드가 전하는 메시지들이 서로 연결되어 더 큰 그림을 그리고 있네요.

잠시 후 더 깊은 해석을 전해드리겠습니다...
''';
  }

  void reset() {
    state = ResultChatState();
    _ref.read(chatTurnCountProvider.notifier).state = 0;
    _ref.read(adWatchCountProvider.notifier).state = 0;
    _currentReadingId = null;
  }
}

class ResultChatState {
  final List<TarotCardModel> selectedCards;
  final String userMood;
  final TarotSpread? spread;
  final SpreadType? spreadType;
  final String? spreadInterpretation;
  final List<ChatMessageModel> messages;
  final bool isLoadingInterpretation;
  final bool isTyping;
  final bool showAdPrompt;
  final bool hasShownAd;
  final bool isLoading;
  final bool chatLimitReached;
  final String? error;

  ResultChatState({
    this.selectedCards = const [],
    this.userMood = '',
    this.spread,
    this.spreadType,
    this.spreadInterpretation,
    this.messages = const [],
    this.isLoadingInterpretation = false,
    this.isTyping = false,
    this.showAdPrompt = false,
    this.hasShownAd = false,
    this.isLoading = false,
    this.chatLimitReached = false,
    this.error,
  });

  ResultChatState copyWith({
    List<TarotCardModel>? selectedCards,
    String? userMood,
    TarotSpread? spread,
    SpreadType? spreadType,
    String? spreadInterpretation,
    List<ChatMessageModel>? messages,
    bool? isLoadingInterpretation,
    bool? isTyping,
    bool? showAdPrompt,
    bool? hasShownAd,
    bool? isLoading,
    bool? chatLimitReached,
    String? error,
  }) {
    return ResultChatState(
      selectedCards: selectedCards ?? this.selectedCards,
      userMood: userMood ?? this.userMood,
      spread: spread ?? this.spread,
      spreadType: spreadType ?? this.spreadType,
      spreadInterpretation: spreadInterpretation ?? this.spreadInterpretation,
      messages: messages ?? this.messages,
      isLoadingInterpretation: isLoadingInterpretation ?? this.isLoadingInterpretation,
      isTyping: isTyping ?? this.isTyping,
      showAdPrompt: showAdPrompt ?? this.showAdPrompt,
      hasShownAd: hasShownAd ?? this.hasShownAd,
      isLoading: isLoading ?? this.isLoading,
      chatLimitReached: chatLimitReached ?? this.chatLimitReached,
      error: error,
    );
  }
}