import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 60, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI Avatar
          _buildAvatar(),
          const SizedBox(width: 8),
          
          // Typing Bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.3,
            ),
            child: Stack(
              children: [
                // Shadow
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.crimsonGlow.withAlpha(30),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Main Container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AI Label
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
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
                            ).animate(
                              onPlay: (controller) => controller.repeat(),
                            ).rotate(
                              duration: const Duration(seconds: 3),
                              curve: Curves.easeInOut,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '해석 중',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.crimsonGlow,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Dots
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (index) => _buildDot(index)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideX(
        begin: -0.1,
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

  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.spiritGlow.withAlpha(100),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          
          // Dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.spiritGlow,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.whiteOverlay20,
                width: 1,
              ),
            ),
          ),
        ],
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
      delay: Duration(milliseconds: index * 200),
    )
    .scaleXY(
      begin: 0.8,
      end: 1.2,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    )
    .then()
    .scaleXY(
      begin: 1.2,
      end: 0.8,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }
}

// Alternative wave animation typing indicator
class WaveTypingIndicator extends StatelessWidget {
  const WaveTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(4, (index) {
          return Container(
            margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
            height: 24,
            width: 4,
            decoration: BoxDecoration(
              color: AppColors.spiritGlow,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.spiritGlow.withAlpha(100),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
            delay: Duration(milliseconds: index * 100),
          )
          .scaleY(
            begin: 0.4,
            end: 1.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          )
          .then()
          .scaleY(
            begin: 1.0,
            end: 0.4,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }),
      ),
    );
  }
}