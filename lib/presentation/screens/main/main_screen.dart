import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';
import '../../widgets/common/menu_bottom_sheet.dart';
import 'main_viewmodel.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _floatingController;
  
  // Animations
  late Animation<double> _floatingAnimation;
  
  // Premium Moods - 이모지로 변경
  final List<Map<String, dynamic>> moods = [
    {'name': '불안해요', 'color': AppColors.bloodMoon, 'emoji': '😟'},
    {'name': '외로워요', 'color': AppColors.deepViolet, 'emoji': '😔'},
    {'name': '궁금해요', 'color': AppColors.mysticPurple, 'emoji': '🤔'},
    {'name': '두려워요', 'color': AppColors.shadowGray, 'emoji': '😨'},
    {'name': '희망적이에요', 'color': AppColors.spiritGlow, 'emoji': '😊'},
    {'name': '혼란스러워요', 'color': AppColors.omenGlow, 'emoji': '😕'},
    {'name': '간절해요', 'color': AppColors.crimsonGlow, 'emoji': '🙏'},
    {'name': '기대돼요', 'color': AppColors.evilGlow, 'emoji': '😄'},
    {'name': '신비로워요', 'color': AppColors.textMystic, 'emoji': '🔮'},
  ];
  
  String? selectedMood;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _initializeAds();
  }

  void _initializeAnimations() {
    _floatingController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    
    _floatingAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _floatingController.repeat(reverse: true);
  }

  void _initializeAds() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainViewModelProvider.notifier).initializeAds();
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _selectMood(String mood) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 50);
    }
    setState(() {
      selectedMood = mood;
    });
  }

  Future<void> _proceedToSpreadSelection() async {
    if (selectedMood == null) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 100);
    }
    
    ref.read(mainViewModelProvider.notifier).setUserMood(selectedMood!);
    if (mounted) {
      context.push('/spread-selection');
    }
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const MenuBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(currentUser),
              Expanded(
                child: _buildMainContent(screenSize, isSmallScreen),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AsyncValue<dynamic> currentUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User info - Premium feel
          Flexible(
            child: currentUser.when(
              data: (user) => GlassMorphismContainer(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                backgroundColor: AppColors.blackOverlay40,
                borderColor: AppColors.whiteOverlay10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.mysticPurple,
                            AppColors.deepViolet,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.ghostWhite,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        user?.displayName ?? 
                        user?.email?.split('@').first ?? 
                        '영혼',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.ghostWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
          
          // Menu button - Premium design
          GlassMorphismContainer(
            width: 45,
            height: 45,
            backgroundColor: AppColors.blackOverlay40,
            borderColor: AppColors.whiteOverlay10,
            child: IconButton(
              onPressed: _showMenu,
              icon: const Icon(
                Icons.menu,
                color: AppColors.ghostWhite,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(Size screenSize, bool isSmallScreen) {
    return Column(
      children: [
        SizedBox(height: isSmallScreen ? 10 : 20),
        _buildSimpleLogo(screenSize, isSmallScreen),
        SizedBox(height: isSmallScreen ? 15 : 25),
        _buildQuestionText(isSmallScreen),
        SizedBox(height: isSmallScreen ? 15 : 25),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMoodGrid(screenSize, isSmallScreen),
                SizedBox(height: isSmallScreen ? 15 : 25),
                _buildContinueButton(screenSize, isSmallScreen),
              ],
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 5 : 10),
      ],
    );
  }

  Widget _buildSimpleLogo(Size screenSize, bool isSmallScreen) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.5),
          child: Column(
            children: [
              // 로고 이미지 (스플래시와 동일)
              Container(
                width: isSmallScreen ? 80 : 100,
                height: isSmallScreen ? 80 : 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mysticPurple.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo/icon.png',
                    width: isSmallScreen ? 80 : 100,
                    height: isSmallScreen ? 80 : 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // 로고 이미지가 없을 경우 대체 디자인
                      return Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.deepViolet,
                              AppColors.mysticPurple,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.textMystic.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 40,
                          color: AppColors.ghostWhite,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Moroka 텍스트 - 스플래시와 동일한 스타일
              Text(
                'MOROKA',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: isSmallScreen ? 32 : 38,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ghostWhite,
                  letterSpacing: 5,
                  shadows: const [
                    Shadow(
                      color: AppColors.bloodMoon,
                      blurRadius: 30,
                      offset: Offset(0, 5),
                    ),
                    Shadow(
                      color: AppColors.evilGlow,
                      blurRadius: 50,
                    ),
                  ],
                ),
              ).animate(
                onPlay: (controller) => controller.repeat(),
              ).shimmer(
                duration: const Duration(seconds: 3),
                color: AppColors.crimsonGlow,
              ),
              const SizedBox(height: 4),
              Text(
                'Oracle of Shadows',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w300,
                  color: AppColors.fogGray,
                  letterSpacing: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildQuestionText(bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '지금 어떤 마음이신가요?',
        style: AppTextStyles.mysticTitle.copyWith(
          fontSize: isSmallScreen ? 20 : 26,
          height: 1.3,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
          shadows: [
            Shadow(
              color: AppColors.mysticPurple.withValues(alpha: 0.5),
              blurRadius: 20,
            ),
          ],
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 1200))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildMoodGrid(Size screenSize, bool isSmallScreen) {
    final gridWidth = math.min(screenSize.width * 0.9, 400.0);
    
    // 화면 크기에 따른 폰트 크기 조절
    double getFontSize() {
      if (screenSize.width < 320) return 10;
      if (screenSize.width < 375) return 11;
      if (isSmallScreen) return 12;
      return 14;
    }
    
    // 화면 크기에 따른 이모지 크기 조절
    double getEmojiSize() {
      if (screenSize.width < 320) return 24;
      if (screenSize.width < 375) return 28;
      if (isSmallScreen) return 32;
      return 36;
    }
    
    return SizedBox(
      width: gridWidth,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: screenSize.width < 375 ? 1.0 : 1.2,
          crossAxisSpacing: screenSize.width < 375 ? 8 : 12,
          mainAxisSpacing: screenSize.width < 375 ? 8 : 12,
        ),
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          final isSelected = selectedMood == mood['name'];
          
          return GestureDetector(
            onTap: () => _selectMood(mood['name']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width < 375 ? 4 : 8,
                vertical: screenSize.width < 375 ? 4 : 8,
              ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          mood['color'].withValues(alpha: 0.3),
                          mood['color'].withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: !isSelected ? AppColors.blackOverlay40 : null,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? mood['color']
                      : AppColors.whiteOverlay20,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: mood['color'].withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: -2,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mood['emoji'],
                    style: TextStyle(
                      fontSize: getEmojiSize(),
                    ),
                  ),
                  SizedBox(height: screenSize.width < 375 ? 4 : 8),
                  Flexible(
                    child: Text(
                      mood['name'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: getFontSize(),
                        color: isSelected
                            ? AppColors.ghostWhite
                            : AppColors.fogGray,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ).animate()
                .scale(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                )
                .fadeIn(
                  duration: Duration(milliseconds: 600 + (index * 60)),
                  delay: Duration(milliseconds: 300 + (index * 60)),
                ),
          );
        },
      ),
    );
  }

  Widget _buildContinueButton(Size screenSize, bool isSmallScreen) {
    final buttonWidth = math.min(screenSize.width * 0.85, 320.0);
    final buttonHeight = isSmallScreen ? 56.0 : 64.0;
    
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: selectedMood != null ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: selectedMood != null ? _proceedToSpreadSelection : null,
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            gradient: selectedMood != null
                ? const LinearGradient(
                    colors: [
                      AppColors.mysticPurple,
                      AppColors.deepViolet,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: selectedMood == null ? AppColors.blackOverlay40 : null,
            borderRadius: BorderRadius.circular(buttonHeight / 2),
            border: Border.all(
              color: selectedMood != null
                  ? AppColors.mysticPurple.withValues(alpha: 0.5)
                  : AppColors.whiteOverlay10,
              width: 1.5,
            ),
            boxShadow: selectedMood != null
                ? [
                    BoxShadow(
                      color: AppColors.mysticPurple.withValues(alpha: 0.4),
                      blurRadius: 24,
                      spreadRadius: -4,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.deepViolet.withValues(alpha: 0.3),
                      blurRadius: 16,
                      spreadRadius: -8,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_fix_high,
                color: selectedMood != null
                    ? AppColors.ghostWhite
                    : AppColors.ashGray,
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: isSmallScreen ? 12 : 14),
              Text(
                '타로 카드 펼치기',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: selectedMood != null
                      ? AppColors.ghostWhite
                      : AppColors.ashGray,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ).animate(
          target: selectedMood != null ? 1 : 0,
        ).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
        ),
      ),
    ).animate()
        .fadeIn(
          duration: const Duration(milliseconds: 1000),
          delay: const Duration(milliseconds: 800),
        );
  }
}