import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../common/glass_morphism_container.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 50),
        child: GlassMorphismContainer(
          width: null, // Changed from double.infinity
          height: null, // Changed from double.infinity
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: AppColors.bloodMoon.withAlpha(30),
          borderColor: AppColors.crimsonGlow,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(0),
              const SizedBox(width: 4),
              _buildDot(1),
              const SizedBox(width: 4),
              _buildDot(2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.fogGray,
        shape: BoxShape.circle,
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
      delay: Duration(milliseconds: index * 200),
    ).fadeIn(
      duration: const Duration(milliseconds: 300),
    ).then().fadeOut(
      duration: const Duration(milliseconds: 300),
    );
  }
}