import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const CustomLoadingIndicator({
    super.key,
    this.size = 60,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer circle
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color ?? AppColors.evilGlow,
                    width: 2,
                  ),
                ),
              ).animate(
                onPlay: (controller) => controller.repeat(),
              ).rotate(
                duration: const Duration(seconds: 3),
                curve: Curves.linear,
              ),
              
              // Inner eye
              Icon(
                Icons.remove_red_eye,
                size: size * 0.5,
                color: color ?? AppColors.evilGlow,
              ).animate(
                onPlay: (controller) => controller.repeat(),
              ).fadeIn(
                duration: const Duration(seconds: 1),
              ).then().fadeOut(
                duration: const Duration(seconds: 1),
              ).shimmer(
                duration: const Duration(seconds: 2),
                color: AppColors.spiritGlow,
              ),
              
              // Glow effect
              Container(
                width: size * 0.7,
                height: size * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (color ?? AppColors.evilGlow).withAlpha(100),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.fogGray,
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).fadeIn(duration: const Duration(seconds: 1))
              .then()
              .fadeOut(duration: const Duration(seconds: 1)),
        ],
      ],
    );
  }
}