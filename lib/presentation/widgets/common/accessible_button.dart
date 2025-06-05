import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Accessible button widget with semantic labels
class AccessibleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String? semanticLabel;
  final IconData? icon;
  final bool isDestructive;
  final bool isLoading;
  final bool isDisabled;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.semanticLabel,
    this.icon,
    this.isDestructive = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSemanticLabel = semanticLabel ?? text;
    final isEnabled = !isDisabled && !isLoading;

    return Semantics(
      label: effectiveSemanticLabel,
      button: true,
      enabled: isEnabled,
      onTap: isEnabled ? onPressed : null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getBorderColor(),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
                    ),
                  )
                else if (icon != null) ...[
                  Icon(
                    icon,
                    color: _getTextColor(),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: _getTextColor(),
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isDisabled || isLoading) {
      return AppColors.blackOverlay20;
    }
    if (isDestructive) {
      return AppColors.bloodMoon.withAlpha(20);
    }
    return AppColors.whiteOverlay10;
  }

  Color _getBorderColor() {
    if (isDisabled || isLoading) {
      return AppColors.ashGray;
    }
    if (isDestructive) {
      return AppColors.bloodMoon;
    }
    return AppColors.whiteOverlay20;
  }

  Color _getTextColor() {
    if (isDisabled || isLoading) {
      return AppColors.ashGray;
    }
    if (isDestructive) {
      return AppColors.crimsonGlow;
    }
    return AppColors.ghostWhite;
  }
}