import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/tarot_spread_model.dart';
import '../common/glass_morphism_container.dart';

class SpreadCardWidget extends StatelessWidget {
  final TarotSpread spread;
  final VoidCallback onTap;
  
  const SpreadCardWidget({
    super.key,
    required this.spread,
    required this.onTap,
  });
  
  Color _getDifficultyColor() {
    switch (spread.difficulty) {
      case SpreadDifficulty.beginner:
        return AppColors.spiritGlow;
      case SpreadDifficulty.intermediate:
        return AppColors.mysticPurple;
      case SpreadDifficulty.advanced:
        return AppColors.crimsonGlow;
    }
  }
  
  String _getDifficultyText() {
    switch (spread.difficulty) {
      case SpreadDifficulty.beginner:
        return '초급';
      case SpreadDifficulty.intermediate:
        return '중급';
      case SpreadDifficulty.advanced:
        return '상급';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassMorphismContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spread Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.mysticPurple.withAlpha(50),
                      AppColors.deepViolet.withAlpha(100),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.whiteOverlay20,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 카드 개수 표시
                      Text(
                        '${spread.cardCount}',
                        style: AppTextStyles.displayLarge.copyWith(
                          fontSize: 48,
                          color: AppColors.evilGlow,
                          shadows: [
                            Shadow(
                              color: AppColors.evilGlow.withAlpha(150),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '카드',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.fogGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Spread Name
            Text(
              spread.nameKr,
              style: AppTextStyles.cardName.copyWith(
                fontSize: 18,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Difficulty Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getDifficultyColor().withAlpha(50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getDifficultyColor(),
                  width: 1,
                ),
              ),
              child: Text(
                _getDifficultyText(),
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  color: _getDifficultyColor(),
                ),
              ),
            ),
          ],
        ),
      ).animate()
          .shimmer(
            duration: const Duration(seconds: 3),
            color: AppColors.whiteOverlay10,
          ),
    );
  }
}