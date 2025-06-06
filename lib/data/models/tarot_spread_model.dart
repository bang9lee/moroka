import 'spread_position_model.dart';

/// 타로 스프레드의 타입을 정의하는 열거형
enum SpreadType {
  oneCard,
  threeCard,
  yesNo,
  relationship,
  celticCross,
}

/// 타로 스프레드의 난이도를 정의하는 열거형
enum SpreadDifficulty {
  beginner,     // 초급 (1-3장)
  intermediate, // 중급 (5-7장)
  advanced,     // 고급 (10장)
}

/// 타로 스프레드의 정보를 담는 불변 모델 클래스
class TarotSpread {
  final SpreadType type;
  final String name;
  final String nameKr;
  final String description;
  final String imagePath;
  final int cardCount;
  final SpreadDifficulty difficulty;
  final List<SpreadPosition> positions;
  final String purpose;
  final List<String> suitableFor;
  
  const TarotSpread({
    required this.type,
    required this.name,
    required this.nameKr,
    required this.description,
    required this.imagePath,
    required this.cardCount,
    required this.difficulty,
    required this.positions,
    required this.purpose,
    required this.suitableFor,
  });
  
  // 현재 로케일에 따른 이름 반환
  String getLocalizedName(String locale) {
    switch (locale) {
      case 'ko':
        return nameKr;
      case 'en':
      default:
        return name;
    }
  }
  
  /// 모든 타로 스프레드 목록 (카드 수 기준 정렬)
  static final List<TarotSpread> allSpreads = [
    // ===== 초급 스프레드 (1-3장) =====
    _oneCardSpread,
    _threeCardSpread,
    
    // ===== 중급 스프레드 (5-7장) - 카드 수 오름차순 =====
    _yesNoSpread,      // 5장
    _relationshipSpread, // 7장
    
    // ===== 고급 스프레드 (10장) =====
    _celticCrossSpread,
  ];
  
  /// 원 카드 스프레드 정의
  static const TarotSpread _oneCardSpread = TarotSpread(
    type: SpreadType.oneCard,
    name: 'One Card Spread',
    nameKr: '원 카드',
    description: '가장 간단하면서도 강력한 배열법. 하나의 카드가 모든 답을 담고 있습니다.',
    imagePath: 'assets/images/spreads/one_card_spread.png',
    cardCount: 1,
    difficulty: SpreadDifficulty.beginner,
    positions: [
      SpreadPosition(
        index: 0,
        title: 'Core Message',
        titleKr: '핵심 메시지',
        description: '현재 상황의 본질과 필요한 통찰',
        x: 0.5,
        y: 0.5,
        spreadType: 'onecard',
      ),
    ],
    purpose: '간단한 질문, 오늘의 조언, 즉각적인 통찰',
    suitableFor: [
      '일일 운세',
      '빠른 조언',
      '명확한 예/아니오 질문',
      '현재 에너지 확인',
    ],
  );
  
  /// 쓰리 카드 스프레드 정의
  static const TarotSpread _threeCardSpread = TarotSpread(
    type: SpreadType.threeCard,
    name: 'Three Card Spread',
    nameKr: '쓰리 카드',
    description: '과거, 현재, 미래의 흐름을 읽거나 상황-행동-결과를 파악하는 다목적 배열법',
    imagePath: 'assets/images/spreads/three_card_spread.png',
    cardCount: 3,
    difficulty: SpreadDifficulty.beginner,
    positions: [
      SpreadPosition(
        index: 0,
        title: 'Past',
        titleKr: '과거',
        description: '현재에 영향을 미친 과거 또는 현재 상황',
        x: 0.2,
        y: 0.5,
        spreadType: 'threecard',
      ),
      SpreadPosition(
        index: 1,
        title: 'Present',
        titleKr: '현재',
        description: '현재 상태 또는 취해야 할 행동',
        x: 0.5,
        y: 0.5,
        spreadType: 'threecard',
      ),
      SpreadPosition(
        index: 2,
        title: 'Future',
        titleKr: '미래',
        description: '예상되는 미래 또는 행동의 결과',
        x: 0.8,
        y: 0.5,
        spreadType: 'threecard',
      ),
    ],
    purpose: '시간의 흐름 파악, 인과관계 분석, 간단한 상황 진단',
    suitableFor: [
      '시간적 흐름 분석',
      '선택의 결과 예측',
      '관계 역학 파악',
      '문제 해결 방향',
    ],
  );
  
  /// 예/아니오 스프레드 정의 (5장)
  static const TarotSpread _yesNoSpread = TarotSpread(
    type: SpreadType.yesNo,
    name: 'Yes/No Spread',
    nameKr: '예/아니오',
    description: '명확한 답을 원할 때. 5장의 카드가 다수결로 답을 알려줍니다.',
    imagePath: 'assets/images/spreads/yes_no_spread.png',
    cardCount: 5,
    difficulty: SpreadDifficulty.intermediate,
    positions: [
      SpreadPosition(
        index: 0,
        title: 'Yes Strong',
        titleKr: 'Yes 강함',
        description: '상황의 첫 번째 측면',
        x: 0.1,
        y: 0.5,
        spreadType: 'yesno',
      ),
      SpreadPosition(
        index: 1,
        title: 'Yes Weak',
        titleKr: 'Yes 약함',
        description: '고려해야 할 요소',
        x: 0.3,
        y: 0.5,
        spreadType: 'yesno',
      ),
      SpreadPosition(
        index: 2,
        title: 'Core',
        titleKr: '핵심',
        description: '질문의 핵심 답변',
        x: 0.5,
        y: 0.5,
        spreadType: 'yesno',
      ),
      SpreadPosition(
        index: 3,
        title: 'No Weak',
        titleKr: 'No 약함',
        description: '추가적인 통찰',
        x: 0.7,
        y: 0.5,
        spreadType: 'yesno',
      ),
      SpreadPosition(
        index: 4,
        title: 'No Strong',
        titleKr: 'No 강함',
        description: '종합적인 메시지',
        x: 0.9,
        y: 0.5,
        spreadType: 'yesno',
      ),
    ],
    purpose: '빠른 결정이 필요할 때, 명확한 방향성을 원할 때',
    suitableFor: [
      '즉각적인 결정',
      '선택의 기로',
      '타이밍 확인',
      '가능성 점검',
    ],
  );
  
  /// 관계 스프레드 정의 (7장)
  static const TarotSpread _relationshipSpread = TarotSpread(
    type: SpreadType.relationship,
    name: 'Relationship Spread',
    nameKr: '관계 스프레드',
    description: '두 사람 사이의 에너지와 역학관계를 깊이 있게 탐구합니다.',
    imagePath: 'assets/images/spreads/relationship_spread.png',
    cardCount: 7,
    difficulty: SpreadDifficulty.intermediate,
    positions: [
      SpreadPosition(
        index: 0,
        title: 'You',
        titleKr: '나',
        description: '관계에서 당신의 역할과 에너지',
        x: 0.2,
        y: 0.3,
        spreadType: 'relationship',
      ),
      SpreadPosition(
        index: 1,
        title: 'Partner',
        titleKr: '상대방',
        description: '상대방의 역할과 에너지',
        x: 0.8,
        y: 0.3,
        spreadType: 'relationship',
      ),
      SpreadPosition(
        index: 2,
        title: 'Relationship Core',
        titleKr: '관계의 본질',
        description: '두 사람 사이의 핵심 에너지',
        x: 0.5,
        y: 0.5,
        spreadType: 'relationship',
      ),
      SpreadPosition(
        index: 3,
        title: 'Your Feelings',
        titleKr: '나의 감정',
        description: '당신이 느끼는 감정',
        x: 0.2,
        y: 0.7,
        spreadType: 'relationship',
      ),
      SpreadPosition(
        index: 4,
        title: 'Partner\'s Feelings',
        titleKr: '상대방의 감정',
        description: '상대방이 느끼는 감정',
        x: 0.8,
        y: 0.7,
        spreadType: 'relationship',
      ),
      SpreadPosition(
        index: 5,
        title: 'Challenges',
        titleKr: '도전과제',
        description: '극복해야 할 장애물',
        x: 0.35,
        y: 0.9,
        spreadType: 'relationship',
      ),
      SpreadPosition(
        index: 6,
        title: 'Potential',
        titleKr: '잠재력',
        description: '관계의 가능성과 미래',
        x: 0.65,
        y: 0.9,
        spreadType: 'relationship',
      ),
    ],
    purpose: '연애, 우정, 가족 관계의 깊은 이해와 개선 방향 제시',
    suitableFor: [
      '연애 상담',
      '관계 개선',
      '상대방 이해',
      '갈등 해결',
    ],
  );
  
  /// 켈틱 크로스 스프레드 정의
  static const TarotSpread _celticCrossSpread = TarotSpread(
    type: SpreadType.celticCross,
    name: 'Celtic Cross Spread',
    nameKr: '켈틱 크로스',
    description: '가장 전통적이고 포괄적인 배열법. 상황의 모든 측면을 심층 분석합니다.',
    imagePath: 'assets/images/spreads/celtic_cross_spread.png',
    cardCount: 10,
    difficulty: SpreadDifficulty.advanced,
    positions: [
      SpreadPosition(
        index: 0,
        title: 'Present Situation',
        titleKr: '현재 상황',
        description: '질문의 핵심과 현재 상태',
        x: 0.35,
        y: 0.5,
        spreadType: 'celticcross',
      ),
      SpreadPosition(
        index: 1,
        title: 'Challenge/Cross',
        titleKr: '도전/교차',
        description: '직면한 도전이나 영향력',
        x: 0.35,
        y: 0.5,
        rotation: 90,
        spreadType: 'celticcross',
      ),
      SpreadPosition(
        index: 2,
        title: 'Conscious Goal',
        titleKr: '의식적 목표',
        description: '의식적으로 추구하는 것',
        x: 0.35,
        y: 0.2,
        spreadType: 'celticcross',
      ),
      SpreadPosition(
        index: 3,
        title: 'Unconscious Foundation',
        titleKr: '무의식적 기반',
        description: '무의식적 영향과 근본 원인',
        x: 0.35,
        y: 0.8,
        spreadType: 'celticcross',
      ),
      SpreadPosition(
        index: 4,
        title: 'Past',
        titleKr: '과거',
        description: '현재에 영향을 미친 과거',
        x: 0.1,
        y: 0.5,
        spreadType: 'celticcross',
      ),
      SpreadPosition(
        index: 5,
        title: 'Possible Future',
        titleKr: '가능한 미래',
        description: '가까운 미래의 가능성',
        x: 0.6,
        y: 0.5,
        spreadType: 'celticcross',
      ),
      SpreadPosition(
        index: 6,
        title: 'Self',
        titleKr: '자신',
        description: '질문자의 현재 상태와 태도',
        x: 0.85,
        y: 0.8,
        spreadType: 'celticcross',
      ),
      SpreadPosition(
        index: 7,
        title: 'External Influences',
        titleKr: '외부 영향',
        description: '주변 환경과 타인의 영향',
        x: 0.85,
        y: 0.6,
        spreadType: 'celticcross',
      ),
      SpreadPosition(
        index: 8,
        title: 'Hopes and Fears',
        titleKr: '희망과 두려움',
        description: '내면의 희망과 두려움',
        x: 0.85,
        y: 0.4,
        spreadType: 'celticcross',
      ),
      SpreadPosition(
        index: 9,
        title: 'Final Outcome',
        titleKr: '최종 결과',
        description: '현재 경로의 최종 결과',
        x: 0.85,
        y: 0.2,
        spreadType: 'celticcross',
      ),
    ],
    purpose: '복잡한 상황의 완전한 분석, 인생의 중요한 결정, 깊은 자기 이해',
    suitableFor: [
      '중대한 결정',
      '복잡한 문제 해결',
      '삶의 전환점',
      '심층적 자기 탐구',
    ],
  );
  
  // ===== 유틸리티 메서드 =====
  
  /// 특정 타입의 스프레드 반환
  static TarotSpread getSpreadByType(SpreadType type) {
    return allSpreads.firstWhere(
      (spread) => spread.type == type,
      orElse: () => _oneCardSpread,
    );
  }
  
  /// 난이도별 스프레드 목록 반환 (카드 수 오름차순 정렬)
  static List<TarotSpread> getSpreadsByDifficulty(SpreadDifficulty difficulty) {
    final spreads = allSpreads
        .where((spread) => spread.difficulty == difficulty)
        .toList();
    
    // 카드 수 기준 오름차순 정렬
    spreads.sort((a, b) => a.cardCount.compareTo(b.cardCount));
    
    return spreads;
  }
  
  /// 카드 개수별 스프레드 반환
  static List<TarotSpread> getSpreadsByCardCount(int cardCount) {
    return allSpreads
        .where((spread) => spread.cardCount == cardCount)
        .toList();
  }
  
  /// 특정 목적에 적합한 스프레드 찾기
  static List<TarotSpread> getSpreadsByPurpose(String keyword) {
    keyword = keyword.toLowerCase();
    return allSpreads.where((spread) {
      return spread.purpose.toLowerCase().contains(keyword) ||
          spread.suitableFor.any((suitable) => 
            suitable.toLowerCase().contains(keyword));
    }).toList();
  }
  
  // ===== 편의 메서드 =====
  
  /// 스프레드가 초급인지 확인
  bool get isBeginner => difficulty == SpreadDifficulty.beginner;
  
  /// 스프레드가 중급인지 확인
  bool get isIntermediate => difficulty == SpreadDifficulty.intermediate;
  
  /// 스프레드가 고급인지 확인
  bool get isAdvanced => difficulty == SpreadDifficulty.advanced;
  
  /// 스프레드가 간단한지 확인 (3장 이하)
  bool get isSimple => cardCount <= 3;
  
  /// 스프레드가 복잡한지 확인 (7장 이상)
  bool get isComplex => cardCount >= 7;
  
  /// 예상 리딩 시간 (분 단위)
  int get estimatedReadingTime {
    if (cardCount == 1) return 5;
    if (cardCount <= 3) return 10;
    if (cardCount <= 5) return 15;
    if (cardCount <= 7) return 20;
    return 30;
  }
  
  /// 스프레드 난이도 설명
  String get difficultyDescription {
    switch (difficulty) {
      case SpreadDifficulty.beginner:
        return '초보자에게 적합한 간단한 배열법';
      case SpreadDifficulty.intermediate:
        return '어느 정도 경험이 있는 분께 추천';
      case SpreadDifficulty.advanced:
        return '깊이 있는 해석을 원하는 분께 추천';
    }
  }
  
  /// 스프레드 검증
  bool get isValid {
    return positions.isNotEmpty &&
           positions.length == cardCount &&
           positions.every((pos) => 
             pos.x >= 0 && pos.x <= 1 && 
             pos.y >= 0 && pos.y <= 1);
  }
}