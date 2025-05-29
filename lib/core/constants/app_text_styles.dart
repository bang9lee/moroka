import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headers - Gothic & Mysterious
  static TextStyle displayLarge = GoogleFonts.cinzel(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
    shadows: [
      const Shadow(
        color: AppColors.evilGlow,
        blurRadius: 20,
        offset: Offset(0, 0),
      ),
    ],
  );
  
  static TextStyle displayMedium = GoogleFonts.cinzel(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );
  
  static TextStyle displaySmall = GoogleFonts.cinzel(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
  );
  
  // Mystical Headers
  static TextStyle mysticTitle = GoogleFonts.almendra(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textMystic,
    letterSpacing: 2.0,
    shadows: [
      const Shadow(
        color: AppColors.mysticPurple,
        blurRadius: 15,
        offset: Offset(0, 2),
      ),
    ],
  );
  
  // Body Text
  static TextStyle bodyLarge = GoogleFonts.crimsonText(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );
  
  static TextStyle bodyMedium = GoogleFonts.crimsonText(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle bodySmall = GoogleFonts.crimsonText(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  // Special Text Styles
  static TextStyle cardName = GoogleFonts.uncialAntiqua(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.ghostWhite,
    letterSpacing: 1.5,
    shadows: [
      const Shadow(
        color: AppColors.blackOverlay80,
        blurRadius: 8,
        offset: Offset(2, 2),
      ),
    ],
  );
  
  static TextStyle interpretation = GoogleFonts.crimsonText(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.8,
    letterSpacing: 0.5,
  );
  
  static TextStyle whisper = GoogleFonts.dancingScript(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.fogGray,
    fontStyle: FontStyle.italic,
    letterSpacing: 1.0,
  );
  
  // Button Text
  static TextStyle buttonLarge = GoogleFonts.cinzel(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.ghostWhite,
    letterSpacing: 1.5,
  );
  
  static TextStyle buttonMedium = GoogleFonts.cinzel(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.ghostWhite,
    letterSpacing: 1.2,
  );
  
  // Chat Styles
  static TextStyle chatUser = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle chatAI = GoogleFonts.crimsonText(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.textMystic,
    height: 1.5,
    letterSpacing: 0.3,
  );
  
  // Warning & Omen Text
  static TextStyle omen = GoogleFonts.creepster(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.crimsonGlow,
    letterSpacing: 1.5,
    shadows: [
      const Shadow(
        color: AppColors.bloodMoon,
        blurRadius: 10,
        offset: Offset(0, 0),
      ),
    ],
  );
  
  // Loading & Status Text
  static TextStyle loading = GoogleFonts.orbitron(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 2.0,
  );
}