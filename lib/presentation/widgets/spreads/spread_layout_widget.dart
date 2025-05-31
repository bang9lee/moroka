import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
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
  final EdgeInsets padding;
  
  const SpreadLayoutWidget({
    super.key,
    required this.spread,
    required this.drawnCards,
    this.onCardTap,
    this.showCardNames = true,
    this.isInteractive = true,
    this.padding = const EdgeInsets.all(16),
  });
  
  @override
  State<SpreadLayoutWidget> createState() => _SpreadLayoutWidgetState();
}

class _SpreadLayoutWidgetState extends State<SpreadLayoutWidget> 
    with TickerProviderStateMixin {
  // Animation Controllers
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;
  
  // Touch feedback
  final Set<int> _touchedCards = {};
  
  // Layout Constants
  static const _minCardWidth = 50.0;
  static const _minLabelFontSize = 11.0;
  static const _defaultLabelFontSize = 14.0;
  static const _minCardNameFontSize = 12.0;
  static const _defaultCardNameFontSize = 14.0;
  
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
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
    
    _scaleAnimations = _cardControllers.map((controller) => 
      Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      )),
    ).toList();
    
    _fadeAnimations = _cardControllers.map((controller) => 
      Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      )),
    ).toList();
  }
  
  Future<void> _startCardAnimations() async {
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
        final availableWidth = constraints.maxWidth - widget.padding.horizontal;
        final availableHeight = constraints.maxHeight - widget.padding.vertical;
        
        return Padding(
          padding: widget.padding,
          child: _buildSpreadLayout(
            Size(availableWidth, availableHeight),
          ),
        );
      },
    );
  }
  
  Widget _buildSpreadLayout(Size availableSize) {
    final positions = _calculateCardPositions(availableSize);
    
    return Stack(
      clipBehavior: Clip.none,
      children: List.generate(
        positions.length,
        (index) => _buildPositionedCard(
          index: index,
          position: positions[index],
          size: availableSize,
        ),
      ),
    );
  }
  
  List<CardPosition> _calculateCardPositions(Size availableSize) {
    switch (widget.spread.type) {
      case SpreadType.oneCard:
        return _calculateOneCardPositions(availableSize);
      case SpreadType.threeCard:
        return _calculateThreeCardPositions(availableSize);
      case SpreadType.celticCross:
        return _calculateCelticCrossPositions(availableSize);
      case SpreadType.relationship:
        return _calculateRelationshipPositions(availableSize);
      case SpreadType.yesNo:
        return _calculateYesNoPositions(availableSize);
    }
  }
  
  // 원 카드 배치 계산
  List<CardPosition> _calculateOneCardPositions(Size size) {
    final cardSize = _getCardSize(size, 1);
    
    return [
      CardPosition(
        x: size.width / 2,
        y: size.height / 2,
        width: cardSize.width * 1.5,
        height: cardSize.height * 1.5,
        rotation: 0,
      ),
    ];
  }
  
  // 쓰리 카드 배치 계산
  List<CardPosition> _calculateThreeCardPositions(Size size) {
    final cardSize = _getCardSize(size, 3);
    final spacing = cardSize.width * 0.3;
    final totalWidth = (cardSize.width * 3) + (spacing * 2);
    final startX = (size.width - totalWidth) / 2 + cardSize.width / 2;
    
    return List.generate(3, (index) {
      return CardPosition(
        x: startX + (index * (cardSize.width + spacing)),
        y: size.height / 2,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      );
    });
  }
  
  // 켈틱 크로스 배치 계산 - 반응형 개선
  List<CardPosition> _calculateCelticCrossPositions(Size size) {
    final isSmallScreen = size.width < 380;
    final cardSize = _getOptimizedCardSize(size, 10);
    
    // 작은 화면에서는 레이아웃 조정
    final centerX = size.width * (isSmallScreen ? 0.35 : 0.38);
    final centerY = size.height * 0.5;
    final spacing = cardSize.width * (isSmallScreen ? 0.12 : 0.15);
    
    // Staff 위치 계산 - 화면 크기에 따라 조정
    final staffX = size.width * (isSmallScreen ? 0.75 : 0.72);
    final staffSpacing = cardSize.height * (isSmallScreen ? 0.06 : 0.08);
    final staffStartY = centerY - (cardSize.height * 1.4 + staffSpacing * 1.5);
    
    return [
      // 0: 현재 상황 (중앙)
      CardPosition(
        x: centerX,
        y: centerY,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      // 1: 도전/교차 (중앙, 회전)
      CardPosition(
        x: centerX,
        y: centerY,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 90,
      ),
      // 2: 의식적 목표 (위)
      CardPosition(
        x: centerX,
        y: centerY - cardSize.height - spacing,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      // 3: 무의식적 기반 (아래)
      CardPosition(
        x: centerX,
        y: centerY + cardSize.height + spacing,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      // 4: 과거 (왼쪽)
      CardPosition(
        x: centerX - cardSize.width - spacing,
        y: centerY,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      // 5: 가능한 미래 (오른쪽)
      CardPosition(
        x: centerX + cardSize.width + spacing,
        y: centerY,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      // 6-9: 오른쪽 기둥 (아래에서 위로)
      CardPosition(
        x: staffX,
        y: staffStartY + (cardSize.height + staffSpacing) * 3,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      CardPosition(
        x: staffX,
        y: staffStartY + (cardSize.height + staffSpacing) * 2,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      CardPosition(
        x: staffX,
        y: staffStartY + (cardSize.height + staffSpacing),
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      CardPosition(
        x: staffX,
        y: staffStartY,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
    ];
  }
  
  // 관계 스프레드 배치 계산 - 반응형 개선
  List<CardPosition> _calculateRelationshipPositions(Size size) {
    final isSmallScreen = size.width < 380;
    final cardSize = _getOptimizedCardSize(size, 7);
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // 화면 크기에 따른 간격 조정
    final horizontalSpacing = cardSize.width * (isSmallScreen ? 1.1 : 1.3);
    final verticalSpacing = cardSize.height * (isSmallScreen ? 0.2 : 0.25);
    
    return [
      // 0: 나 (왼쪽 위)
      CardPosition(
        x: centerX - horizontalSpacing,
        y: centerY - cardSize.height - verticalSpacing,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      // 1: 상대방 (오른쪽 위)
      CardPosition(
        x: centerX + horizontalSpacing,
        y: centerY - cardSize.height - verticalSpacing,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      // 2: 관계의 본질 (중앙)
      CardPosition(
        x: centerX,
        y: centerY,
        width: cardSize.width * (isSmallScreen ? 1.1 : 1.15),
        height: cardSize.height * (isSmallScreen ? 1.1 : 1.15),
        rotation: 0,
      ),
      // 3: 나의 감정 (왼쪽 중간)
      CardPosition(
        x: centerX - horizontalSpacing,
        y: centerY + verticalSpacing,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      // 4: 상대방의 감정 (오른쪽 중간)
      CardPosition(
        x: centerX + horizontalSpacing,
        y: centerY + verticalSpacing,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      // 5: 도전과제 (왼쪽 아래)
      CardPosition(
        x: centerX - horizontalSpacing * 0.5,
        y: centerY + cardSize.height + verticalSpacing * 2,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
      // 6: 잠재력 (오른쪽 아래)
      CardPosition(
        x: centerX + horizontalSpacing * 0.5,
        y: centerY + cardSize.height + verticalSpacing * 2,
        width: cardSize.width,
        height: cardSize.height,
        rotation: 0,
      ),
    ];
  }
  
  // 예/아니오 배치 계산 - 완전히 개선된 버전
  List<CardPosition> _calculateYesNoPositions(Size size) {
    final isSmallScreen = size.width < 380;
    final isTinyScreen = size.width < 340;
    final isMediumScreen = size.width < 500;
    
    // 극도로 작은 화면: 2-1-2 피라미드
    if (isTinyScreen) {
      return _calculateYesNoTinyLayout(size);
    }
    // 작은 화면: 개선된 2-1-2 배치
    else if (isSmallScreen) {
      return _calculateYesNoSmallLayoutImproved(size);
    }
    // 중간 화면: 다이아몬드 배치
    else if (isMediumScreen) {
      return _calculateYesNoDiamondLayout(size);
    } 
    // 큰 화면: 아치형 배치
    else {
      return _calculateYesNoArchLayout(size);
    }
  }
  
  // 극소형 화면용 (< 340px) - 컴팩트 피라미드
  List<CardPosition> _calculateYesNoTinyLayout(Size size) {
    final cardSize = _getCardSize(size, 5);
    final scaledWidth = cardSize.width * 0.9;
    final scaledHeight = cardSize.height * 0.9;
    
    final centerX = size.width / 2;
    final startY = size.height * 0.15;
    final verticalGap = scaledHeight * 0.85;
    
    return [
      // 상단 좌
      CardPosition(
        x: centerX - scaledWidth * 0.6,
        y: startY,
        width: scaledWidth,
        height: scaledHeight,
        rotation: -5,
      ),
      // 상단 우
      CardPosition(
        x: centerX + scaledWidth * 0.6,
        y: startY,
        width: scaledWidth,
        height: scaledHeight,
        rotation: 5,
      ),
      // 중앙 (핵심) - 더 크게
      CardPosition(
        x: centerX,
        y: startY + verticalGap,
        width: scaledWidth * 1.15,
        height: scaledHeight * 1.15,
        rotation: 0,
      ),
      // 하단 좌
      CardPosition(
        x: centerX - scaledWidth * 0.6,
        y: startY + verticalGap * 2,
        width: scaledWidth,
        height: scaledHeight,
        rotation: -5,
      ),
      // 하단 우
      CardPosition(
        x: centerX + scaledWidth * 0.6,
        y: startY + verticalGap * 2,
        width: scaledWidth,
        height: scaledHeight,
        rotation: 5,
      ),
    ];
  }
  
  // 작은 화면용 개선된 배치 (340-380px)
  List<CardPosition> _calculateYesNoSmallLayoutImproved(Size size) {
    final cardSize = _getCardSize(size, 5);
    final scaledWidth = cardSize.width;
    final scaledHeight = cardSize.height;
    final horizontalSpacing = scaledWidth * 0.7;
    
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final verticalOffset = scaledHeight * 0.8;
    
    return [
      // 상단 좌 (Yes 강함)
      CardPosition(
        x: centerX - horizontalSpacing,
        y: centerY - verticalOffset,
        width: scaledWidth,
        height: scaledHeight,
        rotation: -10,
      ),
      // 상단 우 (Yes 약함)
      CardPosition(
        x: centerX + horizontalSpacing,
        y: centerY - verticalOffset,
        width: scaledWidth,
        height: scaledHeight,
        rotation: 10,
      ),
      // 중앙 (핵심) - 강조
      CardPosition(
        x: centerX,
        y: centerY,
        width: scaledWidth * 1.2,
        height: scaledHeight * 1.2,
        rotation: 0,
      ),
      // 하단 좌 (No 약함)
      CardPosition(
        x: centerX - horizontalSpacing,
        y: centerY + verticalOffset,
        width: scaledWidth,
        height: scaledHeight,
        rotation: -10,
      ),
      // 하단 우 (No 강함)
      CardPosition(
        x: centerX + horizontalSpacing,
        y: centerY + verticalOffset,
        width: scaledWidth,
        height: scaledHeight,
        rotation: 10,
      ),
    ];
  }
  
  // 중간 화면용 다이아몬드 배치 (380-500px)
  List<CardPosition> _calculateYesNoDiamondLayout(Size size) {
    final cardSize = _getCardSize(size, 5);
    final scaledWidth = cardSize.width * 1.05;
    final scaledHeight = cardSize.height * 1.05;
    
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = scaledWidth * 1.2;
    
    return [
      // 상단 (Yes 강함)
      CardPosition(
        x: centerX,
        y: centerY - radius,
        width: scaledWidth,
        height: scaledHeight,
        rotation: 0,
      ),
      // 좌측 (Yes 약함)
      CardPosition(
        x: centerX - radius,
        y: centerY,
        width: scaledWidth,
        height: scaledHeight,
        rotation: -15,
      ),
      // 중앙 (핵심) - 크게 강조
      CardPosition(
        x: centerX,
        y: centerY,
        width: scaledWidth * 1.25,
        height: scaledHeight * 1.25,
        rotation: 0,
      ),
      // 우측 (No 약함)
      CardPosition(
        x: centerX + radius,
        y: centerY,
        width: scaledWidth,
        height: scaledHeight,
        rotation: 15,
      ),
      // 하단 (No 강함)
      CardPosition(
        x: centerX,
        y: centerY + radius,
        width: scaledWidth,
        height: scaledHeight,
        rotation: 0,
      ),
    ];
  }
  
  // 큰 화면용 아치형 배치 (500px+)
  List<CardPosition> _calculateYesNoArchLayout(Size size) {
    final cardSize = _getCardSize(size, 5);
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = cardSize.width * 1.8;
    
    // 반원 형태로 배치
    return List.generate(5, (index) {
      // -60도에서 60도까지 균등 분배
      final angle = -60 + (index * 30);
      final radian = angle * 3.14159 / 180;
      final isCenter = index == 2;
      
      return CardPosition(
        x: centerX + (radius * math.sin(radian)),
        y: centerY - (radius * math.cos(radian) * 0.5) + (isCenter ? 0 : -20),
        width: isCenter ? cardSize.width * 1.2 : cardSize.width,
        height: isCenter ? cardSize.height * 1.2 : cardSize.height,
        rotation: angle * 0.3, // 약간의 회전 효과
      );
    });
  }
  
  // 카드 사이즈 계산 - 반응형 개선
  Size _getCardSize(Size availableSize, int cardCount) {
    // 기본 카드 크기 (디바이스별 최적화)
    double baseWidth;
    double baseHeight;
    
    if (availableSize.width < 380) {
      // 작은 화면 (대부분의 스마트폰)
      baseWidth = 65;
      baseHeight = 95;
    } else if (availableSize.width < 500) {
      // 중간 화면
      baseWidth = 75;
      baseHeight = 110;
    } else {
      // 큰 화면 (태블릿, 데스크톱)
      baseWidth = 85;
      baseHeight = 125;
    }
    
    // 화면 크기에 따른 스케일 조정
    final screenScale = (availableSize.width / 400).clamp(0.7, 1.4);
    
    // 카드 수에 따른 스케일 조정
    double countScale = 1.0;
    if (cardCount >= 10) {
      countScale = 0.75;
    } else if (cardCount >= 7) {
      countScale = 0.85;
    } else if (cardCount >= 5) {
      // 5장일 때 화면 크기에 따라 다르게 조정
      countScale = availableSize.width < 380 ? 0.9 : 0.95;
    } else if (cardCount == 3) {
      countScale = 1.1;
    } else if (cardCount == 1) {
      countScale = 1.4;
    }
    
    final width = baseWidth * screenScale * countScale;
    final height = baseHeight * screenScale * countScale;
    
    return Size(width.clamp(_minCardWidth, double.infinity), height);
  }
  
  // 최적화된 카드 사이즈 계산 (7장, 10장용)
  Size _getOptimizedCardSize(Size availableSize, int cardCount) {
    double baseWidth = 80;
    double baseHeight = 120;
    
    // 화면 크기에 따른 동적 스케일
    final screenScale = (availableSize.width / 400).clamp(0.65, 1.4);
    
    // 카드 수에 따른 최적화된 스케일
    double countScale = 1.0;
    if (cardCount == 10) {
      countScale = 0.75; // 약간 증가
    } else if (cardCount == 7) {
      countScale = 0.85; // 약간 증가
    }
    
    final width = baseWidth * screenScale * countScale;
    final height = baseHeight * screenScale * countScale;
    
    return Size(width, height);
  }
  
  Widget _buildPositionedCard({
    required int index,
    required CardPosition position,
    required Size size,
  }) {
    if (index >= widget.spread.positions.length) return const SizedBox();
    
    final spreadPosition = widget.spread.positions[index];
    final card = index < widget.drawnCards.length ? widget.drawnCards[index] : null;
    
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimations[index],
        _fadeAnimations[index],
      ]),
      builder: (context, child) {
        return Positioned(
          left: position.x - (position.width / 2),
          top: position.y - (position.height / 2),
          child: Transform.rotate(
            angle: position.rotation * 3.14159 / 180,
            child: Opacity(
              opacity: _fadeAnimations[index].value,
              child: Transform.scale(
                scale: _scaleAnimations[index].value,
                child: _buildCard(
                  index: index,
                  position: spreadPosition,
                  card: card,
                  cardPosition: position,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCard({
    required int index,
    required SpreadPosition position,
    required TarotCardModel? card,
    required CardPosition cardPosition,
  }) {
    final isTouched = _touchedCards.contains(index);
    
    return GestureDetector(
      onTapDown: widget.isInteractive ? (_) {
        setState(() => _touchedCards.add(index));
      } : null,
      onTapUp: widget.isInteractive ? (_) {
        setState(() => _touchedCards.remove(index));
        widget.onCardTap?.call(index);
      } : null,
      onTapCancel: widget.isInteractive ? () {
        setState(() => _touchedCards.remove(index));
      } : null,
      child: AnimatedScale(
        scale: isTouched ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 위치 라벨 - 동적 크기 조정
            if (widget.showCardNames && _shouldShowPositionLabel(cardPosition.width))
              _buildPositionLabel(position, cardPosition.width),
            
            // 카드
            _buildCardContent(
              card: card,
              index: index,
              width: cardPosition.width,
              height: cardPosition.height,
            ),
            
            // 카드 이름 - 동적 크기 조정
            if (widget.showCardNames && card != null && _shouldShowCardName(cardPosition.width))
              _buildCardNameLabel(card, cardPosition.width),
          ],
        ),
      ),
    );
  }
  
  bool _shouldShowPositionLabel(double cardWidth) {
    // 카드 크기에 따라 라벨 표시 여부 결정
    return cardWidth >= 45;
  }
  
  bool _shouldShowCardName(double cardWidth) {
    // 카드 크기에 따라 카드 이름 표시 여부 결정
    return cardWidth >= 50;
  }
  
  Widget _buildPositionLabel(SpreadPosition position, double cardWidth) {
    // 카드 크기에 따른 동적 폰트 크기
    final fontSize = _calculateLabelFontSize(cardWidth);
    final padding = cardWidth < 60 
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 2)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: padding,
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
          fontSize: fontSize,
          color: AppColors.fogGray,
          fontWeight: FontWeight.w600,
        ),
      ),
    ).animate()
        .fadeIn(delay: const Duration(milliseconds: 300))
        .slideY(begin: -0.2, end: 0);
  }
  
  Widget _buildCardContent({
    required TarotCardModel? card,
    required int index,
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.evilGlow.withAlpha(31),
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
            width: width,
            height: height,
          )
        : _buildEmptyCard(index, width, height),
    );
  }
  
  Widget _buildEmptyCard(int index, double width, double height) {
    // 동적 폰트 크기
    final fontSize = width < 60 ? 18.0 : 24.0;
    final iconSize = width < 60 ? 16.0 : 20.0;
    
    return GlassMorphismContainer(
      width: width,
      height: height,
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
                fontSize: fontSize,
                color: AppColors.mysticPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (width > 45) ...[
              const SizedBox(height: 4),
              Icon(
                Icons.help_outline,
                color: AppColors.fogGray,
                size: iconSize,
              ),
            ],
          ],
        ),
      ),
    ).animate()
        .shimmer(
          duration: const Duration(seconds: 3),
          color: AppColors.whiteOverlay10,
          delay: Duration(milliseconds: index * 100),
        );
  }
  
  Widget _buildCardNameLabel(TarotCardModel card, double cardWidth) {
    // 카드 크기에 따른 동적 폰트 크기
    final fontSize = _calculateCardNameFontSize(cardWidth);
    
    return Container(
      margin: const EdgeInsets.only(top: 6),
      constraints: BoxConstraints(maxWidth: cardWidth + 20),
      child: Text(
        card.nameKr,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: fontSize,
          color: AppColors.textMystic,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        maxLines: cardWidth < 60 ? 1 : 2,
        overflow: TextOverflow.ellipsis,
      ),
    ).animate()
        .fadeIn(delay: const Duration(milliseconds: 400))
        .slideY(begin: 0.2, end: 0);
  }
  
  // 라벨 폰트 크기 계산
  double _calculateLabelFontSize(double cardWidth) {
    if (cardWidth < 55) return _minLabelFontSize;
    if (cardWidth < 70) return 12;
    return _defaultLabelFontSize;
  }
  
  // 카드 이름 폰트 크기 계산
  double _calculateCardNameFontSize(double cardWidth) {
    if (cardWidth < 60) return _minCardNameFontSize;
    if (cardWidth < 75) return 13;
    return _defaultCardNameFontSize;
  }
}

// 카드 위치 정보 클래스
class CardPosition {
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  
  const CardPosition({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rotation,
  });
}