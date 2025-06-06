import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/tarot_card_model.dart';
import '../../../../data/models/tarot_spread_model.dart';
import '../../../widgets/cards/tarot_card_widget.dart';
import '../../../widgets/spreads/spread_layout_widget.dart';
import 'celtic_cross_display.dart';

/// 카드 표시 섹션 위젯
class CardDisplaySection extends StatelessWidget {
  final String cardName;
  final String cardImage;
  final SpreadType? spreadType;
  final List<TarotCardModel>? drawnCards;
  final TarotSpread? selectedSpread;
  final AnimationController fadeAnimation;
  final AnimationController slideAnimation;

  const CardDisplaySection({
    super.key,
    required this.cardName,
    required this.cardImage,
    this.spreadType,
    this.drawnCards,
    this.selectedSpread,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSpreadLayout = spreadType != null && spreadType != SpreadType.oneCard;

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.02),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: slideAnimation,
          curve: Curves.easeOutCubic,
        )),
        child: Column(
          children: [
            _buildCardHeader(context, l10n),
            const SizedBox(height: 24),
            if (isSpreadLayout && drawnCards != null && selectedSpread != null)
              _buildSpreadLayout(context)
            else
              _buildSingleCard(context),
            const SizedBox(height: 16),
            _buildCardInfo(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.mysticPurple.withAlpha(26),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.mysticPurple.withAlpha(77),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.style,
            color: AppColors.mysticPurple,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            _getCardHeaderText(context, l10n),
            style: AppTextStyles.contentText.copyWith(
              color: AppColors.ghostWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 600))
      .scale(
        begin: const Offset(0.9, 0.9),
        end: const Offset(1, 1),
        duration: const Duration(milliseconds: 400),
      );
  }

  String _getCardHeaderText(BuildContext context, AppLocalizations l10n) {
    if (spreadType == null || spreadType == SpreadType.oneCard) {
      return l10n.todaysCard;
    }
    
    switch (spreadType!) {
      case SpreadType.threeCard:
        return l10n.threeCardSpread;
      case SpreadType.celticCross:
        return l10n.celticCrossSpread;
      case SpreadType.relationship:
        return l10n.relationshipSpread;
      case SpreadType.yesNo:
        return l10n.yesNoSpread;
      default:
        return l10n.spreadReading;
    }
  }

  Widget _buildSingleCard(BuildContext context) {
    final cardImages = cardImage.split(',');
    final imagePath = cardImages.isNotEmpty ? cardImages[0].trim() : '';

    return Center(
      child: Hero(
        tag: 'card_$cardName',
        child: TarotCardWidget(
          imagePath: imagePath,
          isFlipped: true,
          width: 200,
          height: 300,
          onTap: () {
            _showCardDetail(context, cardName, imagePath);
          },
        ),
      ),
    ).animate()
      .fadeIn(
        duration: const Duration(milliseconds: 800),
        delay: const Duration(milliseconds: 200),
      )
      .scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        duration: const Duration(milliseconds: 600),
        delay: const Duration(milliseconds: 200),
      );
  }

  Widget _buildSpreadLayout(BuildContext context) {
    // Use specialized layout for Celtic Cross
    if (spreadType == SpreadType.celticCross) {
      return CelticCrossDisplay(
        spread: selectedSpread!,
        drawnCards: drawnCards!,
        onCardTap: (index) {
          final card = drawnCards![index];
          final locale = Localizations.localeOf(context).languageCode;
          final imagePath = card.imagePath;
          _showCardDetail(context, card.getLocalizedName(locale), imagePath);
        },
      );
    }
    
    // Use default layout for other spreads
    return Container(
      height: spreadType == SpreadType.relationship ? 500 : 400,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SpreadLayoutWidget(
        spread: selectedSpread!,
        drawnCards: drawnCards!,
        onCardTap: (index) {
          final card = drawnCards![index];
          final locale = Localizations.localeOf(context).languageCode;
          _showCardDetail(context, card.getLocalizedName(locale), card.imagePath);
        },
      ),
    );
  }

  Widget _buildCardInfo(BuildContext context, AppLocalizations l10n) {
    final cardNames = cardName.split(', ');
    final isMultipleCards = cardNames.length > 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          if (isMultipleCards)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: cardNames.asMap().entries.map((entry) {
                final index = entry.key;
                final name = entry.value;
                return _buildCardChip(name, index);
              }).toList(),
            )
          else
            Text(
              cardName,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.ghostWhite,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
          Text(
            isMultipleCards 
              ? l10n.cardsSelected(cardNames.length)
              : l10n.tapCardForDetails,
            style: AppTextStyles.contentText.copyWith(
              color: AppColors.fogGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(
        duration: const Duration(milliseconds: 600),
        delay: const Duration(milliseconds: 400),
      );
  }

  Widget _buildCardChip(String name, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.mysticPurple.withAlpha(51),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.mysticPurple.withAlpha(102),
          width: 1,
        ),
      ),
      child: Text(
        name,
        style: AppTextStyles.contentText.copyWith(
          color: AppColors.ghostWhite,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ).animate()
      .fadeIn(
        duration: const Duration(milliseconds: 400),
        delay: Duration(milliseconds: 600 + (index * 100)),
      )
      .scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        duration: const Duration(milliseconds: 300),
        delay: Duration(milliseconds: 600 + (index * 100)),
      );
  }

  void _showCardDetail(BuildContext context, String cardName, String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: Hero(
              tag: 'card_detail_$cardName',
              child: TarotCardWidget(
                imagePath: imagePath,
                isFlipped: true,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }

}