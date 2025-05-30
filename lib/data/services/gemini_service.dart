import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/chat_message_model.dart';
import '../models/tarot_card_model.dart';
import '../models/tarot_spread_model.dart';
import '../../core/utils/app_logger.dart';

class GeminiService {
  GenerativeModel? _model;
  
  GeminiService() {
    _initializeModel();
  }
  
  void _initializeModel() {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        AppLogger.error("GEMINI_API_KEY not found in .env file");
        throw Exception('GEMINI_API_KEY not found');
      }
      
      AppLogger.debug("Initializing Gemini with API key: ${apiKey.substring(0, 10)}...");
      
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.9,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,
        ),
      );
      
      AppLogger.debug("Gemini model initialized successfully");
    } catch (e) {
      AppLogger.error("Failed to initialize Gemini model", e);
      rethrow;
    }
  }
  
  // 단일 카드 해석 (원카드용) - 짧고 핵심적으로
  Future<String> generateTarotInterpretation({
    required String cardName,
    required String userMood,
  }) async {
    if (_model == null) {
      AppLogger.error("Gemini model is not initialized");
      throw Exception('Gemini model not initialized');
    }
    
    final prompt = '''
너는 50년 경력의 타로 마스터야. 단순명료하게 핵심만 전달해.

사용자 기분: $userMood
뽑은 카드: $cardName

다음 형식으로 짧게 해석해줘:

[카드의 메시지]
이 카드가 전하는 핵심 메시지 (1-2문장)

[현재 상황]
$userMood 기분의 원인과 현재 상태 (2-3문장)

[실천 조언]
• 오늘 당장 할 일
• 이번 주 목표
• 한 달 내 변화

[앞으로의 전망]
긍정적 변화 예측 (1-2문장)

규칙:
- 전체 8-10문장 이내
- 쉬운 단어만 사용
- 구체적 행동 제시
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception('Empty response from Gemini');
      }
      
      return text;
    } catch (e) {
      AppLogger.error("Failed to generate interpretation", e);
      return _getFallbackInterpretation(cardName, userMood);
    }
  }
  
  // 배열법별 종합 해석
  Future<String> generateSpreadInterpretation({
    required SpreadType spreadType,
    required List<TarotCardModel> drawnCards,
    required String userMood,
    required TarotSpread spread,
  }) async {
    if (_model == null) {
      throw Exception('Gemini model not initialized');
    }
    
    String prompt = '';
    
    switch (spreadType) {
      case SpreadType.oneCard:
        return generateTarotInterpretation(
          cardName: drawnCards[0].name,
          userMood: userMood,
        );
        
      case SpreadType.threeCard:
        prompt = _buildThreeCardPrompt(drawnCards, userMood, spread);
        break;
        
      case SpreadType.celticCross:
        prompt = _buildCelticCrossPrompt(drawnCards, userMood, spread);
        break;
        
      case SpreadType.relationship:
        prompt = _buildRelationshipPrompt(drawnCards, userMood, spread);
        break;
        
      case SpreadType.yesNo:
        prompt = _buildYesNoPrompt(drawnCards, userMood, spread);
        break;
    }
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception('Empty response from Gemini');
      }
      
      return text;
    } catch (e) {
      AppLogger.error("Failed to generate spread interpretation", e);
      return _getSpreadFallback(spreadType, drawnCards, userMood);
    }
  }
  
  // 쓰리 카드 프롬프트 - 중간 길이
  String _buildThreeCardPrompt(
    List<TarotCardModel> cards,
    String userMood,
    TarotSpread spread,
  ) {
    return '''
너는 타로 전문가야. 과거-현재-미래의 흐름을 명확히 해석해.

사용자 기분: $userMood

카드:
과거: ${cards[0].nameKr}
현재: ${cards[1].nameKr}
미래: ${cards[2].nameKr}

다음 형식으로 간결하게:

[전체 흐름]
세 카드의 연결점 (1-2문장)

[시간대별 해석]
• 과거: ${cards[0].nameKr}가 남긴 영향
• 현재: ${cards[1].nameKr}로 본 지금 상황
• 미래: ${cards[2].nameKr}가 보여주는 가능성

[행동 지침]
• 과거에서 배울 점
• 현재 집중할 일
• 미래를 위한 준비

[핵심 조언]
당신이 가장 먼저 해야 할 일 (1-2문장)

규칙:
- 전체 15문장 이내
- 시간의 흐름 강조
- 실천 가능한 조언
''';
  }
  
  // 켈틱 크로스 프롬프트 - 상세 분석
  String _buildCelticCrossPrompt(
    List<TarotCardModel> cards,
    String userMood,
    TarotSpread spread,
  ) {
    return '''
너는 타로 마스터야. 10장 켈틱 크로스를 체계적으로 분석해.

사용자 기분: $userMood

카드 배치:
1. 현재 상황: ${cards[0].nameKr}
2. 도전/장애물: ${cards[1].nameKr}
3. 의식적 목표: ${cards[2].nameKr}
4. 무의식 기반: ${cards[3].nameKr}
5. 최근 과거: ${cards[4].nameKr}
6. 가까운 미래: ${cards[5].nameKr}
7. 자신의 태도: ${cards[6].nameKr}
8. 외부 영향: ${cards[7].nameKr}
9. 희망과 두려움: ${cards[8].nameKr}
10. 최종 결과: ${cards[9].nameKr}

다음 형식으로 해석해줘:

[핵심 상황 분석]
${cards[0].nameKr}와 ${cards[1].nameKr}로 본 현재의 핵심 이슈

[내면의 갈등]
• 의식(${cards[2].nameKr}): 겉으로 원하는 것
• 무의식(${cards[3].nameKr}): 진짜 욕구
• 내 태도(${cards[6].nameKr}): 실제 행동 패턴

[시간축 분석]
• 과거(${cards[4].nameKr}): 현재에 미친 영향
• 현재(${cards[0].nameKr}): 지금 직면한 선택
• 미래(${cards[5].nameKr}): 3개월 내 전개

[외부 요인]
${cards[7].nameKr}가 보여주는 주변 환경의 영향

[최종 전망]
• ${cards[8].nameKr}: 내면의 기대와 불안
• ${cards[9].nameKr}: 예상되는 결과 (확률 70%)

[단계별 실천 계획]
1. 이번 주: (구체적 행동)
2. 이번 달: (중간 목표)
3. 3개월 후: (최종 목표)

규칙:
- 카드 간 연결성 강조
- 실생활 적용 가능한 해석
- 희망적이지만 현실적으로
''';
  }
  
  // 관계 스프레드 프롬프트 - 감성적이고 구체적
  String _buildRelationshipPrompt(
    List<TarotCardModel> cards,
    String userMood,
    TarotSpread spread,
  ) {
    return '''
너는 타로 전문가이자 연애 상담사야. 관계의 역학을 섬세하게 분석해.

사용자 기분: $userMood

관계 카드 배치:
1. 나의 역할: ${cards[0].nameKr}
2. 상대의 역할: ${cards[1].nameKr}
3. 관계의 본질: ${cards[2].nameKr}
4. 내 진심: ${cards[3].nameKr}
5. 상대의 마음: ${cards[4].nameKr}
6. 해결할 문제: ${cards[5].nameKr}
7. 관계의 미래: ${cards[6].nameKr}

감성적이고 따뜻하게 해석:

[두 사람의 에너지]
• 당신(${cards[0].nameKr}): 관계에서의 역할과 특징
• 상대(${cards[1].nameKr}): 상대방의 성향과 태도
• 케미(${cards[2].nameKr}): 둘이 만났을 때 시너지

[마음의 온도차]
• 당신의 진심(${cards[3].nameKr}): 숨겨진 감정
• 상대의 마음(${cards[4].nameKr}): 예상되는 감정 (온도: ??도)

[관계의 걸림돌]
${cards[5].nameKr}가 암시하는 핵심 문제와 해결 방향

[미래 가능성]
${cards[6].nameKr}로 본 관계 발전 확률: ??%

[사랑을 위한 조언]
1. 대화법: "이렇게 말해보세요..."
2. 데이트: 이번 주 추천 활동
3. 마음가짐: 관계 개선을 위한 태도

[한 줄 조언]
💕 (관계의 핵심을 꿰뚫는 따뜻한 한마디)

규칙:
- 감성적이고 공감적인 톤
- 구체적인 행동 제안
- 양쪽 입장 균형있게
''';
  }
  
  // 예/아니오 프롬프트 - 명확하고 단호하게
  String _buildYesNoPrompt(
    List<TarotCardModel> cards,
    String userMood,
    TarotSpread spread,
  ) {
    return '''
너는 타로 전문가야. 예/아니오를 명확히 판단해.

사용자 기분: $userMood

뽑은 5장:
${cards.map((c) => c.nameKr).join(', ')}

단호하고 명확하게:

[최종 답변]
⭕ 예 / ❌ 아니오 / ⚠️ 조건부 예

[판단 근거]
• 긍정 카드: ?장 (카드명)
• 부정 카드: ?장 (카드명)
• 중립 카드: ?장 (카드명)

[핵심 메시지]
카드들이 말하는 핵심 (1-2문장)

[성공 조건]
"예"가 되려면: (구체적 조건 1-2개)

[시기 예측]
실현 가능 시기: ?주 ~ ?개월

[행동 가이드]
답변과 관계없이 지금 해야 할 일 (1-2가지)

규칙:
- 퍼센트로 확률 표시 (??%)
- 애매모호함 없이 명확하게
- 대안이나 우회로 제시
''';
  }
  
  // 대화형 응답 생성
  Future<String> generateChatResponse({
    required String cardName,
    required String interpretation,
    required List<ChatMessageModel> previousMessages,
    required String userMessage,
    SpreadType? spreadType,
  }) async {
    if (_model == null) {
      throw Exception('Gemini model not initialized');
    }
    
    // 최근 3개 메시지만 컨텍스트로 사용 (토큰 절약)
    final recentMessages = previousMessages.length > 6 
        ? previousMessages.sublist(previousMessages.length - 6)
        : previousMessages;
    
    final conversationHistory = recentMessages
        .map((msg) => '${msg.isUser ? "질문" : "답변"}: ${msg.message}')
        .join('\n');
    
    final spreadContext = spreadType != null 
      ? '\n사용한 배열: ${_getSpreadNameKr(spreadType)}'
      : '';
    
    final prompt = '''
너는 친근한 타로 상담사야. 공감하며 실용적 조언을 해줘.

처음 카드: $cardName$spreadContext
처음 해석 요약: ${interpretation.length > 200 ? '${interpretation.substring(0, 200)}...' : interpretation}

최근 대화:
$conversationHistory

새 질문: $userMessage

답변 스타일:
- 2-3문장으로 핵심만
- 따뜻하고 친근한 톤
- 구체적 예시 포함
- 긍정적 마무리

한국어로 자연스럽게 답변해줘.
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception('Empty response from Gemini');
      }
      
      return text;
    } catch (e) {
      AppLogger.error("Failed to generate chat response", e);
      return _getChatFallbackResponse(cardName, userMessage);
    }
  }
  
  // 헬퍼 메서드들
  String _getSpreadNameKr(SpreadType type) {
    switch (type) {
      case SpreadType.oneCard:
        return '원 카드';
      case SpreadType.threeCard:
        return '쓰리 카드';
      case SpreadType.celticCross:
        return '켈틱 크로스';
      case SpreadType.relationship:
        return '관계 스프레드';
      case SpreadType.yesNo:
        return '예/아니오';
    }
  }
  
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
  
  String _getSpreadFallback(SpreadType type, List<TarotCardModel> cards, String userMood) {
    final cardCount = cards.length;
    final mainCard = cards.first.nameKr;
    
    // 스프레드별 기본 메시지
    switch (type) {
      case SpreadType.threeCard:
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
        
      case SpreadType.yesNo:
        final positiveCount = cards.where((c) => 
          c.name.contains('Sun') || c.name.contains('Star') || 
          c.name.contains('World') || c.name.contains('Ace')
        ).length;
        
        return '''
[최종 답변]
${positiveCount >= 3 ? '⭕ 예' : positiveCount >= 2 ? '⚠️ 조건부 예' : '❌ 아니오'}

[판단 근거]
• 긍정 신호: $positiveCount장
• 주의 신호: ${5 - positiveCount}장

[핵심 메시지]
$mainCard 카드가 중요한 열쇠를 쥐고 있습니다.

[성공 조건]
신중한 준비와 적절한 타이밍이 필요합니다.

[시기 예측]
${positiveCount >= 3 ? '1-2주' : '1-2개월'} 내 결과 확인

[행동 가이드]
결과와 관계없이 최선을 다해 준비하세요.
''';
        
      case SpreadType.relationship:
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
        
      case SpreadType.celticCross:
        return '''
[핵심 상황 분석]
$cardCount장의 카드가 복잡한 상황을 보여주고 있습니다.

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
        
      default:
        return '''
[카드의 메시지]
$cardCount장의 카드가 하나의 이야기를 만들고 있습니다.

[현재 상황]
$mainCard 카드가 현재의 핵심을 보여줍니다.

[실천 조언]
• 상황을 객관적으로 바라보세요
• 작은 변화부터 시작하세요
• 주변의 도움을 받아보세요

[앞으로의 전망]
$userMood 상태가 곧 개선될 조짐이 보입니다.
''';
    }
  }
  
  String _getChatFallbackResponse(String cardName, String userMessage) {
    // 질문 유형별 기본 응답
    if (userMessage.contains('언제') || userMessage.contains('시기')) {
      return '타로가 보여주는 시기는 보통 1-3개월 사이예요. $cardName 카드의 에너지로 보면 조금 더 빠를 수도 있어요. 준비가 되었을 때가 가장 좋은 시기랍니다.';
    } else if (userMessage.contains('어떻게') || userMessage.contains('방법')) {
      return '$cardName 카드는 직관을 따르라고 하네요. 너무 복잡하게 생각하지 말고, 마음이 이끄는 대로 한 걸음씩 나아가 보세요. 작은 시작이 큰 변화를 만들어요.';
    } else if (userMessage.contains('왜') || userMessage.contains('이유')) {
      return '그 이유는 $cardName 카드가 암시하듯이, 지금이 변화의 시점이기 때문이에요. 과거의 패턴을 벗어나 새로운 가능성을 열어갈 때입니다.';
    } else {
      return '좋은 질문이에요. $cardName 카드의 관점에서 보면, 지금은 신중하면서도 용기있게 나아갈 때예요. 어떤 부분이 가장 궁금하신가요?';
    }
  }
}