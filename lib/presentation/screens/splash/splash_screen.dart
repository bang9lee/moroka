// File: lib/presentation/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/app_logger.dart';
import '../../widgets/common/animated_gradient_background.dart';
import 'splash_viewmodel.dart';

/// 스플래시 스크린
/// 앱 시작 시 로고와 애니메이션을 표시하고 적절한 화면으로 이동합니다.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  
  // State
  bool _isNavigating = false;
  bool _hasVibrator = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkVibrator();
    _startAnimation();
  }
  
  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );
    
    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );
  }
  
  Future<void> _checkVibrator() async {
    try {
      _hasVibrator = await Vibration.hasVibrator() == true;
    } catch (_) {
      _hasVibrator = false;
    }
  }

  Future<void> _startAnimation() async {
    // 이미 dispose된 경우 중단
    if (!mounted) return;
    
    // Trigger haptic feedback
    if (_hasVibrator) {
      try {
        await Vibration.vibrate(duration: 100);
      } catch (_) {
        // Fail silently
      }
    }
    
    // 애니메이션 시작
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _logoController.forward();
    }
    
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      _textController.forward();
    }
    
    // Navigate after animation
    await Future.delayed(const Duration(seconds: 2));
    if (mounted && !_isNavigating) {
      _navigateToNextScreen();
    }
  }
  
  void _navigateToNextScreen() {
    if (_isNavigating) return;
    _isNavigating = true;
    
    AppLogger.debug('Navigating from splash screen');
    
    try {
      ref.read(splashViewModelProvider.notifier).completeInitialization();
      
      // Check if user is logged in
      final user = FirebaseAuth.instance.currentUser;
      
      if (!mounted) return;
      
      if (user != null) {
        AppLogger.debug('User logged in, navigating to main');
        context.go('/main');
      } else {
        AppLogger.debug('User not logged in, navigating to onboarding');
        context.go('/onboarding');
      }
    } catch (e, stack) {
      AppLogger.error('Error navigating from splash', e, stack);
      
      if (mounted) {
        // 에러 발생 시 온보딩으로 이동
        context.go('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        enableParticles: true,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                _buildLogo(),
                
                const SizedBox(height: 60),
                
                // App Title
                _buildTitle(),
                
                const SizedBox(height: 80),
                
                // Loading indicator
                _buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoAnimation.value,
          child: _buildLogoImage(),
        );
      },
    );
  }
  
  Widget _buildLogoImage() {
    return Image.asset(
      'assets/images/logo/logo.png',
      width: 280,
      height: 280,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // 로고 이미지가 없을 경우 기본 아이콘 표시
        return Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.mysticPurple,
                AppColors.deepViolet,
                AppColors.obsidianBlack,
              ],
            ),
            border: Border.all(
              color: AppColors.evilGlow,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.remove_red_eye_outlined,
            size: 140,
            color: AppColors.ghostWhite,
            shadows: [
              Shadow(
                color: AppColors.evilGlow,
                blurRadius: 20,
              ),
            ],
          ),
        );
      },
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: const Duration(seconds: 3),
      color: AppColors.spiritGlow,
    );
  }
  
  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _textAnimation.value)),
            child: Column(
              children: [
                Text(
                  'MOROKA',
                  style: AppTextStyles.displayLarge.copyWith(
                    fontSize: 56,
                    letterSpacing: 8,
                    shadows: [
                      const Shadow(
                        color: AppColors.bloodMoon,
                        blurRadius: 30,
                        offset: Offset(0, 5),
                      ),
                      const Shadow(
                        color: AppColors.evilGlow,
                        blurRadius: 50,
                      ),
                    ],
                  ),
                ).animate().shimmer(
                  duration: const Duration(seconds: 2),
                  color: AppColors.crimsonGlow,
                  delay: const Duration(milliseconds: 1500),
                ),
                
                const SizedBox(height: 10),
                
                Text(
                  '불길한 속삭임',
                  style: AppTextStyles.whisper.copyWith(
                    fontSize: 24,
                    color: AppColors.fogGray,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildLoadingIndicator() {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        AppColors.evilGlow,
      ),
      strokeWidth: 2,
    ).animate(
      delay: const Duration(milliseconds: 1800),
    ).fadeIn(duration: const Duration(milliseconds: 600));
  }
}