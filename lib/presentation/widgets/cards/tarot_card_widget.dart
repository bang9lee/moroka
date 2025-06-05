import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'cached_tarot_card_image.dart';
import 'card_flip_animation.dart';

/// 타로 카드 뒷면 위젯
class TarotCardBack extends StatelessWidget {
  final int index;
  final bool isSelected;
  final AnimationController? glowAnimation;
  final double width;
  final double height;

  const TarotCardBack({
    super.key,
    required this.index,
    this.isSelected = false,
    this.glowAnimation,
    this.width = 80,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? [
                  AppColors.crimsonGlow,
                  AppColors.bloodMoon,
                  AppColors.obsidianBlack,
                ]
              : [
                  AppColors.mysticPurple,
                  AppColors.deepViolet,
                  AppColors.obsidianBlack,
                ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? AppColors.omenGlow : AppColors.cardBorder,
          width: isSelected ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.omenGlow.withAlpha(153)  // 0.6 * 255
                : AppColors.evilGlow.withAlpha(102),  // 0.4 * 255
            blurRadius: isSelected ? 30 : 20,
            spreadRadius: isSelected ? 5 : 2,
          ),
          const BoxShadow(
            color: AppColors.blackOverlay60,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomPaint(
              size: Size(width, height),
              painter: const CardPatternPainter(
                color: AppColors.whiteOverlay10,
              ),
            ),
          ),
          
          // Center symbol
          _buildCenterSymbol(),
        ],
      ),
    ).animate().shimmer(
      duration: const Duration(seconds: 3),
      color: isSelected ? AppColors.omenGlow : AppColors.whiteOverlay10,
    );
  }

  Widget _buildCenterSymbol() {
    if (glowAnimation != null) {
      return AnimatedBuilder(
        animation: glowAnimation!,
        builder: (context, child) {
          return Container(
            width: width * 0.625, // 50/80 비율 유지
            height: width * 0.625,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.spiritGlow.withValues(
                    alpha: 0.4 * glowAnimation!.value,
                  ),
                  blurRadius: 20 * glowAnimation!.value,
                  spreadRadius: 10 * glowAnimation!.value,
                ),
              ],
            ),
            child: Icon(
              Icons.remove_red_eye,
              color: AppColors.ghostWhite,
              size: width * 0.375, // 30/80 비율 유지
            ),
          );
        },
      );
    }
    
    return Icon(
      Icons.remove_red_eye,
      color: AppColors.ghostWhite,
      size: width * 0.375,
    );
  }
}

/// 카드 패턴 페인터
class CardPatternPainter extends CustomPainter {
  final Color color;
  
  const CardPatternPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    // Draw geometric pattern
    const spacing = 10.0;
    
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
    
    // Draw mystical symbols in center
    _drawMysticalSymbol(canvas, size, paint);
  }
  
  void _drawMysticalSymbol(Canvas canvas, Size size, Paint paint) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      20,
      paint..strokeWidth = 1,
    );
    
    // Star pattern
    _drawStar(canvas, centerX, centerY, paint);
  }
  
  void _drawStar(Canvas canvas, double centerX, double centerY, Paint paint) {
    final path = Path();
    const starPoints = 5;
    const outerRadius = 15.0;
    const innerRadius = 7.0;
    
    for (int i = 0; i < starPoints * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * 3.14159 / starPoints) - (3.14159 / 2);
      final x = centerX + radius * _cos(angle);
      final y = centerY + radius * _sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  
  double _cos(double radians) {
    return math.cos(radians);
  }
  
  double _sin(double radians) {
    return math.sin(radians);
  }
}

/// 타로 카드 앞면 위젯
class TarotCardFront extends StatelessWidget {
  final String cardName;
  final String imagePath;
  final bool showDetails;
  final double width;
  final double height;

  const TarotCardFront({
    super.key,
    required this.cardName,
    required this.imagePath,
    this.showDetails = true,
    this.width = 200,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.cardBack,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.evilGlow.withAlpha(51),  // 0.2 * 255
            blurRadius: 15,
            spreadRadius: 2,
          ),
          const BoxShadow(
            color: AppColors.blackOverlay60,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Card image
            _buildCardImage(),
            
            // Gradient overlay
            _buildGradientOverlay(),
            
            // Card name
            if (showDetails) _buildCardName(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCardImage() {
    // Use CachedTarotCardImage for automatic caching
    return CachedTarotCardImage(
      imagePath: imagePath,
      width: width,
      height: height,
      fit: BoxFit.cover,
      cardId: cardName.replaceAll(' ', '_').toLowerCase(), // Generate card ID from name
    );
  }
  
  Widget _buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            AppColors.blackOverlay20,
            AppColors.blackOverlay40,
          ],
          stops: [0.0, 0.6, 0.85, 1.0],
        ),
      ),
    );
  }
  
  Widget _buildCardName() {
    final fontSize = _calculateFontSize();
    
    return Positioned(
      bottom: width < 100 ? 4 : 8,
      left: 4,
      right: 4,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width < 100 ? 4 : 8,
          vertical: width < 100 ? 2 : 4,
        ),
        decoration: BoxDecoration(
          color: AppColors.blackOverlay60,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          cardName,
          style: AppTextStyles.cardName.copyWith(
            fontSize: fontSize,
            shadows: const [
              Shadow(
                color: AppColors.blackOverlay80,
                blurRadius: 4,
                offset: Offset(1, 1),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
  
  double _calculateFontSize() {
    if (width < 80) return 8;
    if (width < 120) return 10;
    if (width < 160) return 12;
    return 14;
  }
}

/// 타로 카드 위젯 (뒤집기 애니메이션 포함)
class TarotCardWidget extends StatefulWidget {
  final String imagePath;
  final String? cardName;
  final bool isFlipped;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool showDetails;
  final int cardIndex;

  const TarotCardWidget({
    super.key,
    required this.imagePath,
    this.cardName,
    this.isFlipped = false,
    this.width = 200,
    this.height = 300,
    this.onTap,
    this.showDetails = true,
    this.cardIndex = 0,
  });

  @override
  State<TarotCardWidget> createState() => _TarotCardWidgetState();
}

class _TarotCardWidgetState extends State<TarotCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late bool _isFlipped;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _isFlipped = widget.isFlipped;
    if (_isFlipped) {
      _flipController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TarotCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFlipped != widget.isFlipped) {
      _toggleCard();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extract card name from image path if not provided
    String displayName = widget.cardName ?? '';
    if (displayName.isEmpty && widget.imagePath.isNotEmpty) {
      displayName = _extractCardName(widget.imagePath);
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: CardFlipAnimation(
        controller: _flipController,
        front: TarotCardBack(
          index: widget.cardIndex,
          width: widget.width,
          height: widget.height,
        ),
        back: TarotCardFront(
          cardName: displayName,
          imagePath: widget.imagePath,
          showDetails: widget.showDetails,
          width: widget.width,
          height: widget.height,
        ),
      ),
    );
  }

  String _extractCardName(String imagePath) {
    // Extract card name from image path
    // Example: "assets/images/cards/major/00_fool.png" -> "The Fool"
    final fileName = imagePath.split('/').last.split('.').first;
    final parts = fileName.split('_');
    
    if (parts.length >= 2) {
      // Remove number prefix and format name
      final name = parts.sublist(1).join(' ');
      return _formatCardName(name);
    }
    
    return fileName;
  }

  String _formatCardName(String name) {
    // Capitalize each word
    return name.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}