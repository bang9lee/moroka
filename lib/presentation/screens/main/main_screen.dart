import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
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
  late AnimationController _breathingController;
  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _glowController;
  
  // Animations
  late Animation<double> _breathingAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;
  
  // Moods with mystical theme
  final List<Map<String, dynamic>> moods = [
    {'name': AppStrings.moodAnxious, 'color': AppColors.bloodMoon, 'icon': Icons.mood_bad},
    {'name': AppStrings.moodLonely, 'color': AppColors.deepViolet, 'icon': Icons.person_outline},
    {'name': AppStrings.moodCurious, 'color': AppColors.mysticPurple, 'icon': Icons.visibility},
    {'name': AppStrings.moodFearful, 'color': AppColors.shadowGray, 'icon': Icons.warning_amber},
    {'name': AppStrings.moodHopeful, 'color': AppColors.spiritGlow, 'icon': Icons.light_mode},
    {'name': AppStrings.moodConfused, 'color': AppColors.omenGlow, 'icon': Icons.shuffle},
    {'name': AppStrings.moodDesperate, 'color': AppColors.crimsonGlow, 'icon': Icons.dark_mode},
    {'name': AppStrings.moodExpectant, 'color': AppColors.evilGlow, 'icon': Icons.star},
    {'name': AppStrings.moodMystical, 'color': AppColors.textMystic, 'icon': Icons.auto_awesome},
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
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _breathingController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
    _rotationController.repeat();
    _glowController.repeat(reverse: true);
  }

  void _initializeAds() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainViewModelProvider.notifier).initializeAds();
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _floatingController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
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
          // User info
          Flexible(
            child: currentUser.when(
              data: (user) => GlassMorphismContainer(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person,
                      color: AppColors.textMystic,
                      size: 18,
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
          
          // Menu button
          GlassMorphismContainer(
            width: 45,
            height: 45,
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
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
          vertical: isSmallScreen ? 8.0 : 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: isSmallScreen ? 10 : 20),
            _buildTarotDeckAnimation(screenSize, isSmallScreen),
            SizedBox(height: isSmallScreen ? 20 : 40),
            _buildQuestionText(isSmallScreen),
            SizedBox(height: isSmallScreen ? 20 : 30),
            _buildMoodGrid(screenSize, isSmallScreen),
            SizedBox(height: isSmallScreen ? 20 : 40),
            _buildContinueButton(screenSize, isSmallScreen),
            SizedBox(height: isSmallScreen ? 10 : 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTarotDeckAnimation(Size screenSize, bool isSmallScreen) {
    final animationSize = isSmallScreen 
        ? screenSize.width * 0.5 
        : math.min(screenSize.width * 0.7, 280.0);
    final orbSize = animationSize * 0.43;
    final cardRadius = animationSize * 0.28;
    
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: AnimatedBuilder(
            animation: _breathingAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _breathingAnimation.value,
                child: SizedBox(
                  width: animationSize,
                  height: animationSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Mystical glow effect
                      AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return Container(
                            width: animationSize,
                            height: animationSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mysticPurple
                                      .withValues(alpha: _glowAnimation.value * 0.4),
                                  blurRadius: isSmallScreen ? 40 : 60,
                                  spreadRadius: isSmallScreen ? 10 : 20,
                                ),
                                BoxShadow(
                                  color: AppColors.evilGlow
                                      .withValues(alpha: _glowAnimation.value * 0.25),
                                  blurRadius: isSmallScreen ? 60 : 100,
                                  spreadRadius: isSmallScreen ? 20 : 40,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      // Rotating tarot cards
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Stack(
                            children: List.generate(3, (index) {
                              const angle = (2 * math.pi / 3);
                              final rotatedAngle = angle * index + 
                                  _rotationAnimation.value;
                              final x = math.cos(rotatedAngle) * cardRadius;
                              final y = math.sin(rotatedAngle) * cardRadius;
                              
                              return Transform.translate(
                                offset: Offset(x, y),
                                child: Transform.rotate(
                                  angle: rotatedAngle + math.pi / 2,
                                  child: _buildTarotCard(index, isSmallScreen),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                      
                      // Center orb
                      GlassMorphismContainer(
                        width: orbSize,
                        height: orbSize,
                        borderRadius: orbSize / 2,
                        backgroundColor: AppColors.blackOverlay40,
                        child: Center(
                          child: Icon(
                            Icons.remove_red_eye,
                            size: orbSize * 0.42,
                            color: AppColors.ghostWhite,
                          ).animate(
                            onPlay: (controller) => controller.repeat(),
                          ).shimmer(
                            duration: const Duration(seconds: 3),
                            color: AppColors.spiritGlow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTarotCard(int index, bool isSmallScreen) {
    final cardColors = [
      AppColors.mysticPurple,
      AppColors.crimsonGlow,
      AppColors.deepViolet,
    ];
    
    final cardIcons = [
      Icons.star,
      Icons.brightness_3,
      Icons.local_fire_department,
    ];
    
    final cardSize = isSmallScreen ? 45.0 : 60.0;
    final cardHeight = cardSize * 1.5;
    
    return GlassMorphismContainer(
      width: cardSize,
      height: cardHeight,
      backgroundColor: cardColors[index].withValues(alpha: 0.3),
      borderColor: cardColors[index],
      child: Center(
        child: Icon(
          cardIcons[index],
          color: AppColors.ghostWhite,
          size: cardSize * 0.5,
        ),
      ),
    ).animate()
        .fadeIn(duration: Duration(milliseconds: 500 + (index * 200)))
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: Duration(milliseconds: 500 + (index * 200)),
        );
  }

  Widget _buildQuestionText(bool isSmallScreen) {
    return Text(
      AppStrings.moodQuestion,
      style: AppTextStyles.mysticTitle.copyWith(
        fontSize: isSmallScreen ? 22 : 28,
        height: 1.4,
        shadows: [
          Shadow(
            color: AppColors.mysticPurple.withValues(alpha: 0.5),
            blurRadius: 10,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    ).animate()
        .fadeIn(duration: const Duration(seconds: 1))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildMoodGrid(Size screenSize, bool isSmallScreen) {
    return Wrap(
      spacing: isSmallScreen ? 8 : 12,
      runSpacing: isSmallScreen ? 8 : 12,
      alignment: WrapAlignment.center,
      children: moods.asMap().entries.map((entry) {
        final index = entry.key;
        final mood = entry.value;
        final isSelected = selectedMood == mood['name'];
        
        return GestureDetector(
          onTap: () => _selectMood(mood['name']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 8 : 10,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? mood['color'].withValues(alpha: 0.3)
                  : AppColors.blackOverlay40,
              borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 25),
              border: Border.all(
                color: isSelected
                    ? mood['color']
                    : AppColors.whiteOverlay20,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: mood['color'].withValues(alpha: 0.5),
                        blurRadius: isSmallScreen ? 15 : 20,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  mood['icon'],
                  size: isSmallScreen ? 16 : 18,
                  color: isSelected
                      ? AppColors.ghostWhite
                      : AppColors.fogGray,
                ),
                SizedBox(width: isSmallScreen ? 6 : 8),
                Text(
                  mood['name'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: isSmallScreen ? 13 : 15,
                    color: isSelected
                        ? AppColors.ghostWhite
                        : AppColors.fogGray,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
                duration: Duration(milliseconds: 400 + (index * 50)),
                delay: Duration(milliseconds: 200 + (index * 50)),
              ),
        );
      }).toList(),
    );
  }

  Widget _buildContinueButton(Size screenSize, bool isSmallScreen) {
    final buttonWidth = math.min(screenSize.width * 0.8, 280.0);
    final buttonHeight = isSmallScreen ? 55.0 : 65.0;
    
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: selectedMood != null ? 1.0 : 0.3,
      child: GestureDetector(
        onTap: selectedMood != null ? _proceedToSpreadSelection : null,
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            gradient: selectedMood != null
                ? const LinearGradient(
                    colors: [AppColors.crimsonGlow, AppColors.bloodMoon],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: selectedMood == null ? AppColors.blackOverlay40 : null,
            borderRadius: BorderRadius.circular(buttonHeight / 2),
            border: Border.all(
              color: selectedMood != null
                  ? AppColors.crimsonGlow
                  : AppColors.whiteOverlay10,
              width: 2,
            ),
            boxShadow: selectedMood != null
                ? [
                    BoxShadow(
                      color: AppColors.crimsonGlow.withValues(alpha: 0.5),
                      blurRadius: isSmallScreen ? 15 : 20,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dashboard_customize,
                color: selectedMood != null
                    ? AppColors.ghostWhite
                    : AppColors.ashGray,
                size: isSmallScreen ? 22 : 26,
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Text(
                AppStrings.selectSpreadButton,
                style: AppTextStyles.buttonLarge.copyWith(
                  color: selectedMood != null
                      ? AppColors.ghostWhite
                      : AppColors.ashGray,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate()
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.0, 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
            ),
      ),
    ).animate()
        .fadeIn(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 800),
        );
  }
}