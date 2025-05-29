import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class TarotCardBack extends StatelessWidget {
  final int index;
  final bool isSelected;
  final AnimationController? glowAnimation;

  const TarotCardBack({
    super.key,
    required this.index,
    this.isSelected = false,
    this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 80,
      height: 120,
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
                ? AppColors.omenGlow.withAlpha(150)
                : AppColors.evilGlow.withAlpha(100),
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
              size: const Size(80, 120),
              painter: CardPatternPainter(
                color: AppColors.whiteOverlay10,
              ),
            ),
          ),
          
          // Center symbol
          if (glowAnimation != null)
            AnimatedBuilder(
              animation: glowAnimation!,
              builder: (context, child) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.spiritGlow.withAlpha(
                          (100 * glowAnimation!.value).toInt(),
                        ),
                        blurRadius: 20 * glowAnimation!.value,
                        spreadRadius: 10 * glowAnimation!.value,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.remove_red_eye,
                    color: AppColors.ghostWhite,
                    size: 30,
                  ),
                );
              },
            )
          else
            const Icon(
              Icons.remove_red_eye,
              color: AppColors.ghostWhite,
              size: 30,
            ),
        ],
      ),
    ).animate().shimmer(
      duration: const Duration(seconds: 3),
      color: isSelected ? AppColors.omenGlow : AppColors.whiteOverlay10,
    );
  }
}

class CardPatternPainter extends CustomPainter {
  final Color color;
  
  CardPatternPainter({required this.color});
  
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
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      20,
      paint..strokeWidth = 1,
    );
    
    // Star pattern
    final path = Path();
    const starPoints = 5;
    const outerRadius = 15.0;
    const innerRadius = 7.0;
    
    for (int i = 0; i < starPoints * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * 3.14159 / starPoints) - (3.14159 / 2);
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);
      
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
  
  double cos(double radians) => 1.0 * (radians < 1.5708 ? 1 : -1);
  double sin(double radians) => 1.0 * (radians < 3.14159 ? 1 : -1);
}

class TarotCardFront extends StatelessWidget {
  final String cardName;
  final String imagePath;
  final bool showDetails;

  const TarotCardFront({
    super.key,
    required this.cardName,
    required this.imagePath,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.cardBack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.evilGlow.withAlpha(100),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          const BoxShadow(
            color: AppColors.blackOverlay80,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Card image
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.shadowGray,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: AppColors.ashGray,
                    ),
                  );
                },
              ),
            ),
            
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.blackOverlay40,
                      AppColors.blackOverlay80,
                    ],
                    stops: [0.5, 0.8, 1.0],
                  ),
                ),
              ),
            ),
            
            // Card name
            if (showDetails)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  cardName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ghostWhite,
                    shadows: [
                      Shadow(
                        color: AppColors.blackOverlay80,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}