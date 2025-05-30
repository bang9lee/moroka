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
  
  // 단일 카드 해석 (원카드용)
  Future<String> generateTarotInterpretation({
    required String cardName,
    required String userMood,
  }) async {
    if (_model == null) {
      AppLogger.error("Gemini model is not initialized");
      throw Exception('Gemini model not initialized');
    }
    
    final prompt = '''
너는 100년 경력의 타로 전문가야. 복잡한 상징을 일상 언어로 쉽게 풀어주는 전문가지.

사용자 기분: $userMood
뽑은 카드: $cardName

다음 형식으로 짧고 명확하게 해석해줘:

[카드의 메시지]
이 카드가 지금 당신에게 전하는 가장 중요한 한 마디

[현재 상황]
당신의 $userMood 기분과 연결해서, 지금 어떤 상황인지 구체적으로 설명

[실천 조언]
• 오늘부터 당장 할 수 있는 구체적인 행동
• 두 번째 실천 가능한 조언
• 세 번째 구체적인 행동

[앞으로의 전망]
이 조언을 따르면 어떤 긍정적 변화가 있을지

규칙:
- 쉬운 일상 언어로 써줘
- "우주", "운명", "베일" 같은 추상적 단어 쓰지 마
- 구체적이고 실용적인 조언 위주로
- 희망적이지만 현실적으로
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
  
  // 쓰리 카드 프롬프트
  String _buildThreeCardPrompt(
    List<TarotCardModel> cards,
    String userMood,
    TarotSpread spread,
  ) {
    return '''
너는 100년 경력의 타로 전문가야. 복잡한 카드 조합을 쉽게 설명하는 전문가지.

사용자 기분: $userMood
배열: 과거-현재-미래

카드:
과거: ${cards[0].nameKr} - ${cards[0].keywords.join(', ')}
현재: ${cards[1].nameKr} - ${cards[1].keywords.join(', ')}
미래: ${cards[2].nameKr} - ${cards[2].keywords.join(', ')}

다음 형식으로 해석해줘:

[전체 흐름]
세 카드가 보여주는 큰 그림을 한 문장으로 요약

[과거의 영향]
${cards[0].nameKr} 카드가 말하는 과거가 현재에 미친 구체적 영향

[현재 상황]
${cards[1].nameKr} 카드로 본 지금 상황과 $userMood 기분의 원인

[다가올 미래]
${cards[2].nameKr} 카드가 보여주는 구체적인 변화와 가능성

[행동 지침]
• 과거에서 배울 점: 구체적 교훈
• 현재 해야 할 일: 당장 실천할 행동
• 미래를 위한 준비: 장기적 계획

규칙:
- 카드 이름과 키워드를 활용해 구체적으로
- 추상적 표현 없이 일상적인 언어로
- 실생활에 적용 가능한 조언으로
''';
  }
  
  // 켈틱 크로스 프롬프트
  String _buildCelticCrossPrompt(
    List<TarotCardModel> cards,
    String userMood,
    TarotSpread spread,
  ) {
    return '''
너는 100년 경력의 타로 전문가야. 10장 켈틱 크로스를 체계적으로 분석하는 전문가지.

사용자 기분: $userMood

카드 배치:
1. 현재: ${cards[0].nameKr}
2. 도전: ${cards[1].nameKr}
3. 목표: ${cards[2].nameKr}
4. 기반: ${cards[3].nameKr}
5. 과거: ${cards[4].nameKr}
6. 미래: ${cards[5].nameKr}
7. 나: ${cards[6].nameKr}
8. 환경: ${cards[7].nameKr}
9. 희망/두려움: ${cards[8].nameKr}
10. 결과: ${cards[9].nameKr}

다음 구조로 핵심만 해석해줘:

**핵심 상황** (2줄)
1번과 2번 카드로 본 현재 상황과 주요 갈등

**내면 vs 외면** (3줄)
- 의식(3번): 당신이 원하는 것
- 무의식(4번): 진짜 동기
- 내 상태(7번): 실제 모습

**시간의 흐름** (3줄)
- 과거(5번): 여기까지 온 이유
- 현재(1번): 지금 선택해야 할 것
- 미래(6번): 3개월 내 일어날 일

**주변 영향** (2줄)
8번 환경 카드가 보여주는 도움/방해 요소

**최종 전망** (2줄)
9번과 10번으로 본 가능한 결과와 확률

**실천 계획** (3줄)
1. 즉시: (이번 주 할 일)
2. 단기: (한 달 내 목표)
3. 장기: (3개월 계획)

규칙:
- 각 카드의 키워드를 실생활과 연결
- 복잡한 해석보다 명확한 방향 제시
- 긍정적이지만 현실적으로
''';
  }
  
  // 관계 스프레드 프롬프트
  String _buildRelationshipPrompt(
    List<TarotCardModel> cards,
    String userMood,
    TarotSpread spread,
  ) {
    return '''
너는 100년 경력의 타로 전문가이자 관계 상담사야.

사용자 기분: $userMood

관계 카드:
1. 나: ${cards[0].nameKr}
2. 상대: ${cards[1].nameKr}
3. 관계: ${cards[2].nameKr}
4. 내 마음: ${cards[3].nameKr}
5. 상대 마음: ${cards[4].nameKr}
6. 문제점: ${cards[5].nameKr}
7. 가능성: ${cards[6].nameKr}

다음 형식으로 명확하게 해석해줘:

**관계 현황** (2줄)
3번 카드로 본 두 사람 사이의 현재 상태

**서로의 모습** (3줄)
- 당신: ${cards[0].nameKr}의 특징
- 상대: ${cards[1].nameKr}의 특징
- 만나면: 어떤 화학작용이 일어나는지

**감정 온도** (2줄)
- 당신 마음(${cards[3].nameKr}): 솔직한 감정 상태
- 상대 마음(${cards[4].nameKr}): 예상되는 감정

**해결할 점** (2줄)
6번 ${cards[5].nameKr}가 보여주는 구체적 문제와 원인

**발전 가능성** (2줄)
7번 ${cards[6].nameKr}로 본 관계의 미래 (확률 %로 표현)

**행동 조언** (3줄)
1. 대화법: (구체적 대화 예시)
2. 행동: (이번 주 할 수 있는 것)
3. 마음가짐: (관계 개선을 위한 태도)

규칙:
- 연애 상담하듯 친근하고 현실적으로
- 막연한 희망보다 실용적 조언
- 양쪽 입장 공평하게 다루기
''';
  }
  
  // 예/아니오 프롬프트
  String _buildYesNoPrompt(
    List<TarotCardModel> cards,
    String userMood,
    TarotSpread spread,
  ) {
    return '''
너는 100년 경력의 타로 전문가야. 명확한 답변을 주는 전문가지.

사용자 기분: $userMood

5장의 카드:
${cards.map((c) => c.nameKr).join(', ')}

다음 형식으로 짧고 명확하게:

**답변: [예/아니오/조건부 예]** 

**이유** (2줄)
5장 중 긍정 카드 X장, 부정 카드 Y장으로 판단

**조건** (2-3줄)
"예"가 되려면: (구체적 조건)
"아니오"인 이유: (현재 문제점)

**시기** (1줄)
가능한 시기: (구체적 기간)

**조언** (2줄)
결과와 상관없이 해야 할 일

규칙:
- 애매하게 말하지 말고 명확하게
- 퍼센트로 가능성 표현하기
- 실용적 대안 제시하기
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
    
    final conversationHistory = previousMessages
        .map((msg) => '${msg.isUser ? "질문" : "답변"}: ${msg.message}')
        .join('\n');
    
    final spreadContext = spreadType != null 
      ? '\n사용한 배열: ${_getSpreadNameKr(spreadType)}'
      : '';
    
    final prompt = '''
너는 100년 경력의 타로 전문가야. 친근한 상담사처럼 대화해.

처음 카드: $cardName$spreadContext
처음 해석: $interpretation

대화 기록:
$conversationHistory

새 질문: $userMessage

답변 규칙:
- 2-3문장으로 간단명료하게
- 타로 지식 + 실용적 조언
- 친구처럼 편하게 대화
- 구체적 예시 들어주기
- 추가 질문 유도하기

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
      return '좋은 질문이네요. $cardName 카드의 관점에서 보면, 지금 상황에서는 조금 더 신중하게 접근하는 것이 좋겠어요. 어떤 부분이 가장 걱정되시나요?';
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
**카드의 메시지**
$cardName 카드가 당신에게 새로운 시각을 제시하고 있습니다.

**현재 상황**
$userMood 기분이 드는 것은 자연스러운 일입니다. 
이 카드는 지금이 변화의 시점임을 알려줍니다.

**실천 조언**
- 오늘 하루는 평소와 다른 길로 걸어보세요
- 믿을 만한 사람과 대화를 나누세요
- 작은 목표 하나를 정해 실천해보세요

**앞으로의 전망**
한 걸음씩 나아가면 2-3주 내에 긍정적인 변화를 느낄 수 있을 거예요.
''';
  }
  
  String _getSpreadFallback(SpreadType type, List<TarotCardModel> cards, String userMood) {
    final cardNames = cards.map((c) => c.nameKr).join(', ');
    return '''
**${_getSpreadNameKr(type)} 해석**

뽑으신 카드: $cardNames

이 카드들의 조합이 $userMood 상태의 당신에게 전하는 메시지입니다.

각 카드가 서로 연결되어 하나의 이야기를 만들고 있네요.
특히 주목할 점은 ${cards.first.nameKr} 카드가 시작점을 제시하고 있다는 것입니다.

구체적인 조언:
- 현재 상황을 있는 그대로 받아들이세요
- 작은 변화부터 시작해보세요
- 주변 사람들과 소통을 늘려보세요

이 카드들은 모두 긍정적인 변화의 가능성을 보여주고 있습니다.
''';
  }
}