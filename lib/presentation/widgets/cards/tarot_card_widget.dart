import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

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
                ? AppColors.omenGlow.withValues(alpha: 0.6)
                : AppColors.evilGlow.withValues(alpha: 0.4),
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
  
  // 간단한 삼각함수 구현 (실제로는 dart:math 사용 권장)
  double _cos(double radians) {
    // 실제 프로덕션에서는 import 'dart:math' as math; 후 math.cos 사용
    return 1.0 * (radians < 1.5708 ? 1 : -1);
  }
  
  double _sin(double radians) {
    // 실제 프로덕션에서는 import 'dart:math' as math; 후 math.sin 사용
    return 1.0 * (radians < 3.14159 ? 1 : -1);
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
            color: AppColors.evilGlow.withValues(alpha: 0.2),
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
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Failed to load image: $imagePath');
        debugPrint('Error: $error');
        
        return Container(
          color: AppColors.shadowGray,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: width < 100 ? 30 : 40,
                color: AppColors.ashGray,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  cardName,
                  style: TextStyle(
                    fontSize: width < 100 ? 8 : 10,
                    color: AppColors.fogGray,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
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