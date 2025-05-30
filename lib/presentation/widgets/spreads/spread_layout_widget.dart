import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/tarot_spread_model.dart';
import '../../../data/models/tarot_card_model.dart';
import '../cards/tarot_card_widget.dart';
import '../common/glass_morphism_container.dart';

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
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _rotationAnimations;
  
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
        duration: Duration(milliseconds: 600 + (index * 100)),
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
  
  void _startCardAnimations() async {
    for (int i = 0; i < _cardControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
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
      },
    );
  }
  
  // 원 카드 레이아웃
  Widget _buildOneCardLayout(BoxConstraints constraints) {
    return Center(
      child: _buildCardPosition(
        0,
        constraints.maxWidth * 0.5,
        constraints.maxHeight * 0.5,
        constraints,
        scale: 1.5,
      ),
    );
  }
  
  // 쓰리 카드 레이아웃 (가로 일렬)
  Widget _buildThreeCardLayout(BoxConstraints constraints) {
    const cardScale = 0.9;
    final centerY = constraints.maxHeight * 0.5;
    
    return Stack(
      children: [
        _buildCardPosition(0, constraints.maxWidth * 0.2, centerY, constraints, scale: cardScale),
        _buildCardPosition(1, constraints.maxWidth * 0.5, centerY, constraints, scale: cardScale),
        _buildCardPosition(2, constraints.maxWidth * 0.8, centerY, constraints, scale: cardScale),
      ],
    );
  }
  
  // 켈틱 크로스 레이아웃 - 더 컴팩트하게
  Widget _buildCelticCrossLayout(BoxConstraints constraints) {
    const scale = 0.7; // 카드 크기 줄임
    final centerX = constraints.maxWidth * 0.35;
    final centerY = constraints.maxHeight * 0.5;
    final cardSpacing = constraints.maxWidth * 0.15; // 간격 줄임
    final staffX = constraints.maxWidth * 0.75; // 오른쪽 기둥 위치 조정
    final staffSpacing = constraints.maxHeight * 0.15; // 세로 간격 줄임
    
    return Stack(
      children: [
        // 중앙 십자가
        _buildCardPosition(0, centerX, centerY, constraints, scale: scale),
        _buildCardPosition(1, centerX, centerY, constraints, rotation: 90, scale: scale),
        _buildCardPosition(2, centerX, centerY - cardSpacing, constraints, scale: scale),
        _buildCardPosition(3, centerX, centerY + cardSpacing, constraints, scale: scale),
        _buildCardPosition(4, centerX - cardSpacing, centerY, constraints, scale: scale),
        _buildCardPosition(5, centerX + cardSpacing, centerY, constraints, scale: scale),
        
        // 오른쪽 기둥 (아래에서 위로)
        _buildCardPosition(6, staffX, centerY + staffSpacing * 1.5, constraints, scale: scale),
        _buildCardPosition(7, staffX, centerY + staffSpacing * 0.5, constraints, scale: scale),
        _buildCardPosition(8, staffX, centerY - staffSpacing * 0.5, constraints, scale: scale),
        _buildCardPosition(9, staffX, centerY - staffSpacing * 1.5, constraints, scale: scale),
      ],
    );
  }
  
  // 관계 스프레드 레이아웃 (7장) - 더 컴팩트하게
  Widget _buildRelationshipLayout(BoxConstraints constraints) {
    const scale = 0.8;
    final centerX = constraints.maxWidth * 0.5;
    final centerY = constraints.maxHeight * 0.5;
    final horizontalSpacing = constraints.maxWidth * 0.25; // 간격 줄임
    final verticalSpacing = constraints.maxHeight * 0.2; // 간격 줄임
    
    return Stack(
      children: [
        // 상단 - 두 사람
        _buildCardPosition(0, centerX - horizontalSpacing, centerY - verticalSpacing, constraints, scale: scale),
        _buildCardPosition(1, centerX + horizontalSpacing, centerY - verticalSpacing, constraints, scale: scale),
        
        // 중앙 - 관계의 본질
        _buildCardPosition(2, centerX, centerY, constraints, scale: scale * 1.1),
        
        // 중간 - 감정
        _buildCardPosition(3, centerX - horizontalSpacing, centerY + verticalSpacing * 0.4, constraints, scale: scale),
        _buildCardPosition(4, centerX + horizontalSpacing, centerY + verticalSpacing * 0.4, constraints, scale: scale),
        
        // 하단 - 도전과 잠재력
        _buildCardPosition(5, centerX - horizontalSpacing * 0.5, centerY + verticalSpacing, constraints, scale: scale),
        _buildCardPosition(6, centerX + horizontalSpacing * 0.5, centerY + verticalSpacing, constraints, scale: scale),
      ],
    );
  }
  
  // 예/아니오 레이아웃 (5장 가로)
  Widget _buildYesNoLayout(BoxConstraints constraints) {
    const scale = 0.85;
    final centerY = constraints.maxHeight * 0.5;
    
    return Stack(
      children: [
        _buildCardPosition(0, constraints.maxWidth * 0.1, centerY, constraints, scale: scale),
        _buildCardPosition(1, constraints.maxWidth * 0.3, centerY, constraints, scale: scale),
        _buildCardPosition(2, constraints.maxWidth * 0.5, centerY, constraints, scale: scale * 1.2), // 중앙 강조
        _buildCardPosition(3, constraints.maxWidth * 0.7, centerY, constraints, scale: scale),
        _buildCardPosition(4, constraints.maxWidth * 0.9, centerY, constraints, scale: scale),
      ],
    );
  }
  
  // 개별 카드 위치 빌드
  Widget _buildCardPosition(
    int index,
    double x,
    double y,
    BoxConstraints constraints, {
    double rotation = 0,
    double scale = 1.0,
  }) {
    if (index >= widget.spread.positions.length) return const SizedBox();
    
    final position = widget.spread.positions[index];
    final card = index < widget.drawnCards.length ? widget.drawnCards[index] : null;
    
    return Positioned(
      left: x - 40 * scale,
      top: y - 60 * scale,
      child: AnimatedBuilder(
        animation: _scaleAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimations[index].value * scale,
            child: Transform.rotate(
              angle: _rotationAnimations[index].value + (rotation * 3.14159 / 180),
              child: GestureDetector(
                onTap: widget.isInteractive && widget.onCardTap != null 
                  ? () => widget.onCardTap!(index) 
                  : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 위치 라벨
                    if (widget.showCardNames && scale > 0.7) // 작은 카드는 라벨 숨김
                      Container(
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
                      ),
                    
                    // 카드
                    Container(
                      width: 80,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.evilGlow.withAlpha(30),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: card != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: TarotCardFront(
                              cardName: card.nameKr,
                              imagePath: card.imagePath,
                              showDetails: false,
                            ),
                          )
                        : GlassMorphismContainer(
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
                          ),
                    ),
                    
                    // 카드 이름 - 스케일이 큰 경우만
                    if (widget.showCardNames && card != null && scale > 0.9)
                      Container(
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
                      ),
                  ],
                ),
              ).animate()
                  .shimmer(
                    duration: const Duration(seconds: 3),
                    color: AppColors.whiteOverlay10,
                    delay: Duration(milliseconds: index * 100),
                  ),
            ),
          );
        },
      ),
    );
  }
}