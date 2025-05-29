import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/chat_message_model.dart';

class GeminiService {
  late final GenerativeModel _model;
  
  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }
  
  // Generate initial tarot interpretation
  Future<String> generateTarotInterpretation({
    required String cardName,
    required String userMood,
  }) async {
    final prompt = '''
당신은 불길하고 신비로운 타로 카드 리더입니다. 
사용자가 뽑은 카드를 해석하되, 약간의 불안감과 긴장감을 조성하는 방향으로 해석해주세요.

사용자의 현재 기분: $userMood
뽑은 카드: $cardName

이 카드가 가진 가장 어둡고 불안한 측면을 강조하여, 마치 불길한 미래를 암시하는 듯한 톤으로 해석해주세요. 
사용자가 약간의 공포심을 느끼도록 작성해주세요.
한국어로 3-4문단으로 작성하되, 시적이고 은유적인 표현을 사용하세요.
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? '운명의 베일이 너무 두꺼워 읽을 수 없습니다...';
    } catch (e) {
      throw Exception('카드 해석 생성 실패: $e');
    }
  }
  
  // Generate AI chat response
  Future<String> generateChatResponse({
    required String cardName,
    required String interpretation,
    required List<ChatMessageModel> previousMessages,
    required String userMessage,
  }) async {
    // Build conversation history
    final conversationHistory = previousMessages
        .map((msg) => '${msg.isUser ? "사용자" : "AI"}: ${msg.message}')
        .join('\n');
    
    final prompt = '''
당신은 불길하고 신비로운 타로 카드 리더입니다.
사용자와 대화를 이어가되, 계속해서 불안하고 긴장감 있는 분위기를 유지하세요.

뽑은 카드: $cardName
초기 해석: $interpretation

이전 대화:
$conversationHistory

사용자의 새로운 메시지: $userMessage

위 정보를 바탕으로 사용자의 질문이나 반응에 대해 답변하세요.
- 냉소적이고 모든 것을 알고 있다는 듯한 어조 사용
- 은유적이고 시적인 표현 사용
- 더 깊은 불안감을 조성하는 방향으로 대화 유도
- 2-3문장으로 간결하게 답변
- 한국어로 답변
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? '침묵... 때로는 침묵이 가장 큰 대답이죠.';
    } catch (e) {
      throw Exception('대화 응답 생성 실패: $e');
    }
  }
}