import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 프로덕션급 타이포그래피 시스템
/// 가독성과 시각적 계층구조를 고려한 텍스트 스타일 정의
class AppTextStyles {
  // ===== Display Headers - Gothic & Mysterious =====
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 52,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 1.8,
    height: 1.2,
    shadows: [
      Shadow(
        color: AppColors.evilGlow,
        blurRadius: 24,
        offset: Offset(0, 0),
      ),
      Shadow(
        color: AppColors.blackOverlay60,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.4,
    height: 1.3,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
    height: 1.3,
  );
  
  // ===== Mystical Headers - 한글 제목용 =====
  static const TextStyle mysticTitle = TextStyle(
    fontFamily: 'ChosunSm',
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.textMystic,
    letterSpacing: 2.5,
    height: 1.4,
    shadows: [
      Shadow(
        color: AppColors.mysticPurple,
        blurRadius: 20,
        offset: Offset(0, 3),
      ),
    ],
  );
  
  // ===== Section Headers - 섹션 제목용 =====
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Sunbatang',
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 0.8,
    height: 1.4,
  );
  
  // ===== Body Text - 본문 텍스트 =====
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'GuwunBatang',
    fontSize: 18,  // 카드 해석 제목용
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.6,
    letterSpacing: 0.2,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 22,  // 일반 본문용
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.6,
    letterSpacing: 0.1,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
    letterSpacing: 0,
  );
  
  // ===== Special Text Styles =====
  static const TextStyle cardName = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.ghostWhite,
    letterSpacing: 1.8,
    shadows: [
      Shadow(
        color: AppColors.blackOverlay80,
        blurRadius: 12,
        offset: Offset(3, 3),
      ),
      Shadow(
        color: AppColors.mysticPurple,
        blurRadius: 20,
        offset: Offset(0, 0),
      ),
    ],
  );
  
  // 카드 해석 전용 스타일
  static const TextStyle interpretation = TextStyle(
    fontFamily: 'SunBatang',
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.85,
    letterSpacing: 0.3,
  );
  
  // 강조된 해석 텍스트
  static const TextStyle interpretationEmphasis = TextStyle(
    fontFamily: 'SunBatang',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.ghostWhite,
    height: 1.8,
    letterSpacing: 0.4,
  );
  
  static const TextStyle whisper = TextStyle(
    fontFamily: 'SunBatang',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.fogGray,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.8,
  );
  
  // ===== Button Text =====
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: AppColors.ghostWhite,
    letterSpacing: 1.6,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.ghostWhite,
    letterSpacing: 1.3,
  );
  
  // ===== Chat Styles - 채팅 전용 =====
  static const TextStyle chatUser = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.1,
  );
  
  static const TextStyle chatAI = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textMystic,
    height: 1.6,
    letterSpacing: 0.2,
  );
  
  // ===== Warning & Omen Text =====
  static const TextStyle omen = TextStyle(
    fontFamily: 'Cinzel',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.crimsonGlow,
    letterSpacing: 1.8,
    shadows: [
      Shadow(
        color: AppColors.bloodMoon,
        blurRadius: 15,
        offset: Offset(0, 0),
      ),
    ],
  );
  
  // ===== Status & Metadata =====
  static const TextStyle loading = TextStyle(
    fontFamily: 'ChosunSm',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: 'ChosunSm',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.3,
  );
  
  // ===== Responsive Text Styles =====
  // 화면 크기에 따라 동적으로 조정되는 스타일
  static TextStyle getResponsiveBodyText(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth > 400 ? 1.1 : (screenWidth > 350 ? 1.0 : 0.9);
    
    return TextStyle(
      fontFamily: 'ChosunSm',
      fontSize: 18 * scaleFactor,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      height: 1.7,
      letterSpacing: 0.1,
    );
  }
  
  // ===== Utility Methods =====
  
  /// 긴 텍스트를 위한 최적화된 스타일
  static TextStyle getOptimizedReadingStyle({
    required double fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      fontFamily: 'ChosunSm',
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textPrimary,
      height: 1.75, // 긴 텍스트 가독성을 위한 최적 라인 높이
      letterSpacing: 0.15,
      wordSpacing: 1.2, // 단어 간격 추가
    );
  }
  
  /// 강조 텍스트를 위한 그라디언트 쉐이더
  static Shader getGradientShader({
    required Rect bounds,
    List<Color>? colors,
  }) {
    return LinearGradient(
      colors: colors ?? [
        AppColors.spiritGlow,
        AppColors.mysticPurple,
      ],
    ).createShader(bounds);
  }
}