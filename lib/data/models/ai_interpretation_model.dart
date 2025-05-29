class AIInterpretationModel {
  final String cardName;
  final String interpretation;
  final String userMood;
  final DateTime createdAt;
  final List<String> keywords;

  AIInterpretationModel({
    required this.cardName,
    required this.interpretation,
    required this.userMood,
    DateTime? createdAt,
    this.keywords = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'cardName': cardName,
      'interpretation': interpretation,
      'userMood': userMood,
      'createdAt': createdAt.toIso8601String(),
      'keywords': keywords,
    };
  }

  factory AIInterpretationModel.fromMap(Map<String, dynamic> map) {
    return AIInterpretationModel(
      cardName: map['cardName'] ?? '',
      interpretation: map['interpretation'] ?? '',
      userMood: map['userMood'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      keywords: List<String>.from(map['keywords'] ?? []),
    );
  }
}