import 'package:cloud_functions/cloud_functions.dart';
import '../models/chat_message_model.dart';
import '../models/tarot_card_model.dart';
import '../models/tarot_spread_model.dart';
import '../models/ai_interpretation_model.dart';
import '../repositories/cache_repository.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/input_validator.dart';
import '../../core/utils/retry_helper.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/constants/fallback_messages.dart';
import '../../l10n/generated/app_localizations.dart';

/// Gemini AI 서비스 - Firebase Functions를 통한 안전한 API 호출
class GeminiService {
  late final FirebaseFunctions _functions;
  final CacheRepository? _cacheRepository;
  final AppLocalizations? _localizations;
  FallbackMessages? _fallbackMessages;
  
  // 타임아웃 설정 (30초)
  static const Duration _timeout = Duration(seconds: 30);
  
  GeminiService({
    CacheRepository? cacheRepository,
    AppLocalizations? localizations,
  }) : _cacheRepository = cacheRepository,
       _localizations = localizations {
    if (_localizations != null) {
      _fallbackMessages = FallbackMessages(_localizations!);
    }
    _initializeFunctions();
  }
  
  /// Firebase Functions 초기화
  void _initializeFunctions() {
  try {
    _functions = FirebaseFunctions.instance;  // 리전 설정 제거
    AppLogger.debug("Firebase Functions initialized");
  } catch (e) {
    AppLogger.error("Failed to initialize Firebase Functions", e);
    rethrow;
  }
}
  
  /// Firebase Function 호출 헬퍼 메서드
  /// Firebase Functions 호출 헬퍼 (재시도 로직 포함)
  Future<T> _callFunction<T>(String functionName, Map<String, dynamic> data) async {
    return RetryHelper.execute(
      operation: () async {
        try {
          final callable = _functions.httpsCallable(
            functionName,
            options: HttpsCallableOptions(timeout: _timeout),
          );
          
          final result = await callable.call(data);
          
          if (result.data == null) {
            throw ApiException.invalidResponse();
          }
          
          return result.data as T;
        } on FirebaseFunctionsException catch (e) {
          AppLogger.error("Firebase Functions error: ${e.code} - ${e.message}");
          
          // 에러 타입별 처리
          switch (e.code) {
            case 'unauthenticated':
              throw AuthException(code: 'unauthenticated', message: e.message);
            case 'resource-exhausted':
              throw ApiException.quotaExceeded();
            case 'deadline-exceeded':
              throw NetworkException.connectionTimeout();
            case 'unavailable':
              throw NetworkException.serverError();
            case 'invalid-argument':
              throw ApiException(code: 'invalid_argument', message: e.message);
            default:
              throw ApiException(code: e.code, message: e.message);
          }
        } catch (e) {
          if (e is AppException) rethrow;
          AppLogger.error("Unexpected error calling function: $functionName", e);
          throw NetworkException(code: 'unknown_error', originalError: e);
        }
      },
      operationName: 'GeminiService.$functionName',
      policy: RetryPolicy.standard,
      onRetry: (attempt, error) {
        AppLogger.warning('Retrying $functionName (attempt $attempt): $error');
      },
    );
  }
  
  /// 단일 카드 해석 (원카드용)
  Future<String> generateTarotInterpretation({
    required String cardName,
    required String userMood,
    String language = 'ko',
  }) async {
    try {
      // 입력 유효성 검사
      if (!InputValidator.isValidMood(userMood)) {
        throw Exception('Invalid emotion input.');
      }
      
      final sanitizedMood = InputValidator.sanitizeText(userMood);
      final sanitizedCardName = InputValidator.sanitizeText(cardName);
      
      // 캐시 확인
      if (_cacheRepository != null) {
        final cachedInterpretation = await _cacheRepository!.getCachedAIInterpretation(
          cardName: sanitizedCardName,
          userMood: sanitizedMood,
          spreadType: 'oneCard',
        );
        
        if (cachedInterpretation != null) {
          AppLogger.debug("Using cached interpretation for card: $sanitizedCardName");
          return cachedInterpretation.interpretation;
        }
      }
      
      AppLogger.debug("Generating interpretation for card: $sanitizedCardName, mood: $sanitizedMood, language: $language");
      
      final Map<String, dynamic> result = await _callFunction(
        'generateTarotInterpretation',
        {
          'cardName': sanitizedCardName,
          'userMood': sanitizedMood,
          'interpretationType': 'single',
          'language': language,
        },
      );
      
      final interpretation = result['interpretation'] as String?;
      if (interpretation == null || interpretation.isEmpty) {
        throw Exception('Could not receive interpretation result.');
      }
      
      // 캐시 저장
      if (_cacheRepository != null) {
        await _cacheRepository!.cacheAIInterpretation(
          cardName: sanitizedCardName,
          userMood: sanitizedMood,
          spreadType: 'oneCard',
          interpretation: AIInterpretationModel(
            cardName: sanitizedCardName,
            interpretation: interpretation,
            userMood: sanitizedMood,
            keywords: result['keywords'] as List<String>? ?? [],
          ),
        );
      }
      
      AppLogger.debug("Successfully generated interpretation");
      return interpretation;
      
    } catch (e) {
      AppLogger.error("Failed to generate interpretation", e);
      
      // 에러 발생 시 로컬 폴백 해석 제공
      return _getFallbackInterpretation(cardName, userMood);
    }
  }
  
  /// 스프레드별 종합 해석
  Future<String> generateSpreadInterpretation({
    required SpreadType spreadType,
    required List<TarotCardModel> drawnCards,
    required String userMood,
    required TarotSpread spread,
    String language = 'ko',
  }) async {
    // 원카드는 단일 해석 함수 사용
    if (spreadType == SpreadType.oneCard) {
      return generateTarotInterpretation(
        cardName: drawnCards[0].getLocalizedName(language),
        userMood: userMood,
        language: language,
      );
    }
    
    try {
      // 캐시 키 생성을 위한 카드 이름 조합
      final cardNames = drawnCards.map((c) => c.name).join(',');
      
      // 캐시 확인
      if (_cacheRepository != null) {
        final cachedInterpretation = await _cacheRepository!.getCachedAIInterpretation(
          cardName: cardNames,
          userMood: userMood,
          spreadType: spreadType.name,
        );
        
        if (cachedInterpretation != null) {
          AppLogger.debug("Using cached spread interpretation for: ${spreadType.name}");
          return cachedInterpretation.interpretation;
        }
      }
      
      AppLogger.debug("Generating spread interpretation for: ${spreadType.name}");
      
      // 카드 정보 준비 - 언어별 로컬라이즈된 이름 사용
      final cardsData = drawnCards.map((card) => {
        'name': card.getLocalizedName(language),
        'nameKr': card.nameKr,
        'id': card.id,
        'nameEn': card.name, // 영어 이름도 참고용으로 포함
      }).toList();
      
      final Map<String, dynamic> result = await _callFunction(
        'generateSpreadInterpretation',
        {
          'spreadType': spreadType.name,
          'cards': cardsData,
          'userMood': userMood,
          'spreadName': spread.name,
          'positions': spread.positions.map((p) => p.getLocalizedTitle(language)).toList(),
          'language': language,
        },
      );
      
      final interpretation = result['interpretation'] as String?;
      if (interpretation == null || interpretation.isEmpty) {
        throw Exception('Could not receive interpretation result.');
      }
      
      // 캐시 저장
      if (_cacheRepository != null) {
        await _cacheRepository!.cacheAIInterpretation(
          cardName: cardNames,
          userMood: userMood,
          spreadType: spreadType.name,
          interpretation: AIInterpretationModel(
            cardName: cardNames,
            interpretation: interpretation,
            userMood: userMood,
            keywords: result['keywords'] as List<String>? ?? [],
          ),
        );
      }
      
      AppLogger.debug("Successfully generated spread interpretation");
      return interpretation;
      
    } catch (e) {
      AppLogger.error("Failed to generate spread interpretation", e);
      return _getSpreadFallback(spreadType, drawnCards, userMood);
    }
  }
  
  /// 대화형 응답 생성
  Future<String> generateChatResponse({
    required String cardName,
    required String interpretation,
    required List<ChatMessageModel> previousMessages,
    required String userMessage,
    SpreadType? spreadType,
    String language = 'ko',
  }) async {
    try {
      // 메시지 유효성 검사
      final validationError = InputValidator.validateChatMessage(userMessage);
      if (validationError != null) {
        throw Exception(validationError);
      }
      
      final sanitizedMessage = InputValidator.sanitizeText(userMessage);
      
      AppLogger.debug("Generating chat response");
      
      // 최근 6개 메시지만 전송 (토큰 절약 및 컨텍스트 최적화)
      final recentMessages = previousMessages.length > 6 
          ? previousMessages.sublist(previousMessages.length - 6)
          : previousMessages;
      
      // 메시지 형식 변환 및 정화
      final messageHistory = recentMessages.map((msg) => {
        'role': msg.isUser ? 'user' : 'assistant',
        'content': InputValidator.sanitizeText(msg.message),
      }).toList();
      
      final Map<String, dynamic> result = await _callFunction(
        'generateChatResponse',
        {
          'cardName': InputValidator.sanitizeText(cardName),
          'interpretationSummary': interpretation.length > 200 
              ? '${InputValidator.sanitizeText(interpretation.substring(0, 200))}...' 
              : InputValidator.sanitizeText(interpretation),
          'previousMessages': messageHistory,
          'userMessage': sanitizedMessage,
          'spreadType': spreadType?.name,
          'language': language,
        },
      );
      
      final response = result['response'] as String?;
      if (response == null || response.isEmpty) {
        throw Exception('Failed to generate response.');
      }
      
      AppLogger.debug("Successfully generated chat response");
      return response;
      
    } catch (e) {
      AppLogger.error("Failed to generate chat response", e);
      return _getChatFallbackResponse(cardName, userMessage);
    }
  }
  
  // ===== 폴백 응답 메서드들 (오프라인/에러 시 사용) =====
  
  /// 단일 카드 폴백 해석
  String _getFallbackInterpretation(String cardName, String userMood) {
    if (_fallbackMessages == null) {
      return 'An error occurred while generating card interpretation. Please try again later.';
    }
    return _fallbackMessages!.getSingleCardFallback(cardName, userMood);
  }
  
  /// 스프레드 폴백 해석
  String _getSpreadFallback(
    SpreadType type, 
    List<TarotCardModel> cards, 
    String userMood,
  ) {
    switch (type) {
      case SpreadType.threeCard:
        return _fallbackMessages?.getThreeCardFallback(cards, userMood) ?? 'An error occurred while generating card interpretation.';
      case SpreadType.yesNo:
        return _fallbackMessages?.getYesNoFallback(cards, userMood) ?? 'An error occurred while generating card interpretation.';
      case SpreadType.relationship:
        return _fallbackMessages?.getRelationshipFallback(cards, userMood) ?? 'An error occurred while generating card interpretation.';
      case SpreadType.celticCross:
        return _fallbackMessages?.getCelticCrossFallback(cards, userMood) ?? 'An error occurred while generating card interpretation.';
      default:
        return _fallbackMessages?.getSingleCardFallback(cards.first.nameKr, userMood) ?? 'An error occurred while generating card interpretation.';
    }
  }
  
  /// 채팅 폴백 응답
  String _getChatFallbackResponse(String cardName, String userMessage) {
    if (_fallbackMessages == null) {
      return 'Sorry, I cannot generate a response right now. Please try again later.';
    }
    return _fallbackMessages!.getChatFallbackResponse(cardName, userMessage);
  }
}