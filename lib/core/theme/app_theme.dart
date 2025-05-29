import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.obsidianBlack,
    primaryColor: AppColors.mysticPurple,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.mysticPurple,
      secondary: AppColors.crimsonGlow,
      surface: AppColors.shadowGray,
      error: AppColors.bloodMoon,
      onPrimary: AppColors.ghostWhite,
      onSecondary: AppColors.ghostWhite,
      onSurface: AppColors.textPrimary,
      onError: AppColors.ghostWhite,
    ),
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.obsidianBlack,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.displaySmall,
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.cardBack,
      elevation: 8,
      shadowColor: AppColors.shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mysticPurple,
        foregroundColor: AppColors.ghostWhite,
        elevation: 8,
        shadowColor: AppColors.evilGlow,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: AppColors.evilGlow,
            width: 1,
          ),
        ),
        textStyle: AppTextStyles.buttonLarge,
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textMystic,
        textStyle: AppTextStyles.buttonMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: 24,
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 24,
    ),
    
    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.shadowGray,
      elevation: 24,
      shadowColor: AppColors.blackOverlay80,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      titleTextStyle: AppTextStyles.displaySmall,
      contentTextStyle: AppTextStyles.bodyLarge,
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.midnightVoid,
      selectedItemColor: AppColors.evilGlow,
      unselectedItemColor: AppColors.ashGray,
      elevation: 16,
      type: BottomNavigationBarType.fixed,
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.crimsonGlow,
      foregroundColor: AppColors.ghostWhite,
      elevation: 12,
      focusElevation: 16,
      hoverElevation: 16,
      highlightElevation: 20,
      shape: CircleBorder(),
    ),
    
    // Page Transitions
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,
      headlineLarge: AppTextStyles.mysticTitle,
      headlineMedium: AppTextStyles.cardName,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.buttonLarge,
      labelMedium: AppTextStyles.buttonMedium,
    ),
    
    useMaterial3: true,
  );
}