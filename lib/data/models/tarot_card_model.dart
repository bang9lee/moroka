import 'tarot_card_data.dart';
import 'tarot_card_localizations.dart';

enum CardSuit {
  major,
  wands,
  cups,
  swords,
  pentacles,
}

enum CourtCard {
  none,
  page,
  knight,
  queen,
  king,
}

class TarotCardModel {
  final int id;
  final String name;
  final String nameKr;
  final String imagePath;
  final CardSuit suit;
  final int? number; // 1-14 for minor, 0-21 for major
  final CourtCard courtCard;
  final List<String> keywords;
  final String element;
  final List<String> uprightMeanings;
  final List<String> reversedMeanings;
  
  TarotCardModel({
    required this.id,
    required this.name,
    required this.nameKr,
    required this.imagePath,
    required this.suit,
    this.number,
    this.courtCard = CourtCard.none,
    required this.keywords,
    required this.element,
    required this.uprightMeanings,
    required this.reversedMeanings,
  });
  
  bool get isMajor => suit == CardSuit.major;
  bool get isMinor => !isMajor;
  bool get isCourtCard => courtCard != CourtCard.none;
  
  // 카드 설명 속성 추가
  String get description => '$nameKr ($name)';
  String get briefDescription => keywords.take(3).join(', ');
  
  // 현재 로케일에 따른 카드 이름 반환
  String getLocalizedName(String locale) {
    switch (locale) {
      case 'ko':
        return nameKr;
      case 'en':
        return name;
      default:
        // Use TarotCardLocalizations for other languages
        return TarotCardLocalizations.getLocalizedCardName(name, locale);
    }
  }

  // JSON 직렬화/역직렬화
  factory TarotCardModel.fromJson(Map<String, dynamic> json) {
    return TarotCardModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameKr: json['nameKr'] as String,
      imagePath: json['imagePath'] as String,
      suit: _parseSuit(json['suit'] as String),
      number: json['number'] as int?,
      courtCard: _parseCourtCard(json['courtCard'] as String?),
      keywords: List<String>.from(json['keywords'] as List),
      element: json['element'] as String,
      uprightMeanings: List<String>.from(json['uprightMeanings'] as List),
      reversedMeanings: List<String>.from(json['reversedMeanings'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameKr': nameKr,
      'imagePath': imagePath,
      'suit': suit.name,
      'number': number,
      'courtCard': courtCard == CourtCard.none ? null : courtCard.name,
      'keywords': keywords,
      'element': element,
      'uprightMeanings': uprightMeanings,
      'reversedMeanings': reversedMeanings,
    };
  }

  static CardSuit _parseSuit(String suit) {
    switch (suit) {
      case 'major':
        return CardSuit.major;
      case 'wands':
        return CardSuit.wands;
      case 'cups':
        return CardSuit.cups;
      case 'swords':
        return CardSuit.swords;
      case 'pentacles':
        return CardSuit.pentacles;
      default:
        throw ArgumentError('Invalid suit: $suit');
    }
  }

  static CourtCard _parseCourtCard(String? courtCard) {
    if (courtCard == null) return CourtCard.none;
    switch (courtCard) {
      case 'page':
        return CourtCard.page;
      case 'knight':
        return CourtCard.knight;
      case 'queen':
        return CourtCard.queen;
      case 'king':
        return CourtCard.king;
      default:
        return CourtCard.none;
    }
  }
  
  // Static cached cards list
  static List<TarotCardModel>? _cachedCards;
  
  // Static methods for card data access
  static Future<TarotCardModel?> getCardById(int id) async {
    final cards = await getAllCards();
    try {
      return cards.firstWhere((card) => card.id == id);
    } catch (e) {
      return null;
    }
  }
  
  static Future<List<TarotCardModel>> getAllCards() async {
    if (_cachedCards != null) {
      return _cachedCards!;
    }
    
    // Use TarotCardData to get the actual cards
    final cardData = await TarotCardData.instance.getFullDeck();
    _cachedCards = cardData;
    return cardData;
  }
  
  // Synchronous getter for legacy code - returns empty list if not loaded
  static List<TarotCardModel> getAllCardsSync() {
    return _cachedCards ?? [];
  }
}