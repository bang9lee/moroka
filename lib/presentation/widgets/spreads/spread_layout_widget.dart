import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/tarot_spread_model.dart';
import '../../../data/models/tarot_card_model.dart';
import '../../../data/models/spread_position_model.dart';
import '../cards/tarot_card_widget.dart';
import '../common/glass_morphism_container.dart';

/// 타로 스프레드 레이아웃 위젯
/// 각 스프레드 타입에 맞는 카드 배치를 보여줍니다
class SpreadLayoutWidget extends StatefulWidget {
  final TarotSpread spread;
  final List<TarotCardModel?> drawnCards;
  final Function(int position)? onCardTap;
  final bool showCardNames;
  final bool isInteractive;
  
  const SpreadLayoutWidget({
    super.key,
    required this.spread,
    required this.drawnCards,
    this.onCardTap,
    this.showCardNames = true,
    this.isInteractive = true,
  });
  
  @override
  State<SpreadLayoutWidget> createState() => _SpreadLayoutWidgetState();
}

class _SpreadLayoutWidgetState extends State<SpreadLayoutWidget> 
    with TickerProviderStateMixin {
  // Animation Controllers
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _rotationAnimations;
  
  // Constants
  static const Duration _baseAnimationDuration = Duration(milliseconds: 600);
  static const Duration _staggerDelay = Duration(milliseconds: 100);
  static const double _cardWidth = 80.0;
  static const double _cardHeight = 120.0;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startCardAnimations();
  }
  
  void _initializeAnimations() {
    _cardControllers = List.generate(
      widget.spread.cardCount,
      (index) => AnimationController(
        duration: _baseAnimationDuration + (_staggerDelay * index),
        vsync: this,
      ),
    );
    
    _scaleAnimations = _cardControllers.map((controller) => 
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      ),
    ).toList();
    
    _rotationAnimations = _cardControllers.map((controller) => 
      Tween<double>(begin: -0.1, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      ),
    ).toList();
  }
  
  Future<void> _startCardAnimations() async {
    for (int i = 0; i < _cardControllers.length; i++) {
      await Future.delayed(_staggerDelay);
      if (mounted) {
        _cardControllers[i].forward();
      }
    }
  }
  
  @override
  void dispose() {
    for (final controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _buildSpreadLayout(constraints);
      },
    );
  }
  
  Widget _buildSpreadLayout(BoxConstraints constraints) {
    switch (widget.spread.type) {
      case SpreadType.oneCard:
        return _buildOneCardLayout(constraints);
      case SpreadType.threeCard:
        return _buildThreeCardLayout(constraints);
      case SpreadType.celticCross:
        return _buildCelticCrossLayout(constraints);
      case SpreadType.relationship:
        return _buildRelationshipLayout(constraints);
      case SpreadType.yesNo:
        return _buildYesNoLayout(constraints);
    }
  }
  
  /// 원 카드 레이아웃 - 중앙에 크게 표시
  Widget _buildOneCardLayout(BoxConstraints constraints) {
    return Center(
      child: _buildCardPosition(
        index: 0,
        x: constraints.maxWidth * 0.5,
        y: constraints.maxHeight * 0.5,
        constraints: constraints,
        scale: 1.5,
      ),
    );
  }
  
  /// 쓰리 카드 레이아웃 - 과거, 현재, 미래
  Widget _buildThreeCardLayout(BoxConstraints constraints) {
    const cardScale = 0.9;
    final centerY = constraints.maxHeight * 0.5;
    
    return Stack(
      children: [
        _buildCardPosition(
          index: 0,
          x: constraints.maxWidth * 0.2,
          y: centerY,
          constraints: constraints,
          scale: cardScale,
        ),
        _buildCardPosition(
          index: 1,
          x: constraints.maxWidth * 0.5,
          y: centerY,
          constraints: constraints,
          scale: cardScale,
        ),
        _buildCardPosition(
          index: 2,
          x: constraints.maxWidth * 0.8,
          y: centerY,
          constraints: constraints,
          scale: cardScale,
        ),
      ],
    );
  }
  
  /// 켈틱 크로스 레이아웃 - 10장의 복잡한 배치
  Widget _buildCelticCrossLayout(BoxConstraints constraints) {
    const scale = 0.7;
    final centerX = constraints.maxWidth * 0.35;
    final centerY = constraints.maxHeight * 0.5;
    final cardSpacing = constraints.maxWidth * 0.15;
    final staffX = constraints.maxWidth * 0.75;
    final staffSpacing = constraints.maxHeight * 0.15;
    
    return Stack(
      children: [
        // 중앙 십자가 (0-5)
        ..._buildCelticCross(centerX, centerY, cardSpacing, scale, constraints),
        
        // 오른쪽 기둥 (6-9)
        ..._buildCelticStaff(staffX, centerY, staffSpacing, scale, constraints),
      ],
    );
  }
  
  List<Widget> _buildCelticCross(
    double centerX,
    double centerY,
    double spacing,
    double scale,
    BoxConstraints constraints,
  ) {
    return [
      _buildCardPosition(
        index: 0,
        x: centerX,
        y: centerY,
        constraints: constraints,
        scale: scale,
      ),
      _buildCardPosition(
        index: 1,
        x: centerX,
        y: centerY,
        constraints: constraints,
        rotation: 90,
        scale: scale,
      ),
      _buildCardPosition(
        index: 2,
        x: centerX,
        y: centerY - spacing,
        constraints: constraints,
        scale: scale,
      ),
      _buildCardPosition(
        index: 3,
        x: centerX,
        y: centerY + spacing,
        constraints: constraints,
        scale: scale,
      ),
      _buildCardPosition(
        index: 4,
        x: centerX - spacing,
        y: centerY,
        constraints: constraints,
        scale: scale,
      ),
      _buildCardPosition(
        index: 5,
        x: centerX + spacing,
        y: centerY,
        constraints: constraints,
        scale: scale,
      ),
    ];
  }
  
  List<Widget> _buildCelticStaff(
    double x,
    double centerY,
    double spacing,
    double scale,
    BoxConstraints constraints,
  ) {
    return [
      _buildCardPosition(
        index: 6,
        x: x,
        y: centerY + spacing * 1.5,
        constraints: constraints,
        scale: scale,
      ),
      _buildCardPosition(
        index: 7,
        x: x,
        y: centerY + spacing * 0.5,
        constraints: constraints,
        scale: scale,
      ),
      _buildCardPosition(
        index: 8,
        x: x,
        y: centerY - spacing * 0.5,
        constraints: constraints,
        scale: scale,
      ),
      _buildCardPosition(
        index: 9,
        x: x,
        y: centerY - spacing * 1.5,
        constraints: constraints,
        scale: scale,
      ),
    ];
  }
  
  /// 관계 스프레드 레이아웃 - 7장
  Widget _buildRelationshipLayout(BoxConstraints constraints) {
    const scale = 0.8;
    final centerX = constraints.maxWidth * 0.5;
    final centerY = constraints.maxHeight * 0.5;
    final horizontalSpacing = constraints.maxWidth * 0.25;
    final verticalSpacing = constraints.maxHeight * 0.2;
    
    return Stack(
      children: [
        // 상단 - 두 사람
        _buildCardPosition(
          index: 0,
          x: centerX - horizontalSpacing,
          y: centerY - verticalSpacing,
          constraints: constraints,
          scale: scale,
        ),
        _buildCardPosition(
          index: 1,
          x: centerX + horizontalSpacing,
          y: centerY - verticalSpacing,
          constraints: constraints,
          scale: scale,
        ),
        
        // 중앙 - 관계의 본질
        _buildCardPosition(
          index: 2,
          x: centerX,
          y: centerY,
          constraints: constraints,
          scale: scale * 1.1,
        ),
        
        // 중간 - 감정
        _buildCardPosition(
          index: 3,
          x: centerX - horizontalSpacing,
          y: centerY + verticalSpacing * 0.4,
          constraints: constraints,
          scale: scale,
        ),
        _buildCardPosition(
          index: 4,
          x: centerX + horizontalSpacing,
          y: centerY + verticalSpacing * 0.4,
          constraints: constraints,
          scale: scale,
        ),
        
        // 하단 - 도전과 잠재력
        _buildCardPosition(
          index: 5,
          x: centerX - horizontalSpacing * 0.5,
          y: centerY + verticalSpacing,
          constraints: constraints,
          scale: scale,
        ),
        _buildCardPosition(
          index: 6,
          x: centerX + horizontalSpacing * 0.5,
          y: centerY + verticalSpacing,
          constraints: constraints,
          scale: scale,
        ),
      ],
    );
  }
  
  /// 예/아니오 레이아웃 - 5장 가로
  Widget _buildYesNoLayout(BoxConstraints constraints) {
    const scale = 0.85;
    final centerY = constraints.maxHeight * 0.5;
    
    return Stack(
      children: List.generate(5, (index) {
        final positions = [0.1, 0.3, 0.5, 0.7, 0.9];
        final isCenter = index == 2;
        
        return _buildCardPosition(
          index: index,
          x: constraints.maxWidth * positions[index],
          y: centerY,
          constraints: constraints,
          scale: isCenter ? scale * 1.2 : scale,
        );
      }),
    );
  }
  
  /// 개별 카드 위치 빌드
  Widget _buildCardPosition({
    required int index,
    required double x,
    required double y,
    required BoxConstraints constraints,
    double rotation = 0,
    double scale = 1.0,
  }) {
    if (index >= widget.spread.positions.length) return const SizedBox();
    
    final position = widget.spread.positions[index];
    final card = index < widget.drawnCards.length ? widget.drawnCards[index] : null;
    
    return Positioned(
      left: x - (_cardWidth * scale / 2),
      top: y - (_cardHeight * scale / 2),
      child: AnimatedBuilder(
        animation: _scaleAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimations[index].value * scale,
            child: Transform.rotate(
              angle: _rotationAnimations[index].value + (rotation * 3.14159 / 180),
              child: _buildCard(index, position, card, scale),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildCard(
    int index,
    SpreadPosition position,
    TarotCardModel? card,
    double scale,
  ) {
    return GestureDetector(
      onTap: widget.isInteractive && widget.onCardTap != null 
        ? () => widget.onCardTap!(index) 
        : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 위치 라벨
          if (widget.showCardNames && scale > 0.7)
            _buildPositionLabel(position),
          
          // 카드
          _buildCardContent(card, index),
          
          // 카드 이름
          if (widget.showCardNames && card != null && scale > 0.9)
            _buildCardNameLabel(card),
        ],
      ),
    ).animate()
        .shimmer(
          duration: const Duration(seconds: 3),
          color: AppColors.whiteOverlay10,
          delay: Duration(milliseconds: index * 100),
        );
  }
  
  Widget _buildPositionLabel(SpreadPosition position) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.blackOverlay60,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.whiteOverlay20,
          width: 1,
        ),
      ),
      child: Text(
        position.titleKr,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 10,
          color: AppColors.fogGray,
        ),
      ),
    );
  }
  
  Widget _buildCardContent(TarotCardModel? card, int index) {
    return Container(
      width: _cardWidth,
      height: _cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.evilGlow.withValues(alpha: 0.12),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: card != null
        ? TarotCardFront(
            cardName: card.nameKr,
            imagePath: card.imagePath,
            showDetails: false,
            width: _cardWidth,
            height: _cardHeight,
          )
        : _buildEmptyCard(index),
    );
  }
  
  Widget _buildEmptyCard(int index) {
    return GlassMorphismContainer(
      borderRadius: 8,
      backgroundColor: AppColors.blackOverlay40,
      borderColor: AppColors.mysticPurple,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${index + 1}',
              style: AppTextStyles.displayMedium.copyWith(
                fontSize: 20,
                color: AppColors.mysticPurple,
              ),
            ),
            const SizedBox(height: 2),
            const Icon(
              Icons.help_outline,
              color: AppColors.fogGray,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCardNameLabel(TarotCardModel card) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Text(
        card.nameKr,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 10,
          color: AppColors.textMystic,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}