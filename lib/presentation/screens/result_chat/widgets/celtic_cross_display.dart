import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/tarot_card_model.dart';
import '../../../../data/models/tarot_spread_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../widgets/cards/tarot_card_widget.dart';
import '../../../widgets/common/glass_morphism_container.dart';

/// Celtic Cross spread display widget with premium quality design
class CelticCrossDisplay extends StatefulWidget {
  final TarotSpread spread;
  final List<TarotCardModel> drawnCards;
  final Function(int index) onCardTap;

  const CelticCrossDisplay({
    super.key,
    required this.spread,
    required this.drawnCards,
    required this.onCardTap,
  });

  @override
  State<CelticCrossDisplay> createState() => _CelticCrossDisplayState();
}

class _CelticCrossDisplayState extends State<CelticCrossDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _patternController;
  late Animation<double> _patternAnimation;

  @override
  void initState() {
    super.initState();
    _patternController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
    _patternAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _patternController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _patternController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Stack(
      children: [
        // Celtic pattern background
        _buildCelticPatternBackground(),
        
        // Main content
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Title with premium styling
                _buildTitle(l10n.celticCrossSpread),
                const SizedBox(height: 32),

                // Cards in organized sections with enhanced layout
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cross section (cards 0-5)
                    Expanded(
                      flex: 3,
                      child: _buildCrossSection(context, locale),
                    ),
                    
                    // Divider line
                    _buildDividerLine(),
                    
                    // Staff section (cards 6-9)
                    Expanded(
                      flex: 2,
                      child: _buildStaffSection(context, locale),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Celtic pattern background
  Widget _buildCelticPatternBackground() {
    return AnimatedBuilder(
      animation: _patternAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: CelticPatternPainter(
            animation: _patternAnimation.value,
          ),
        );
      },
    );
  }

  // Premium title widget
  Widget _buildTitle(String title) {
    return GlassMorphismContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      borderRadius: 20,
      backgroundColor: AppColors.blackOverlay40,
      borderColor: AppColors.mysticPurple.withAlpha(100),
      blur: 15,
      child: Text(
        title,
        style: AppTextStyles.displaySmall.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: AppColors.ghostWhite,
          letterSpacing: 1.5,
          shadows: [
            Shadow(
              color: AppColors.mysticPurple.withAlpha(150),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  // Divider line between sections
  Widget _buildDividerLine() {
    return Container(
      width: 2,
      height: 500,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.mysticPurple.withAlpha(0),
            AppColors.mysticPurple.withAlpha(100),
            AppColors.mysticPurple.withAlpha(100),
            AppColors.mysticPurple.withAlpha(0),
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mysticPurple.withAlpha(50),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: const Duration(milliseconds: 800))
        .scaleY(begin: 0, end: 1, duration: const Duration(milliseconds: 800));
  }

  Widget _buildCrossSection(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        _buildSectionTitle(l10n.crossSection),
        const SizedBox(height: 24),
        
        // Top card (2 - Goals)
        _buildCardWithLabel(
          context: context,
          index: 2,
          locale: locale,
          label: widget.spread.positions[2].getLocalizedTitle(locale),
        ).animate()
          .fadeIn(delay: const Duration(milliseconds: 200))
          .slideY(begin: -0.3, end: 0),
        
        const SizedBox(height: 24),
        
        // Middle row: Past (4) - Center (0,1) - Future (5)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Past
            Expanded(
              child: _buildCardWithLabel(
                context: context,
                index: 4,
                locale: locale,
                label: widget.spread.positions[4].getLocalizedTitle(locale),
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 400))
                .slideX(begin: -0.3, end: 0),
            ),
            
            // Center cards (stacked with minimal overlap)
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Present card with golden glow
                  _buildCardWithLabel(
                    context: context,
                    index: 0,
                    locale: locale,
                    label: widget.spread.positions[0].getLocalizedTitle(locale),
                    hasGlow: true,
                    isLarger: true,
                  ).animate()
                    .fadeIn(delay: const Duration(milliseconds: 600))
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                  
                  // Challenge card with minimal overlap
                  Transform.rotate(
                    angle: math.pi / 2, // 90 degree rotation
                    child: Transform.translate(
                      offset: const Offset(30, -15), // Minimal overlap
                      child: _buildCardWithLabel(
                        context: context,
                        index: 1,
                        locale: locale,
                        label: widget.spread.positions[1].getLocalizedTitle(locale),
                        isChallenge: true,
                        hasGlow: true,
                      ).animate()
                        .fadeIn(delay: const Duration(milliseconds: 800))
                        .rotate(begin: 0, end: 0.1),
                    ),
                  ),
                ],
              ),
            ),
            
            // Future
            Expanded(
              child: _buildCardWithLabel(
                context: context,
                index: 5,
                locale: locale,
                label: widget.spread.positions[5].getLocalizedTitle(locale),
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 1000))
                .slideX(begin: 0.3, end: 0),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Bottom card (3 - Foundation)
        _buildCardWithLabel(
          context: context,
          index: 3,
          locale: locale,
          label: widget.spread.positions[3].getLocalizedTitle(locale),
        ).animate()
          .fadeIn(delay: const Duration(milliseconds: 1200))
          .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildStaffSection(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        _buildSectionTitle(l10n.staffSection),
        const SizedBox(height: 24),
        
        // Staff cards in vertical layout with enhanced spacing
        Column(
          children: [
            _buildCardWithLabel(
              context: context,
              index: 9,
              locale: locale,
              label: widget.spread.positions[9].getLocalizedTitle(locale),
            ).animate()
              .fadeIn(delay: const Duration(milliseconds: 1400))
              .slideX(begin: 0.3, end: 0),
            
            const SizedBox(height: 20),
            
            _buildCardWithLabel(
              context: context,
              index: 8,
              locale: locale,
              label: widget.spread.positions[8].getLocalizedTitle(locale),
            ).animate()
              .fadeIn(delay: const Duration(milliseconds: 1600))
              .slideX(begin: 0.3, end: 0),
            
            const SizedBox(height: 20),
            
            _buildCardWithLabel(
              context: context,
              index: 7,
              locale: locale,
              label: widget.spread.positions[7].getLocalizedTitle(locale),
            ).animate()
              .fadeIn(delay: const Duration(milliseconds: 1800))
              .slideX(begin: 0.3, end: 0),
            
            const SizedBox(height: 20),
            
            _buildCardWithLabel(
              context: context,
              index: 6,
              locale: locale,
              label: widget.spread.positions[6].getLocalizedTitle(locale),
            ).animate()
              .fadeIn(delay: const Duration(milliseconds: 2000))
              .slideX(begin: 0.3, end: 0),
          ],
        ),
      ],
    );
  }

  // Section title with premium styling
  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.mysticPurple.withAlpha(100),
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.textMystic,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCardWithLabel({
    required BuildContext context,
    required int index,
    required String locale,
    required String label,
    bool isChallenge = false,
    bool hasGlow = false,
    bool isLarger = false,
  }) {
    final card = widget.drawnCards[index];
    final imagePath = card.imagePath;
    
    // Card dimensions with 15% increase + 10% more for Present card
    const baseWidth = 92.0; // 80 * 1.15
    const baseHeight = 138.0; // 120 * 1.15
    final cardWidth = isLarger ? baseWidth * 1.1 : baseWidth;
    final cardHeight = isLarger ? baseHeight * 1.1 : baseHeight;
    
    return GestureDetector(
      onTap: () => widget.onCardTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Position label with glassmorphism and no clipping
          Container(
            constraints: BoxConstraints(maxWidth: cardWidth * 1.5),
            child: GlassMorphismContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: 16,
              backgroundColor: isChallenge 
                ? AppColors.crimsonGlow.withAlpha(40)
                : hasGlow
                  ? AppColors.goldenGlow.withAlpha(40)
                  : AppColors.mysticPurple.withAlpha(40),
              borderColor: isChallenge
                ? AppColors.crimsonGlow.withAlpha(150)
                : hasGlow
                  ? AppColors.goldenGlow.withAlpha(150)
                  : AppColors.mysticPurple.withAlpha(150),
              blur: 15,
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.ghostWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  shadows: const [
                    Shadow(
                      color: AppColors.blackOverlay60,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 10),
          
          // Card with enhanced shadow and glow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                // Enhanced shadow
                const BoxShadow(
                  color: AppColors.blackOverlay60,
                  blurRadius: 25,
                  spreadRadius: 3,
                  offset: Offset(0, 5),
                ),
                // Golden glow for important cards
                if (hasGlow) ...[
                  BoxShadow(
                    color: AppColors.goldenGlow.withAlpha(100),
                    blurRadius: 35,
                    spreadRadius: 8,
                  ),
                  BoxShadow(
                    color: AppColors.goldenGlow.withAlpha(50),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                ],
              ],
            ),
            child: Hero(
              tag: 'card_${card.id}_$index',
              child: TarotCardWidget(
                imagePath: imagePath,
                isFlipped: true,
                width: cardWidth,
                height: cardHeight,
              ),
            ),
          ),
          
          // Card name with improved visibility
          const SizedBox(height: 10),
          Container(
            constraints: BoxConstraints(maxWidth: cardWidth + 20),
            child: Text(
              card.getLocalizedName(locale),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.ghostWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

}

// Celtic pattern painter for background
class CelticPatternPainter extends CustomPainter {
  final double animation;

  CelticPatternPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.mysticPurple.withAlpha(10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw subtle Celtic knot patterns
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    const radius = 150.0;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + animation;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      
      canvas.drawCircle(
        Offset(x, y),
        50,
        paint,
      );
    }

    // Draw interconnecting lines
    paint.color = AppColors.mysticPurple.withAlpha(5);
    for (int i = 0; i < 8; i++) {
      final angle1 = (i * math.pi / 4) + animation;
      final angle2 = ((i + 1) * math.pi / 4) + animation;
      
      canvas.drawLine(
        Offset(
          centerX + radius * math.cos(angle1),
          centerY + radius * math.sin(angle1),
        ),
        Offset(
          centerX + radius * math.cos(angle2),
          centerY + radius * math.sin(angle2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CelticPatternPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}