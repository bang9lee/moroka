import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: '운명의 문이 열립니다',
      description: '고대의 지혜와 현대의 기술이 만나\n당신의 미래를 속삭입니다',
      icon: Icons.auto_fix_high,
      gradient: AppColors.mysticGradient,
    ),
    OnboardingPage(
      title: '어둠 속의 진실',
      description: '타로 카드는 거짓말을 하지 않습니다\n당신이 감당할 수 있는 진실만을 보여줄 뿐',
      icon: Icons.remove_red_eye,
      gradient: AppColors.bloodGradient,
    ),
    OnboardingPage(
      title: 'AI가 읽는 운명',
      description: '인공지능이 당신의 카드를 해석하고\n깊은 대화를 통해 길을 안내합니다',
      icon: Icons.psychology,
      gradient: AppColors.darkGradient,
    ),
    OnboardingPage(
      title: '준비되셨나요?',
      description: '모든 선택에는 대가가 따릅니다\n당신의 운명을 마주할 준비가 되셨다면...',
      icon: Icons.warning_amber,
      gradient: [AppColors.crimsonGlow, AppColors.bloodMoon, AppColors.obsidianBlack],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 50);
      }
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login
      if (mounted) {
        context.go('/login');
      }
    }
  }

  Future<void> _previousPage() async {
    if (_currentPage > 0) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 30);
      }
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _pages[_currentPage].gradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    if (mounted) {
                      context.go('/login');
                    }
                  },
                  child: Text(
                    'SKIP',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.fogGray,
                    ),
                  ),
                ).animate().fadeIn(duration: const Duration(milliseconds: 600)),
              ),
              
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    _animationController.forward(from: 0);
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              
              // Bottom navigation
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => _buildPageIndicator(index == _currentPage),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: _currentPage > 0 ? _previousPage : null,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _currentPage > 0 ? 1.0 : 0.0,
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
                              child: const Icon(
                                Icons.arrow_back,
                                color: AppColors.ghostWhite,
                              ),
                            ),
                          ),
                        ),
                        
                        // Next/Start button
                        GestureDetector(
                          onTap: _nextPage,
                          child: Container(
                            width: _currentPage == _pages.length - 1 ? 200 : 120,
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
                                color: AppColors.evilGlow,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.evilGlow.withAlpha(100),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _currentPage == _pages.length - 1 ? '시작하기' : 'NEXT',
                                style: AppTextStyles.buttonLarge.copyWith(
                                  color: AppColors.ghostWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with glow effect
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  AppColors.mysticPurple,
                  AppColors.deepViolet,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.evilGlow.withAlpha(100),
                  blurRadius: 50,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 80,
              color: AppColors.ghostWhite,
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Title
          Text(
            page.title,
            style: AppTextStyles.mysticTitle.copyWith(
              fontSize: 36,
              color: AppColors.ghostWhite,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Description
          Text(
            page.description,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.fogGray,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isActive ? AppColors.evilGlow : AppColors.whiteOverlay30,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.evilGlow.withAlpha(100),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}