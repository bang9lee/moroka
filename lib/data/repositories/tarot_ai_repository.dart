import '../services/gemini_service.dart';
import '../models/tarot_card_model.dart';
import '../models/chat_message_model.dart';

class TarotAIRepository {
  final GeminiService _geminiService;
  
  TarotAIRepository(this._geminiService);
  
  Future<String> getCardInterpretation({
    required TarotCardModel card,
    required String userMood,
    String language = 'en',
  }) async {
    try {
      return await _geminiService.generateTarotInterpretation(
        cardName: card.name,
        userMood: userMood,
        language: language,
      );
    } catch (e) {
      throw Exception('Failed to get card interpretation: $e');
    }
  }
  
  Future<String> getChatResponse({
    required String cardName,
    required String interpretation,
    required List<ChatMessageModel> previousMessages,
    required String userMessage,
    String language = 'en',
  }) async {
    try {
      return await _geminiService.generateChatResponse(
        cardName: cardName,
        interpretation: interpretation,
        previousMessages: previousMessages,
        userMessage: userMessage,
        language: language,
      );
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }
}