import 'spread_position_model.dart';

enum SpreadType {
  oneCard,
  threeCard,
  celticCross,
  relationship,
  yesNo,
}

enum SpreadDifficulty {
  beginner,
  intermediate,
  advanced,
}

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
  
  static final List<TarotSpread> allSpreads = [
    // 원 카드 스프레드
    const TarotSpread(
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
          title: '핵심 메시지',
          titleKr: '핵심 메시지',
          description: '현재 상황의 본질과 필요한 통찰',
          x: 0.5,
          y: 0.5,
        ),
      ],
      purpose: '간단한 질문, 오늘의 조언, 즉각적인 통찰',
      suitableFor: ['일일 운세', '빠른 조언', '명확한 예/아니오 질문', '현재 에너지 확인'],
    ),
    
    // 쓰리 카드 스프레드
    const TarotSpread(
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
          title: '과거/상황',
          titleKr: '과거/상황',
          description: '현재에 영향을 미친 과거 또는 현재 상황',
          x: 0.2,
          y: 0.5,
        ),
        SpreadPosition(
          index: 1,
          title: '현재/행동',
          titleKr: '현재/행동',
          description: '현재 상태 또는 취해야 할 행동',
          x: 0.5,
          y: 0.5,
        ),
        SpreadPosition(
          index: 2,
          title: '미래/결과',
          titleKr: '미래/결과',
          description: '예상되는 미래 또는 행동의 결과',
          x: 0.8,
          y: 0.5,
        ),
      ],
      purpose: '시간의 흐름 파악, 인과관계 분석, 간단한 상황 진단',
      suitableFor: ['시간적 흐름 분석', '선택의 결과 예측', '관계 역학 파악', '문제 해결 방향'],
    ),
    
    // 켈틱 크로스 스프레드
    const TarotSpread(
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
          title: '현재 상황',
          titleKr: '현재 상황',
          description: '질문의 핵심과 현재 상태',
          x: 0.35,
          y: 0.5,
        ),
        SpreadPosition(
          index: 1,
          title: '도전/교차',
          titleKr: '도전/교차',
          description: '직면한 도전이나 영향력',
          x: 0.35,
          y: 0.5,
          rotation: 90,
        ),
        SpreadPosition(
          index: 2,
          title: '의식적 목표',
          titleKr: '의식적 목표',
          description: '의식적으로 추구하는 것',
          x: 0.35,
          y: 0.2,
        ),
        SpreadPosition(
          index: 3,
          title: '무의식적 기반',
          titleKr: '무의식적 기반',
          description: '무의식적 영향과 근본 원인',
          x: 0.35,
          y: 0.8,
        ),
        SpreadPosition(
          index: 4,
          title: '과거',
          titleKr: '과거',
          description: '현재에 영향을 미친 과거',
          x: 0.1,
          y: 0.5,
        ),
        SpreadPosition(
          index: 5,
          title: '가능한 미래',
          titleKr: '가능한 미래',
          description: '가까운 미래의 가능성',
          x: 0.6,
          y: 0.5,
        ),
        SpreadPosition(
          index: 6,
          title: '자신',
          titleKr: '자신',
          description: '질문자의 현재 상태와 태도',
          x: 0.85,
          y: 0.8,
        ),
        SpreadPosition(
          index: 7,
          title: '외부 영향',
          titleKr: '외부 영향',
          description: '주변 환경과 타인의 영향',
          x: 0.85,
          y: 0.6,
        ),
        SpreadPosition(
          index: 8,
          title: '희망과 두려움',
          titleKr: '희망과 두려움',
          description: '내면의 희망과 두려움',
          x: 0.85,
          y: 0.4,
        ),
        SpreadPosition(
          index: 9,
          title: '최종 결과',
          titleKr: '최종 결과',
          description: '현재 경로의 최종 결과',
          x: 0.85,
          y: 0.2,
        ),
      ],
      purpose: '복잡한 상황의 완전한 분석, 인생의 중요한 결정, 깊은 자기 이해',
      suitableFor: ['중대한 결정', '복잡한 문제 해결', '삶의 전환점', '심층적 자기 탐구'],
    ),
    
    // 관계 스프레드
    const TarotSpread(
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
          title: '나',
          titleKr: '나',
          description: '관계에서 당신의 역할과 에너지',
          x: 0.2,
          y: 0.3,
        ),
        SpreadPosition(
          index: 1,
          title: '상대방',
          titleKr: '상대방',
          description: '상대방의 역할과 에너지',
          x: 0.8,
          y: 0.3,
        ),
        SpreadPosition(
          index: 2,
          title: '관계의 본질',
          titleKr: '관계의 본질',
          description: '두 사람 사이의 핵심 에너지',
          x: 0.5,
          y: 0.5,
        ),
        SpreadPosition(
          index: 3,
          title: '나의 감정',
          titleKr: '나의 감정',
          description: '당신이 느끼는 감정',
          x: 0.2,
          y: 0.7,
        ),
        SpreadPosition(
          index: 4,
          title: '상대방의 감정',
          titleKr: '상대방의 감정',
          description: '상대방이 느끼는 감정',
          x: 0.8,
          y: 0.7,
        ),
        SpreadPosition(
          index: 5,
          title: '도전과제',
          titleKr: '도전과제',
          description: '극복해야 할 장애물',
          x: 0.35,
          y: 0.9,
        ),
        SpreadPosition(
          index: 6,
          title: '잠재력',
          titleKr: '잠재력',
          description: '관계의 가능성과 미래',
          x: 0.65,
          y: 0.9,
        ),
      ],
      purpose: '연애, 우정, 가족 관계의 깊은 이해와 개선 방향 제시',
      suitableFor: ['연애 상담', '관계 개선', '상대방 이해', '갈등 해결'],
    ),
    
    // 예/아니오 스프레드
    const TarotSpread(
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
          title: '첫 번째 조언',
          titleKr: '첫 번째 조언',
          description: '상황의 첫 번째 측면',
          x: 0.1,
          y: 0.5,
        ),
        SpreadPosition(
          index: 1,
          title: '두 번째 조언',
          titleKr: '두 번째 조언',
          description: '고려해야 할 요소',
          x: 0.3,
          y: 0.5,
        ),
        SpreadPosition(
          index: 2,
          title: '핵심',
          titleKr: '핵심',
          description: '질문의 핵심 답변',
          x: 0.5,
          y: 0.5,
        ),
        SpreadPosition(
          index: 3,
          title: '네 번째 조언',
          titleKr: '네 번째 조언',
          description: '추가적인 통찰',
          x: 0.7,
          y: 0.5,
        ),
        SpreadPosition(
          index: 4,
          title: '최종 조언',
          titleKr: '최종 조언',
          description: '종합적인 메시지',
          x: 0.9,
          y: 0.5,
        ),
      ],
      purpose: '빠른 결정이 필요할 때, 명확한 방향성을 원할 때',
      suitableFor: ['즉각적인 결정', '선택의 기로', '타이밍 확인', '가능성 점검'],
    ),
  ];
  
  static TarotSpread getSpreadByType(SpreadType type) {
    return allSpreads.firstWhere(
      (spread) => spread.type == type,
      orElse: () => allSpreads[0],
    );
  }
  
  static List<TarotSpread> getSpreadsByDifficulty(SpreadDifficulty difficulty) {
    return allSpreads.where((spread) => spread.difficulty == difficulty).toList();
  }
}