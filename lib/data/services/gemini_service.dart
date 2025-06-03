import 'package:cloud_functions/cloud_functions.dart';
import '../models/chat_message_model.dart';
import '../models/tarot_card_model.dart';
import '../models/tarot_spread_model.dart';
import '../../core/utils/app_logger.dart';

/// Gemini AI 서비스 - Firebase Functions를 통한 안전한 API 호출
class GeminiService {
  late final FirebaseFunctions _functions;
  
  // 타임아웃 설정 (30초)
  static const Duration _timeout = Duration(seconds: 30);
  
  GeminiService() {
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
  Future<T> _callFunction<T>(String functionName, Map<String, dynamic> data) async {
    try {
      final callable = _functions.httpsCallable(
        functionName,
        options: HttpsCallableOptions(timeout: _timeout),
      );
      
      final result = await callable.call(data);
      return result.data as T;
    } on FirebaseFunctionsException catch (e) {
      AppLogger.error("Firebase Functions error: ${e.code} - ${e.message}");
      
      // 에러 타입별 처리
      switch (e.code) {
        case 'unauthenticated':
          throw Exception('로그인이 필요합니다.');
        case 'resource-exhausted':
          throw Exception('오늘의 무료 사용량을 초과했습니다.');
        case 'deadline-exceeded':
          throw Exception('요청 시간이 초과되었습니다. 다시 시도해주세요.');
        default:
          throw Exception('AI 서비스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      }
    } catch (e) {
      AppLogger.error("Unexpected error calling function: $functionName", e);
      throw Exception('네트워크 오류가 발생했습니다.');
    }
  }
  
  /// 단일 카드 해석 (원카드용)
  Future<String> generateTarotInterpretation({
    required String cardName,
    required String userMood,
  }) async {
    try {
      AppLogger.debug("Generating interpretation for card: $cardName, mood: $userMood");
      
      final Map<String, dynamic> result = await _callFunction(
        'generateTarotInterpretation',
        {
          'cardName': cardName,
          'userMood': userMood,
          'interpretationType': 'single',
        },
      );
      
      final interpretation = result['interpretation'] as String?;
      if (interpretation == null || interpretation.isEmpty) {
        throw Exception('해석 결과를 받지 못했습니다.');
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
  }) async {
    // 원카드는 단일 해석 함수 사용
    if (spreadType == SpreadType.oneCard) {
      return generateTarotInterpretation(
        cardName: drawnCards[0].name,
        userMood: userMood,
      );
    }
    
    try {
      AppLogger.debug("Generating spread interpretation for: ${spreadType.name}");
      
      // 카드 정보 준비
      final cardsData = drawnCards.map((card) => {
        'name': card.name,
        'nameKr': card.nameKr,
        'id': card.id,
      }).toList();
      
      final Map<String, dynamic> result = await _callFunction(
        'generateSpreadInterpretation',
        {
          'spreadType': spreadType.name,
          'cards': cardsData,
          'userMood': userMood,
          'spreadName': spread.name,
          'positions': spread.positions.map((p) => p.titleKr).toList(),
        },
      );
      
      final interpretation = result['interpretation'] as String?;
      if (interpretation == null || interpretation.isEmpty) {
        throw Exception('해석 결과를 받지 못했습니다.');
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
  }) async {
    try {
      AppLogger.debug("Generating chat response");
      
      // 최근 6개 메시지만 전송 (토큰 절약 및 컨텍스트 최적화)
      final recentMessages = previousMessages.length > 6 
          ? previousMessages.sublist(previousMessages.length - 6)
          : previousMessages;
      
      // 메시지 형식 변환
      final messageHistory = recentMessages.map((msg) => {
        'role': msg.isUser ? 'user' : 'assistant',
        'content': msg.message,
      }).toList();
      
      final Map<String, dynamic> result = await _callFunction(
        'generateChatResponse',
        {
          'cardName': cardName,
          'interpretationSummary': interpretation.length > 200 
              ? '${interpretation.substring(0, 200)}...' 
              : interpretation,
          'previousMessages': messageHistory,
          'userMessage': userMessage,
          'spreadType': spreadType?.name,
        },
      );
      
      final response = result['response'] as String?;
      if (response == null || response.isEmpty) {
        throw Exception('응답을 생성하지 못했습니다.');
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
    return '''
[카드의 메시지]
$cardName 카드가 새로운 시각을 보여주고 있어요.

[현재 상황]
$userMood 기분은 변화의 신호입니다. 지금이 전환점이에요.

[실천 조언]
• 오늘은 평소와 다른 선택을 해보세요
• 마음이 가는 사람과 대화를 나누세요
• 작은 목표 하나를 정해서 시작하세요

[앞으로의 전망]
2-3주 안에 긍정적인 변화를 느낄 수 있을 거예요.
''';
  }
  
  /// 스프레드 폴백 해석
  String _getSpreadFallback(
    SpreadType type, 
    List<TarotCardModel> cards, 
    String userMood,
  ) {
    switch (type) {
      case SpreadType.threeCard:
        return _getThreeCardFallback(cards, userMood);
      case SpreadType.yesNo:
        return _getYesNoFallback(cards, userMood);
      case SpreadType.relationship:
        return _getRelationshipFallback(cards, userMood);
      case SpreadType.celticCross:
        return _getCelticCrossFallback(cards, userMood);
      default:
        return _getGenericFallback(cards, userMood);
    }
  }
  
  /// 쓰리카드 폴백
  String _getThreeCardFallback(List<TarotCardModel> cards, String userMood) {
    return '''
[전체 흐름]
과거에서 현재로, 그리고 미래로 이어지는 흐름이 보입니다.

[시간대별 해석]
• 과거: ${cards[0].nameKr} - 지나간 경험의 교훈
• 현재: ${cards[1].nameKr} - 지금 직면한 상황
• 미래: ${cards[2].nameKr} - 다가올 가능성

[행동 지침]
과거를 받아들이고, 현재에 집중하며, 미래를 준비하세요.

[핵심 조언]
$userMood 상태에서 가장 중요한 것은 현재의 선택입니다.
''';
  }
  
  /// 예/아니오 폴백
  String _getYesNoFallback(List<TarotCardModel> cards, String userMood) {
    // 긍정적인 카드 카운트 (간단한 로직)
    final positiveCount = cards.where((c) => 
      c.name.contains('Sun') || c.name.contains('Star') || 
      c.name.contains('World') || c.name.contains('Ace')
    ).length;
    
    final answer = positiveCount >= 3 ? '⭕ 예' : 
                   positiveCount >= 2 ? '⚠️ 조건부 예' : '❌ 아니오';
    
    return '''
[최종 답변]
$answer

[판단 근거]
• 긍정 신호: $positiveCount장
• 주의 신호: ${5 - positiveCount}장

[핵심 메시지]
${cards[0].nameKr} 카드가 중요한 열쇠를 쥐고 있습니다.

[성공 조건]
신중한 준비와 적절한 타이밍이 필요합니다.

[시기 예측]
${positiveCount >= 3 ? '1-2주' : '1-2개월'} 내 결과 확인

[행동 가이드]
결과와 관계없이 최선을 다해 준비하세요.
''';
  }
  
  /// 관계 폴백
  String _getRelationshipFallback(List<TarotCardModel> cards, String userMood) {
    return '''
[두 사람의 에너지]
• 당신: ${cards[0].nameKr} - 관계에서 중요한 역할
• 상대: ${cards[1].nameKr} - 상대방의 현재 상태

[마음의 온도차]
서로의 마음에 온도차가 있지만, 이해할 수 있습니다.

[관계의 걸림돌]
${cards[5].nameKr}가 보여주는 도전 과제가 있네요.

[미래 가능성]
노력한다면 60% 이상의 발전 가능성이 있습니다.

[사랑을 위한 조언]
대화와 이해, 그리고 시간이 필요합니다.

[한 줄 조언]
💕 사랑은 서로를 비추는 거울과 같아요.
''';
  }
  
  /// 켈틱 크로스 폴백
  String _getCelticCrossFallback(List<TarotCardModel> cards, String userMood) {
    return '''
[핵심 상황 분석]
${cards.length}장의 카드가 복잡한 상황을 보여주고 있습니다.

[내면의 갈등]
의식과 무의식 사이에 갈등이 있네요.

[시간축 분석]
과거의 영향이 현재까지 이어지고 있습니다.

[외부 요인]
주변 환경이 중요한 영향을 미치고 있어요.

[최종 전망]
긍정적인 변화의 가능성이 70% 정도 보입니다.

[단계별 실천 계획]
1. 이번 주: 상황 정리하기
2. 이번 달: 구체적 행동 시작
3. 3개월 후: 결과 확인

$userMood 상태를 극복할 수 있는 힘이 당신 안에 있습니다.
''';
  }
  
  /// 일반 폴백
  String _getGenericFallback(List<TarotCardModel> cards, String userMood) {
    return '''
[카드의 메시지]
${cards.length}장의 카드가 하나의 이야기를 만들고 있습니다.

[현재 상황]
${cards[0].nameKr} 카드가 현재의 핵심을 보여줍니다.

[실천 조언]
• 상황을 객관적으로 바라보세요
• 작은 변화부터 시작하세요
• 주변의 도움을 받아보세요

[앞으로의 전망]
$userMood 상태가 곧 개선될 조짐이 보입니다.
''';
  }
  
  /// 채팅 폴백 응답
  String _getChatFallbackResponse(String cardName, String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('언제') || lowerMessage.contains('시기')) {
      return '타로가 보여주는 시기는 보통 1-3개월 사이예요. $cardName 카드의 에너지로 보면 조금 더 빠를 수도 있어요. 준비가 되었을 때가 가장 좋은 시기랍니다.';
    } else if (lowerMessage.contains('어떻게') || lowerMessage.contains('방법')) {
      return '$cardName 카드는 직관을 따르라고 하네요. 너무 복잡하게 생각하지 말고, 마음이 이끄는 대로 한 걸음씩 나아가 보세요. 작은 시작이 큰 변화를 만들어요.';
    } else if (lowerMessage.contains('왜') || lowerMessage.contains('이유')) {
      return '그 이유는 $cardName 카드가 암시하듯이, 지금이 변화의 시점이기 때문이에요. 과거의 패턴을 벗어나 새로운 가능성을 열어갈 때입니다.';
    } else {
      return '좋은 질문이에요. $cardName 카드의 관점에서 보면, 지금은 신중하면서도 용기있게 나아갈 때예요. 어떤 부분이 가장 궁금하신가요?';
    }
  }
}