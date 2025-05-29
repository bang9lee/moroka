import 'package:cloud_firestore/cloud_firestore.dart';

class TarotReadingModel {
  final String id;
  final String userId;
  final String cardName;
  final String cardImage;
  final String interpretation;
  final List<ChatExchange> chatHistory;
  final DateTime createdAt;
  final String userMood;

  TarotReadingModel({
    required this.id,
    required this.userId,
    required this.cardName,
    required this.cardImage,
    required this.interpretation,
    required this.chatHistory,
    required this.createdAt,
    required this.userMood,
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
    };
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