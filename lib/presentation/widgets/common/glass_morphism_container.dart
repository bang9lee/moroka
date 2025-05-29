import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class GlassMorphismContainer extends StatelessWidget {
  final Widget child;
  final double? width;  // Made nullable
  final double? height; // Made nullable
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  const GlassMorphismContainer({
    super.key,
    required this.child,
    this.width,  // Removed default value
    this.height, // Removed default value
    this.borderRadius = 16,
    this.blur = 10,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ??
            [
              const BoxShadow(
                color: AppColors.blackOverlay40,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.evilGlow.withAlpha(30),
                blurRadius: 30,
                offset: const Offset(0, 0),
                spreadRadius: -5,
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.whiteOverlay10,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? AppColors.whiteOverlay20,
                width: borderWidth,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.whiteOverlay10,
                  AppColors.blackOverlay20,
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}