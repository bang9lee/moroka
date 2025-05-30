import 'package:cloud_firestore/cloud_firestore.dart';

class TarotReadingModel {
  final String id;
  final String userId;
  final String cardName; // 원카드는 단일, 배열법은 콤마 구분
  final String cardImage; // 원카드는 단일, 배열법은 콤마 구분
  final String interpretation;
  final List<ChatExchange> chatHistory;
  final DateTime createdAt;
  final String userMood;
  final String? spreadType; // 배열법 타입
  final int? cardCount; // 카드 개수

  TarotReadingModel({
    required this.id,
    required this.userId,
    required this.cardName,
    required this.cardImage,
    required this.interpretation,
    required this.chatHistory,
    required this.createdAt,
    required this.userMood,
    this.spreadType,
    this.cardCount,
  });

  factory TarotReadingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TarotReadingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      cardName: data['cardName'] ?? '',
      cardImage: data['cardImage'] ?? '',
      interpretation: data['interpretation'] ?? '',
      chatHistory: (data['chatHistory'] as List<dynamic>?)
              ?.map((e) => ChatExchange.fromMap(e))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userMood: data['userMood'] ?? '',
      spreadType: data['spreadType'],
      cardCount: data['cardCount'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'cardName': cardName,
      'cardImage': cardImage,
      'interpretation': interpretation,
      'chatHistory': chatHistory.map((e) => e.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'userMood': userMood,
      'spreadType': spreadType,
      'cardCount': cardCount,
    };
  }
  
  // 카드 이름 리스트 반환
  List<String> get cardNames => cardName.split(', ');
  
  // 카드 이미지 리스트 반환
  List<String> get cardImages => cardImage.split(',');
  
  // 배열법 이름 반환
  String get spreadName {
    switch (spreadType) {
      case 'SpreadType.oneCard':
        return '원 카드';
      case 'SpreadType.threeCard':
        return '쓰리 카드';
      case 'SpreadType.celticCross':
        return '켈틱 크로스';
      case 'SpreadType.relationship':
        return '관계 스프레드';
      case 'SpreadType.yesNo':
        return '예/아니오';
      default:
        return '원 카드';
    }
  }
}

class ChatExchange {
  final String userMessage;
  final String aiResponse;
  final DateTime timestamp;

  ChatExchange({
    required this.userMessage,
    required this.aiResponse,
    required this.timestamp,
  });

  factory ChatExchange.fromMap(Map<String, dynamic> map) {
    return ChatExchange(
      userMessage: map['userMessage'] ?? '',
      aiResponse: map['aiResponse'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}