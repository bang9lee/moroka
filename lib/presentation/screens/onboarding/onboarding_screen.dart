import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';

/// 온보딩 스크린 - 다크 고딕 테마
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  // Controllers
  late final PageController _pageController;
  late final AnimationController _backgroundAnimationController;
  late final AnimationController _particleAnimationController;
  late final AnimationController _pulseAnimationController;
  late final AnimationController _transitionAnimationController;
  
  // State
  int _currentPage = 0;
  bool _isTransitioning = false;
  bool _hasVibrator = false;
  
  // Pages list
  late final List<OnboardingPageData> _pages;
  
  // Constants
  static const Duration _pageTransitionDuration = Duration(milliseconds: 600);
  static const Duration _animationDuration = Duration(milliseconds: 1000);
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _checkVibrationSupport();
    _startAnimations();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize pages here to have access to context
    _pages = OnboardingData.getPages(context);
  }
  
  void _initializeControllers() {
    _pageController = PageController();
    
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _particleAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _transitionAnimationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
  }
  
  Future<void> _checkVibrationSupport() async {
    try {
      _hasVibrator = await Vibration.hasVibrator() == true;
    } catch (_) {
      _hasVibrator = false;
    }
  }
  
  void _startAnimations() {
    _backgroundAnimationController.repeat();
    _particleAnimationController.repeat();
    _pulseAnimationController.repeat(reverse: true);
    _transitionAnimationController.forward();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _backgroundAnimationController.dispose();
    _particleAnimationController.dispose();
    _pulseAnimationController.dispose();
    _transitionAnimationController.dispose();
    super.dispose();
  }
  
  // Haptic feedback
  Future<void> _triggerHaptic({int duration = 30}) async {
    if (!_hasVibrator) return;
    
    try {
      await Vibration.vibrate(duration: duration);
    } catch (_) {
      // Fail silently
    }
  }
  
  // Navigation
  Future<void> _navigateToNext() async {
    if (_isTransitioning) return;
    
    setState(() => _isTransitioning = true);
    await _triggerHaptic(duration: 40);
    
    if (_currentPage < _pages.length - 1) {
      await _pageController.nextPage(
        duration: _pageTransitionDuration,
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Final page - navigate to login
      await _triggerHaptic(duration: 60);
      if (mounted) {
        context.go('/login');
      }
    }
    
    setState(() => _isTransitioning = false);
  }
  
  Future<void> _navigateToPrevious() async {
    if (_isTransitioning || _currentPage == 0) return;
    
    setState(() => _isTransitioning = true);
    await _triggerHaptic();
    
    await _pageController.previousPage(
      duration: _pageTransitionDuration,
      curve: Curves.easeInOutCubic,
    );
    
    setState(() => _isTransitioning = false);
  }
  
  Future<void> _skipOnboarding() async {
    await _triggerHaptic(duration: 20);
    if (mounted) {
      context.go('/login');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            // Animated background
            _buildAnimatedBackground(),
            
            // Mystical particles
            _buildParticleLayer(),
            
            // Content
            _buildContent(),
            
            // Overlay gradient for depth
            _buildOverlayGradient(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                math.sin(_backgroundAnimationController.value * 2 * math.pi) * 0.3,
                math.cos(_backgroundAnimationController.value * 2 * math.pi) * 0.3 - 0.5,
              ),
              end: Alignment(
                math.sin(_backgroundAnimationController.value * 2 * math.pi + math.pi) * 0.3,
                math.cos(_backgroundAnimationController.value * 2 * math.pi + math.pi) * 0.3 + 0.5,
              ),
              colors: const [
                AppColors.obsidianBlack,
                AppColors.shadowGray,
                AppColors.deepViolet,
                AppColors.obsidianBlack,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildParticleLayer() {
    return AnimatedBuilder(
      animation: _particleAnimationController,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: MysticalParticlePainter(
            animation: _particleAnimationController.value,
            particleCount: 50,
          ),
        );
      },
    );
  }
  
  Widget _buildOverlayGradient() {
    return IgnorePointer(
      child: Container(
        decoration: const BoxDecoration(
          gradient:           RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.5,
            colors: [
              Colors.transparent,
              AppColors.blackOverlay20,
              AppColors.blackOverlay40,
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: [
          // Header with skip button
          _buildHeader(),
          
          // Page content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                _transitionAnimationController.forward(from: 0);
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _OnboardingPageContent(
                  page: _pages[index],
                  animation: _transitionAnimationController,
                  pulseAnimation: _pulseAnimationController,
                );
              },
            ),
          ),
          
          // Bottom navigation
          _buildBottomNavigation(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _skipOnboarding,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.skip,
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.fogGray,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.fogGray,
                ),
              ],
            ),
          ).animate()
              .fadeIn(delay: const Duration(milliseconds: 500))
              .slideX(begin: 0.1, end: 0),
        ],
      ),
    );
  }
  
  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
      child: Column(
        children: [
          // Page indicators
          _buildPageIndicators(),
          
          const SizedBox(height: 40),
          
          // Navigation buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }
  
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => _PageIndicator(
          isActive: index == _currentPage,
          index: index,
        ),
      ),
    );
  }
  
  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == _pages.length - 1;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        _NavigationButton(
          onTap: _currentPage > 0 ? _navigateToPrevious : null,
          icon: Icons.arrow_back,
          isVisible: _currentPage > 0,
        ),
        
        // Next/Start button
        _PrimaryNavigationButton(
          onTap: _navigateToNext,
          text: isLastPage 
              ? AppLocalizations.of(context)!.openGateOfFate 
              : AppLocalizations.of(context)!.nextStep,
          isExpanded: isLastPage,
          pulseAnimation: isLastPage ? _pulseAnimationController : null,
        ),
      ],
    );
  }
}

/// 온보딩 페이지 컨텐츠
class _OnboardingPageContent extends StatelessWidget {
  final OnboardingPageData page;
  final Animation<double> animation;
  final AnimationController pulseAnimation;
  
  const _OnboardingPageContent({
    required this.page,
    required this.animation,
    required this.pulseAnimation,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final opacity = Curves.easeIn.transform(animation.value);
        final scale = 0.8 + (0.2 * Curves.elasticOut.transform(animation.value));
        
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with effects
                  _buildIconSection(),
                  
                  const SizedBox(height: 56),
                  
                  // Title
                  _buildTitle(),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  _buildDescription(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildIconSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        AnimatedBuilder(
          animation: pulseAnimation,
          builder: (context, child) {
            return Container(
              width: 200 + (pulseAnimation.value * 20),
              height: 200 + (pulseAnimation.value * 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    page.glowColor.withAlpha((100 * pulseAnimation.value).toInt()),
                    Colors.transparent,
                  ],
                ),
              ),
            );
          },
        ),
        
        // Icon container
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                page.iconGradient.first,
                page.iconGradient.last,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: page.glowColor.withAlpha(60),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Mystical pattern
              CustomPaint(
                size: const Size(160, 160),
                painter: MysticalSymbolPainter(
                  color: AppColors.whiteOverlay10,
                ),
              ),
              
              // Icon
              Icon(
                page.icon,
                size: 80,
                color: AppColors.ghostWhite,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTitle() {
    return Text(
      page.title,
      style: AppTextStyles.mysticTitle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.ghostWhite,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    ).animate()
        .fadeIn(delay: const Duration(milliseconds: 200))
        .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildDescription() {
    return Text(
      page.description,
      style: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.fogGray,
        height: 1.6,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    ).animate()
        .fadeIn(delay: const Duration(milliseconds: 400))
        .slideY(begin: 0.1, end: 0);
  }
}

/// 페이지 인디케이터
class _PageIndicator extends StatelessWidget {
  final bool isActive;
  final int index;
  
  const _PageIndicator({
    required this.isActive,
    required this.index,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isActive ? AppColors.crimsonGlow : AppColors.whiteOverlay30,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.crimsonGlow.withAlpha(100),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
        .fadeIn()
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }
}

/// 네비게이션 버튼
class _NavigationButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final bool isVisible;
  
  const _NavigationButton({
    required this.onTap,
    required this.icon,
    required this.isVisible,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: isVisible ? 1.0 : 0.8,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.whiteOverlay30,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.ghostWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 주요 네비게이션 버튼
class _PrimaryNavigationButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isExpanded;
  final AnimationController? pulseAnimation;
  
  const _PrimaryNavigationButton({
    required this.onTap,
    required this.text,
    required this.isExpanded,
    this.pulseAnimation,
  });
  
  @override
  Widget build(BuildContext context) {
    final width = isExpanded ? 220.0 : 140.0;
    
    return AnimatedBuilder(
      animation: pulseAnimation ?? const AlwaysStoppedAnimation(0),
      builder: (context, child) {
        final glowIntensity = pulseAnimation?.value ?? 0;
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: width,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.crimsonGlow,
                    AppColors.bloodMoon,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isExpanded 
                      ? AppColors.spiritGlow 
                      : AppColors.evilGlow,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.evilGlow.withAlpha(
                      (100 + (glowIntensity * 50)).toInt(),
                    ),
                    blurRadius: 20 + (glowIntensity * 10),
                    spreadRadius: 2 + (glowIntensity * 3),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    text,
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: AppColors.ghostWhite,
                      fontWeight: FontWeight.w700,
                      letterSpacing: isExpanded ? 0.5 : 1.2,
                      fontSize: isExpanded ? 14 : 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 신비로운 파티클 페인터
class MysticalParticlePainter extends CustomPainter {
  final double animation;
  final int particleCount;
  
  MysticalParticlePainter({
    required this.animation,
    required this.particleCount,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    
    for (int i = 0; i < particleCount; i++) {
      final seed = i * 0.1;
      final progress = (animation + seed) % 1.0;
      
      // Create floating path
      final x = size.width * (0.1 + 0.8 * _pseudoRandom(seed));
      final y = size.height * (1 - progress);
      
      // Sine wave movement
      final waveX = x + math.sin(progress * math.pi * 4 + seed) * 30;
      
      // Particle properties
      final opacity = math.sin(progress * math.pi) * 0.3;
      final radius = 1 + _pseudoRandom(seed + 0.5) * 2;
      
      paint.color = AppColors.mysticPurple.withAlpha((opacity * 255).toInt());
      canvas.drawCircle(Offset(waveX, y), radius, paint);
    }
  }
  
  double _pseudoRandom(double seed) {
    return (math.sin(seed * 12.9898) * 43758.5453) % 1;
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 신비로운 심볼 페인터
class MysticalSymbolPainter extends CustomPainter {
  final Color color;
  
  MysticalSymbolPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Outer circle
    canvas.drawCircle(center, radius * 0.9, paint);
    
    // Inner circles
    canvas.drawCircle(center, radius * 0.6, paint);
    canvas.drawCircle(center, radius * 0.3, paint);
    
    // Mystical star pattern
    _drawMysticalStar(canvas, center, radius * 0.7, paint);
  }
  
  void _drawMysticalStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 8;
    
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - (math.pi / 2);
      final r = i.isEven ? radius : radius * 0.5;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 온보딩 데이터
class OnboardingData {
  static List<OnboardingPageData> getPages(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return [
      OnboardingPageData(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        icon: Icons.auto_fix_high,
        iconGradient: const [AppColors.mysticPurple, AppColors.deepViolet],
        glowColor: AppColors.mysticPurple,
      ),
      OnboardingPageData(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        icon: Icons.remove_red_eye,
        iconGradient: const [AppColors.crimsonGlow, AppColors.bloodMoon],
        glowColor: AppColors.crimsonGlow,
      ),
      OnboardingPageData(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        icon: Icons.psychology_alt,
        iconGradient: const [AppColors.evilGlow, AppColors.omenGlow],
        glowColor: AppColors.evilGlow,
      ),
      OnboardingPageData(
        title: l10n.onboardingTitle4,
        description: l10n.onboardingDesc4,
        icon: Icons.warning_amber_rounded,
        iconGradient: const [AppColors.spiritGlow, AppColors.mysticPurple],
        glowColor: AppColors.spiritGlow,
      ),
    ];
  }
}

/// 온보딩 페이지 데이터
class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> iconGradient;
  final Color glowColor;
  
  OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconGradient,
    required this.glowColor,
  });
}