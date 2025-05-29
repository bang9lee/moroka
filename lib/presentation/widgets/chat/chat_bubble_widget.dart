import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../common/glass_morphism_container.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isUser ? 50 : 0,
          right: isUser ? 0 : 50,
        ),
        child: Column(
          crossAxisAlignment: 
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GlassMorphismContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: isUser
                  ? AppColors.mysticPurple.withAlpha(50)
                  : AppColors.bloodMoon.withAlpha(30),
              borderColor: isUser
                  ? AppColors.evilGlow
                  : AppColors.crimsonGlow,
              child: Text(
                message,
                style: isUser
                    ? AppTextStyles.chatUser
                    : AppTextStyles.chatAI,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                _formatTime(timestamp),
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  color: AppColors.ashGray,
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: const Duration(milliseconds: 300))
          .slideY(begin: 0.2, end: 0),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}