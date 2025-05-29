import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/chat_message_model.dart';
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
          maxOutputTokens: 1024,
        ),
      );
      
      AppLogger.debug("Gemini model initialized successfully");
    } catch (e) {
      AppLogger.error("Failed to initialize Gemini model", e);
      rethrow;
    }
  }
  
  // Generate initial tarot interpretation
  Future<String> generateTarotInterpretation({
    required String cardName,
    required String userMood,
  }) async {
    if (_model == null) {
      AppLogger.error("Gemini model is not initialized");
      throw Exception('Gemini model not initialized');
    }
    
    final prompt = '''
당신은 신비롭고 지혜로운 타로 카드 리더입니다. 
사용자가 뽑은 카드를 해석하되, 신비로운 분위기를 유지하면서도 희망적인 메시지를 전달해주세요.

사용자의 현재 기분: $userMood
뽑은 카드: $cardName

이 카드가 가진 깊은 의미와 상징을 설명하되, 다음 규칙을 따라주세요:
- 신비롭고 은유적인 표현을 사용하되, 극단적이거나 부정적인 내용은 피하세요
- 사용자에게 통찰과 성찰의 기회를 제공하세요
- 미래에 대한 가능성과 잠재력을 암시하세요
- 절대 자해, 극단적 선택, 절망적인 내용을 포함하지 마세요
- 한국어로 3-4문단으로 작성하되, 시적이고 아름다운 표현을 사용하세요
''';

    try {
      AppLogger.debug("Generating tarot interpretation for $cardName");
      
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception('Empty response from Gemini');
      }
      
      AppLogger.debug("Generated interpretation: ${text.length > 50 ? text.substring(0, 50) : text}...");
      return text;
    } catch (e) {
      AppLogger.error("Failed to generate tarot interpretation", e);
      
      // Return a fallback interpretation
      return '''
운명의 카드가 베일을 벗었습니다...

$cardName 카드는 당신의 현재 $userMood 상태와 깊은 공명을 이루고 있네요.

이 카드는 변화와 성장의 시기를 암시합니다. 
지금의 어려움은 더 나은 미래를 위한 준비 과정일 수 있습니다.

내면의 목소리에 귀를 기울이고, 당신만의 길을 찾아가세요...
''';
    }
  }
  
  // Generate AI chat response
  Future<String> generateChatResponse({
    required String cardName,
    required String interpretation,
    required List<ChatMessageModel> previousMessages,
    required String userMessage,
  }) async {
    if (_model == null) {
      AppLogger.error("Gemini model is not initialized");
      throw Exception('Gemini model not initialized');
    }
    
    // Build conversation history
    final conversationHistory = previousMessages
        .map((msg) => '${msg.isUser ? "사용자" : "AI"}: ${msg.message}')
        .join('\n');
    
    final prompt = '''
당신은 신비롭고 지혜로운 타로 카드 리더입니다.
사용자와 대화를 이어가되, 신비로운 분위기를 유지하면서도 건설적인 조언을 제공하세요.

뽑은 카드: $cardName
초기 해석: $interpretation

이전 대화:
$conversationHistory

사용자의 새로운 메시지: $userMessage

위 정보를 바탕으로 사용자의 질문이나 반응에 대해 답변하세요.
- 지혜롭고 통찰력 있는 어조 사용
- 은유적이고 시적인 표현 사용
- 사용자가 스스로 답을 찾을 수 있도록 안내
- 절대 극단적이거나 위험한 내용 포함 금지
- 2-3문장으로 간결하게 답변
- 한국어로 답변
''';

    try {
      AppLogger.debug("Generating chat response");
      
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception('Empty response from Gemini');
      }
      
      AppLogger.debug("Generated response: ${text.length > 50 ? text.substring(0, 50) : text}...");
      return text;
    } catch (e) {
      AppLogger.error("Failed to generate chat response", e);
      
      // Return a fallback response
      return '흥미로운 질문이네요. 때로는 우리가 찾는 답이 이미 우리 안에 있을 때가 있습니다. 당신의 직감은 무엇을 말하고 있나요?';
    }
  }
}