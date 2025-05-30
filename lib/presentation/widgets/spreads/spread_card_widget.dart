import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/tarot_spread_model.dart';
import '../common/glass_morphism_container.dart';

class SpreadCardWidget extends StatefulWidget {
  final TarotSpread spread;
  final VoidCallback onTap;
  
  const SpreadCardWidget({
    super.key,
    required this.spread,
    required this.onTap,
  });

  @override
  State<SpreadCardWidget> createState() => _SpreadCardWidgetState();
}

class _SpreadCardWidgetState extends State<SpreadCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }
  
  Color _getDifficultyColor() {
    switch (widget.spread.difficulty) {
      case SpreadDifficulty.beginner:
        return AppColors.spiritGlow;
      case SpreadDifficulty.intermediate:
        return AppColors.omenGlow;
      case SpreadDifficulty.advanced:
        return AppColors.crimsonGlow;
    }
  }
  
  String _getDifficultyText() {
    switch (widget.spread.difficulty) {
      case SpreadDifficulty.beginner:
        return '초급';
      case SpreadDifficulty.intermediate:
        return '중급';
      case SpreadDifficulty.advanced:
        return '고급';
    }
  }

  IconData _getSpreadIcon() {
    switch (widget.spread.type) {
      case SpreadType.oneCard:
        return Icons.style;
      case SpreadType.threeCard:
        return Icons.view_column;
      case SpreadType.celticCross:
        return Icons.apps;
      case SpreadType.relationship:
        return Icons.favorite;
      case SpreadType.yesNo:
        return Icons.help_outline;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              children: [
                // Main Card
                GlassMorphismContainer(
                  padding: EdgeInsets.zero,
                  borderColor: _isHovered
                      ? _getDifficultyColor()
                      : AppColors.whiteOverlay20,
                  borderWidth: _isHovered ? 2 : 1,
                  child: Column(
                    children: [
                      // Top Section - Visual Display
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            // Background Gradient
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _getDifficultyColor().withAlpha(40),
                                    AppColors.deepViolet.withAlpha(60),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Pattern Overlay
                            Positioned.fill(
                              child: CustomPaint(
                                painter: SpreadPatternPainter(
                                  color: AppColors.whiteOverlay10,
                                  spreadType: widget.spread.type,
                                ),
                              ),
                            ),
                            
                            // Center Content
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.blackOverlay20,
                                      border: Border.all(
                                        color: _getDifficultyColor().withAlpha(100),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      _getSpreadIcon(),
                                      color: _getDifficultyColor(),
                                      size: 30,
                                    ),
                                  ).animate(
                                    onPlay: (controller) => controller.repeat(),
                                  ).shimmer(
                                    duration: const Duration(seconds: 3),
                                    color: _getDifficultyColor().withAlpha(50),
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  
                                  // Card Count
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${widget.spread.cardCount}',
                                        style: AppTextStyles.displayLarge.copyWith(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.ghostWhite,
                                          shadows: [
                                            Shadow(
                                              color: _getDifficultyColor(),
                                              blurRadius: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '장',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: AppColors.fogGray,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Top Right Badge
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blackOverlay60,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getDifficultyColor().withAlpha(100),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _getDifficultyText(),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 11,
                                    color: _getDifficultyColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Bottom Section - Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.blackOverlay40,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: AppColors.whiteOverlay10,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Spread Name
                            Text(
                              widget.spread.nameKr,
                              style: AppTextStyles.cardName.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ghostWhite,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const SizedBox(height: 4),
                            
                            // Description (if available)
                            Text(
                              _getSpreadDescription(),
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 12,
                                color: AppColors.fogGray,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Hover Glow Effect
                if (_isHovered)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _getDifficultyColor().withAlpha(100),
                            blurRadius: 30,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideY(begin: 0.05, end: 0);
  }

  String _getSpreadDescription() {
    switch (widget.spread.type) {
      case SpreadType.oneCard:
        return '오늘의 운세와 조언';
      case SpreadType.threeCard:
        return '과거, 현재, 미래의 흐름';
      case SpreadType.celticCross:
        return '상황의 모든 측면을 분석';
      case SpreadType.relationship:
        return '관계의 역학과 미래';
      case SpreadType.yesNo:
        return '명확한 답을 위한 점술';
    }
  }
}

// Custom painter for spread patterns
class SpreadPatternPainter extends CustomPainter {
  final Color color;
  final SpreadType spreadType;

  SpreadPatternPainter({
    required this.color,
    required this.spreadType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    switch (spreadType) {
      case SpreadType.oneCard:
        _drawSingleCard(canvas, size, paint);
        break;
      case SpreadType.threeCard:
        _drawThreeCards(canvas, size, paint);
        break;
      case SpreadType.celticCross:
        _drawCelticPattern(canvas, size, paint);
        break;
      case SpreadType.relationship:
        _drawHeartPattern(canvas, size, paint);
        break;
      case SpreadType.yesNo:
        _drawQuestionPattern(canvas, size, paint);
        break;
    }
  }

  void _drawSingleCard(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 40,
      height: 60,
    );
    canvas.drawRect(rect, paint);
  }

  void _drawThreeCards(Canvas canvas, Size size, Paint paint) {
    const cardWidth = 30.0;
    const cardHeight = 45.0;
    const spacing = 10.0;
    
    for (int i = 0; i < 3; i++) {
      final x = size.width / 2 + (i - 1) * (cardWidth + spacing);
      final rect = Rect.fromCenter(
        center: Offset(x, size.height / 2),
        width: cardWidth,
        height: cardHeight,
      );
      canvas.drawRect(rect, paint);
    }
  }

  void _drawCelticPattern(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw cross
    canvas.drawLine(
      Offset(center.dx - 30, center.dy),
      Offset(center.dx + 30, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 30),
      Offset(center.dx, center.dy + 30),
      paint,
    );
    
    // Draw circle
    canvas.drawCircle(center, 25, paint);
  }

  void _drawHeartPattern(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    
    // Simple heart shape
    path.moveTo(center.dx, center.dy + 15);
    path.cubicTo(
      center.dx - 20, center.dy,
      center.dx - 20, center.dy - 15,
      center.dx, center.dy - 10,
    );
    path.cubicTo(
      center.dx + 20, center.dy - 15,
      center.dx + 20, center.dy,
      center.dx, center.dy + 15,
    );
    
    canvas.drawPath(path, paint);
  }

  void _drawQuestionPattern(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw question mark
    final textPainter = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          fontSize: 40,
          color: color,
          fontWeight: FontWeight.w300,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}