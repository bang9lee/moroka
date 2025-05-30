import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headers - Gothic & Mysterious (Using local Cinzel font)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
    shadows: [
      Shadow(
        color: AppColors.evilGlow,
        blurRadius: 20,
        offset: Offset(0, 0),
      ),
    ],
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
  );
  
  // Mystical Headers
  static const TextStyle mysticTitle = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textMystic,
    letterSpacing: 2.0,
    shadows: [
      Shadow(
        color: AppColors.mysticPurple,
        blurRadius: 15,
        offset: Offset(0, 2),
      ),
    ],
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(  //카드결과화면 폰트
    fontFamily: 'ChosunSm',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  // Special Text Styles
  static const TextStyle cardName = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.ghostWhite,
    letterSpacing: 1.5,
    shadows: [
      Shadow(
        color: AppColors.blackOverlay80,
        blurRadius: 8,
        offset: Offset(2, 2),
      ),
    ],
  );
  
  static const TextStyle interpretation = TextStyle(
    fontFamily: 'ChosunSm',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.8,
    letterSpacing: 0.5,
  );
  
  static const TextStyle whisper = TextStyle(
    fontFamily: 'ChosunSm',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.fogGray,
    fontStyle: FontStyle.italic,
    letterSpacing: 1.0,
  );
  
  // Button Text
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.ghostWhite,
    letterSpacing: 1.5,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.ghostWhite,
    letterSpacing: 1.2,
  );
  
  // Chat Styles
  static const TextStyle chatUser = TextStyle(
    fontFamily: 'ChosunSm',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle chatAI = TextStyle(
    fontFamily: 'ChosunSm',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.textMystic,
    height: 1.5,
    letterSpacing: 0.3,
  );
  
  // Warning & Omen Text
  static const TextStyle omen = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.crimsonGlow,
    letterSpacing: 1.5,
    shadows: [
      Shadow(
        color: AppColors.bloodMoon,
        blurRadius: 10,
        offset: Offset(0, 0),
      ),
    ],
  );
  
  // Loading & Status Text
  static const TextStyle loading = TextStyle(
    fontFamily: 'ChosunSm',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 2.0,
  );
}