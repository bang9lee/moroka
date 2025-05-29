import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/common/animated_gradient_background.dart';
import 'splash_viewmodel.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
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
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));
    
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // Trigger haptic feedback if available
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 100);
    }
    
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    
    // Navigate after animation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        ref.read(splashViewModelProvider.notifier).completeInitialization();
        // Check if user is logged in
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          context.go('/main');
        } else {
          context.go('/onboarding');
        }
      }
    });
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
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.evilGlow.withAlpha(
                                (100 * _glowAnimation.value).toInt(),
                              ),
                              blurRadius: 50 * _glowAnimation.value,
                              spreadRadius: 20 * _glowAnimation.value,
                            ),
                            BoxShadow(
                              color: AppColors.mysticPurple.withAlpha(
                                (60 * _glowAnimation.value).toInt(),
                              ),
                              blurRadius: 30 * _glowAnimation.value,
                              spreadRadius: 10 * _glowAnimation.value,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/logo/logo.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // 로고 이미지가 없을 경우 기본 아이콘 표시
                              return Container(
                                width: 200,
                                height: 200,
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
                                  size: 100,
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
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 60),
                
                // App Title
                AnimatedBuilder(
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
                ),
                
                const SizedBox(height: 80),
                
                // Loading indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.evilGlow,
                  ),
                  strokeWidth: 2,
                ).animate(
                  delay: const Duration(milliseconds: 1800),
                ).fadeIn(duration: const Duration(milliseconds: 600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}