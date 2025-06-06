import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/tarot_card_model.dart';
import '../../../../data/models/tarot_spread_model.dart';

/// AI 해석 섹션 위젯
class InterpretationSection extends StatelessWidget {
  final String interpretation;
  final SpreadType? spreadType;
  final List<TarotCardModel>? drawnCards;
  final AnimationController sectionAnimation;
  final AnimationController fadeInAnimation;

  const InterpretationSection({
    super.key,
    required this.interpretation,
    this.spreadType,
    this.drawnCards,
    required this.sectionAnimation,
    required this.fadeInAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FadeTransition(
      opacity: fadeInAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: sectionAnimation,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.deepPurple.withAlpha(26),
                AppColors.mysticPurple.withAlpha(13),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.mysticPurple.withAlpha(77),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, l10n),
              Padding(
                padding: const EdgeInsets.all(20),
                child: _buildFormattedInterpretation(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mysticPurple.withAlpha(26),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.mysticPurple,
                  AppColors.deepViolet,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.mysticPurple.withAlpha(77),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.interpretationSectionTitle,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 20,
                    color: AppColors.ghostWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getSpreadDescription(context, l10n),
                  style: AppTextStyles.contentText.copyWith(
                    color: AppColors.fogGray,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSpreadDescription(BuildContext context, AppLocalizations l10n) {
    if (spreadType == null) {
      return l10n.oneCardReading;
    }

    switch (spreadType!) {
      case SpreadType.oneCard:
        return l10n.oneCardReading;
      case SpreadType.threeCard:
        return l10n.threeCardReading;
      case SpreadType.celticCross:
        return l10n.celticCrossReading;
      case SpreadType.relationship:
        return l10n.relationshipReading;
      case SpreadType.yesNo:
        return l10n.yesNoReading;
    }
  }

  Widget _buildFormattedInterpretation(BuildContext context) {
    final sections = _parseInterpretation(interpretation);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.asMap().entries.map((entry) {
        final index = entry.key;
        final section = entry.value;
        
        return Padding(
          padding: EdgeInsets.only(bottom: index < sections.length - 1 ? 16 : 0),
          child: _buildSection(section['title']!, section['content']!, index),
        );
      }).toList(),
    );
  }

  List<Map<String, String>> _parseInterpretation(String text) {
    final sections = <Map<String, String>>[];
    final lines = text.split('\n');
    
    String? currentTitle;
    List<String> currentContent = [];
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      if (line.startsWith('[') && line.endsWith(']')) {
        // 이전 섹션 저장
        if (currentTitle != null && currentContent.isNotEmpty) {
          sections.add({
            'title': currentTitle,
            'content': currentContent.join('\n'),
          });
        }
        
        // 새 섹션 시작
        currentTitle = line.substring(1, line.length - 1);
        currentContent = [];
      } else {
        currentContent.add(line);
      }
    }
    
    // 마지막 섹션 저장
    if (currentTitle != null && currentContent.isNotEmpty) {
      sections.add({
        'title': currentTitle,
        'content': currentContent.join('\n'),
      });
    }
    
    // 섹션이 없으면 전체를 하나의 섹션으로
    if (sections.isEmpty) {
      sections.add({
        'title': 'AI Interpretation', // Will be localized when displayed
        'content': text,
      });
    }
    
    return sections;
  }

  Widget _buildSection(String title, String content, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.mysticPurple.withAlpha(77),
                AppColors.deepViolet.withAlpha(51),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: AppTextStyles.contentText.copyWith(
              color: AppColors.ghostWhite,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: _formatContent(content),
        ),
      ],
    ).animate()
      .fadeIn(
        duration: const Duration(milliseconds: 600),
        delay: Duration(milliseconds: 200 + (index * 150)),
      )
      .slideX(
        begin: -0.02,
        end: 0,
        duration: const Duration(milliseconds: 400),
        delay: Duration(milliseconds: 200 + (index * 150)),
      );
  }

  Widget _formatContent(String content) {
    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.trim().startsWith('•') || line.trim().startsWith('-')) {
          // 불릿 포인트
          return Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '✦',
                  style: TextStyle(
                    color: AppColors.mysticPurple,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    line.trim().substring(1).trim(),
                    style: AppTextStyles.contentText.copyWith(
                      color: AppColors.lightGray,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // 일반 텍스트
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line,
              style: AppTextStyles.contentText.copyWith(
                color: AppColors.lightGray,
                height: 1.6,
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}