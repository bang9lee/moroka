import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ChatBubbleWidget extends StatefulWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool showAvatar;
  final bool isTyping;
  final VoidCallback? onLongPress;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.showAvatar = true,
    this.isTyping = false,
    this.onLongPress,
  });

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.isUser ? 60 : 16,
        right: widget.isUser ? 16 : 60,
        bottom: 12,
      ),
      child: Row(
        mainAxisAlignment: widget.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI Avatar
          if (!widget.isUser && widget.showAvatar) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          
          // Message Content
          Flexible(
            child: Column(
              crossAxisAlignment: widget.isUser 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                // Message Bubble
                GestureDetector(
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  onLongPress: widget.onLongPress,
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Stack(
                          children: [
                            // Shadow Layer
                            if (!widget.isUser)
                              Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(20),
                                      topRight: const Radius.circular(20),
                                      bottomLeft: widget.isUser 
                                          ? const Radius.circular(20) 
                                          : const Radius.circular(4),
                                      bottomRight: widget.isUser 
                                          ? const Radius.circular(4) 
                                          : const Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: widget.isUser
                                            ? AppColors.mysticPurple.withAlpha(50)
                                            : AppColors.crimsonGlow.withAlpha(30),
                                        blurRadius: 20,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            
                            // Main Bubble
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: widget.isUser
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.mysticPurple.withAlpha(80),
                                          AppColors.deepViolet.withAlpha(60),
                                        ],
                                      )
                                    : LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.shadowGray.withAlpha(200),
                                          AppColors.obsidianBlack.withAlpha(150),
                                        ],
                                      ),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: widget.isUser 
                                      ? const Radius.circular(20) 
                                      : const Radius.circular(4),
                                  bottomRight: widget.isUser 
                                      ? const Radius.circular(4) 
                                      : const Radius.circular(20),
                                ),
                                border: Border.all(
                                  color: widget.isUser
                                      ? AppColors.mysticPurple.withAlpha(100)
                                      : AppColors.whiteOverlay10,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // AI Label (for AI messages)
                                  if (!widget.isUser && !widget.isTyping)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.crimsonGlow.withAlpha(30),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.crimsonGlow.withAlpha(50),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.auto_awesome,
                                            size: 12,
                                            color: AppColors.crimsonGlow,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '타로 마스터',
                                            style: AppTextStyles.bodySmall.copyWith(
                                              fontSize: 10,
                                              color: AppColors.crimsonGlow,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  
                                  // Message Text
                                  SelectableText(
                                    widget.message,
                                    style: widget.isUser
                                        ? AppTextStyles.chatUser.copyWith(
                                            color: AppColors.ghostWhite,
                                            fontSize: 15,
                                            height: 1.4,
                                          )
                                        : AppTextStyles.chatAI.copyWith(
                                            color: AppColors.ghostWhite,
                                            fontSize: 15,
                                            height: 1.4,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Press Effect Overlay
                            if (_isPressed)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteOverlay10,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(20),
                                      topRight: const Radius.circular(20),
                                      bottomLeft: widget.isUser 
                                          ? const Radius.circular(20) 
                                          : const Radius.circular(4),
                                      bottomRight: widget.isUser 
                                          ? const Radius.circular(4) 
                                          : const Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Timestamp & Status
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isUser) ...[
                        // Read status
                        const Icon(
                          Icons.done_all,
                          size: 14,
                          color: AppColors.mysticPurple,
                        ),
                        const SizedBox(width: 4),
                      ],
                      
                      // Timestamp
                      Text(
                        _formatTime(widget.timestamp),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.ashGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // User Avatar Space (for alignment)
          if (widget.isUser && widget.showAvatar) ...[
            const SizedBox(width: 8),
            const SizedBox(width: 36), // Avatar space
          ],
        ],
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideX(
          begin: widget.isUser ? 0.1 : -0.1,
          end: 0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.crimsonGlow,
            AppColors.bloodMoon,
          ],
        ),
        border: Border.all(
          color: AppColors.crimsonGlow.withAlpha(100),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.crimsonGlow.withAlpha(100),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.remove_red_eye,
        color: AppColors.ghostWhite,
        size: 20,
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: const Duration(seconds: 3),
      color: AppColors.whiteOverlay20,
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

// 타이핑 애니메이션 버블
class TypingBubble extends StatelessWidget {
  const TypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 60, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.crimsonGlow, AppColors.bloodMoon],
              ),
              border: Border.all(
                color: AppColors.crimsonGlow.withAlpha(100),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.remove_red_eye,
              color: AppColors.ghostWhite,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          
          // Typing Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.shadowGray.withAlpha(200),
                  AppColors.obsidianBlack.withAlpha(150),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: AppColors.whiteOverlay10,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.fogGray,
                    shape: BoxShape.circle,
                  ),
                ).animate(
                  onPlay: (controller) => controller.repeat(),
                  delay: Duration(milliseconds: index * 200),
                )
                .fadeIn(duration: const Duration(milliseconds: 300))
                .then()
                .fadeOut(duration: const Duration(milliseconds: 300));
              }),
            ),
          ),
        ],
      ),
    );
  }
}