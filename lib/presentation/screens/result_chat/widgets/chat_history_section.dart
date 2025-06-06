import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/chat_message_model.dart';
import '../../../widgets/chat/chat_bubble_widget.dart';
import '../../../widgets/chat/typing_indicator.dart';

/// 채팅 히스토리 섹션 위젯
class ChatHistorySection extends ConsumerWidget {
  final List<ChatMessageModel> chatHistory;
  final bool isTyping;
  final ScrollController scrollController;
  final AnimationController sectionAnimation;
  final AnimationController fadeInAnimation;

  const ChatHistorySection({
    super.key,
    required this.chatHistory,
    required this.isTyping,
    required this.scrollController,
    required this.sectionAnimation,
    required this.fadeInAnimation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (chatHistory.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

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
            color: AppColors.mysticPurple.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.mysticPurple.withAlpha(51),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, l10n),
              const SizedBox(height: 16),
              _buildChatList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.fogGray.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.startChatMessage,
            style: AppTextStyles.contentText.copyWith(
              color: AppColors.fogGray,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 600))
      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildSectionHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.mysticPurple.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.forum,
              color: AppColors.mysticPurple,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chatHistory,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 18,
                  ),
                ),
                Text(
                  l10n.chatHistoryDescription,
                  style: AppTextStyles.contentText.copyWith(
                    color: AppColors.fogGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        itemCount: chatHistory.length + (isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == chatHistory.length && isTyping) {
            return const Padding(
              padding: EdgeInsets.only(top: 8),
              child: TypingIndicator(),
            );
          }

          final message = chatHistory[index];
          
          // Localize special messages
          String displayMessage = message.message;
          if (!message.isUser) {
            if (message.message == 'errorApiMessage') {
              displayMessage = l10n.errorApiMessage;
            } else if (message.message.startsWith('defaultInterpretation|')) {
              final parts = message.message.split('|');
              if (parts.length == 4) {
                displayMessage = '${l10n.defaultInterpretationStart(parts[1])}\n\n'
                    '${l10n.selectedCardsLabel(parts[2])}\n\n'
                    '${l10n.cardEnergyResonance(parts[3])}\n'
                    '${l10n.deeperInterpretationComing}';
              }
            }
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ChatBubbleWidget(
              message: displayMessage,
              isUser: message.isUser,
              timestamp: message.timestamp,
            ).animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: index * 100),
              )
              .slideX(
                begin: message.isUser ? 0.1 : -0.1,
                end: 0,
                duration: const Duration(milliseconds: 300),
                delay: Duration(milliseconds: index * 100),
              ),
          );
        },
      ),
    );
  }
}