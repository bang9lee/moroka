import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/app_exceptions.dart';

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
    final rawData = doc.data();
    if (rawData == null || rawData is! Map<String, dynamic>) {
      throw const DataException(
        code: 'invalid_reading_data',
        message: 'Invalid reading document data',
      );
    }
    
    final data = rawData;
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
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
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
  
  // Factory constructor for cache deserialization
  factory TarotReadingModel.fromMap(Map<String, dynamic> map, String id) {
    return TarotReadingModel(
      id: id,
      userId: map['userId'] ?? '',
      cardName: map['cardName'] ?? '',
      cardImage: map['cardImage'] ?? '',
      interpretation: map['interpretation'] ?? '',
      chatHistory: (map['chatHistory'] as List<dynamic>?)
              ?.map((e) => ChatExchange.fromMapWithoutTimestamp(e))
              .toList() ??
          [],
      createdAt: map['createdAt'] is Timestamp 
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt'] as String),
      userMood: map['userMood'] ?? '',
      spreadType: map['spreadType'],
      cardCount: map['cardCount'],
    );
  }
  
  // Convert to map for caching
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cardName': cardName,
      'cardImage': cardImage,
      'interpretation': interpretation,
      'chatHistory': chatHistory.map((e) => e.toMapForCache()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'userMood': userMood,
      'spreadType': spreadType,
      'cardCount': cardCount,
    };
  }
  
  // 카드 이름 리스트 반환
  List<String> get cardNames => cardName.split(', ');
  
  // 카드 이미지 리스트 반환
  List<String> get cardImages => cardImage.split(',');
  
  // 배열법 이름 반환 (현지화 키 반환)
  String get spreadNameKey {
    switch (spreadType) {
      case 'SpreadType.oneCard':
        return 'spreadOneCard';
      case 'SpreadType.threeCard':
        return 'spreadThreeCard';
      case 'SpreadType.celticCross':
        return 'spreadCelticCross';
      case 'SpreadType.relationship':
        return 'spreadRelationship';
      case 'SpreadType.yesNo':
        return 'spreadYesNo';
      default:
        return 'spreadOneCard';
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
  
  // Factory constructor for cache (without Timestamp)
  factory ChatExchange.fromMapWithoutTimestamp(Map<String, dynamic> map) {
    return ChatExchange(
      userMessage: map['userMessage'] ?? '',
      aiResponse: map['aiResponse'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
  
  // Convert to map for caching
  Map<String, dynamic> toMapForCache() {
    return {
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}