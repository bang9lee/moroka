import 'dart:convert';
import 'package:flutter/services.dart';
import 'tarot_card_model.dart';
import '../../core/utils/app_logger.dart';

/// 타로 카드 데이터 관리 클래스
/// 78장의 카드 데이터를 JSON으로 관리하여 메모리 효율성 향상
class TarotCardData {
  static TarotCardData? _instance;
  static List<TarotCardModel>? _cachedCards;
  static Map<int, TarotCardModel>? _cardMap;

  TarotCardData._();

  static TarotCardData get instance {
    _instance ??= TarotCardData._();
    return _instance!;
  }

  /// 전체 카드 덱 가져오기 (lazy loading)
  Future<List<TarotCardModel>> getFullDeck() async {
    if (_cachedCards != null) {
      return _cachedCards!;
    }

    try {
      // JSON 파일에서 카드 데이터 로드
      final String jsonString = await rootBundle.loadString('assets/data/tarot_cards.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      
      _cachedCards = jsonData.map((cardJson) => TarotCardModel.fromJson(cardJson)).toList();
      
      // ID로 빠른 검색을 위한 맵 생성
      _cardMap = {
        for (var card in _cachedCards!) card.id: card
      };
      
      return _cachedCards!;
    } catch (e) {
      // 에러 발생 시 빈 리스트 반환
      AppLogger.error('Error loading tarot cards', e);
      return [];
    }
  }

  /// ID로 카드 찾기 (효율적인 검색)
  Future<TarotCardModel?> getCardById(int id) async {
    if (_cardMap == null) {
      await getFullDeck();
    }
    return _cardMap?[id];
  }

  /// 이름으로 카드 찾기
  Future<TarotCardModel?> getCardByName(String name) async {
    final cards = await getFullDeck();
    try {
      return cards.firstWhere(
        (card) => card.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// 특정 슈트의 카드들 가져오기
  Future<List<TarotCardModel>> getCardsBySuit(CardSuit suit) async {
    final cards = await getFullDeck();
    return cards.where((card) => card.suit == suit).toList();
  }

  /// 메이저 아르카나만 가져오기
  Future<List<TarotCardModel>> getMajorArcana() async {
    return getCardsBySuit(CardSuit.major);
  }

  /// 마이너 아르카나만 가져오기
  Future<List<TarotCardModel>> getMinorArcana() async {
    final cards = await getFullDeck();
    return cards.where((card) => card.suit != CardSuit.major).toList();
  }

  /// 코트 카드만 가져오기
  Future<List<TarotCardModel>> getCourtCards() async {
    final cards = await getFullDeck();
    return cards.where((card) => card.isCourtCard).toList();
  }

  /// 메모리 캐시 클리어
  void clearCache() {
    _cachedCards = null;
    _cardMap = null;
  }
}