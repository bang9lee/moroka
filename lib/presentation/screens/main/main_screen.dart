import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

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
  late AnimationController _breathingController;
  late AnimationController _floatingController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _floatingAnimation;
  
  final List<String> moods = [
    '불안한',
    '외로운',
    '호기심 가득한',
    '두려운',
    '희망적인',
    '혼란스러운',
    '절망적인',
    '기대하는',
  ];
  
  String? selectedMood;

  @override
  void initState() {
    super.initState();
    
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
    
    _breathingAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
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
    
    // Initialize ads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainViewModelProvider.notifier).initializeAds();
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _selectMood(String mood) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 50);
    }
    setState(() {
      selectedMood = mood;
    });
  }

  void _proceedToCardSelection() async {
    if (selectedMood == null) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 100);
    }
    
    ref.read(mainViewModelProvider.notifier).setUserMood(selectedMood!);
    if (mounted) {
      context.push('/card-selection');
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
    
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User info
                    currentUser.when(
                      data: (user) => GlassMorphismContainer(
                        height: 50,
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: AppColors.fogGray,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                user?.displayName ?? user?.email.split('@').first ?? 'User',
                                style: AppTextStyles.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),
                    
                    // Menu button
                    IconButton(
                      onPressed: _showMenu,
                      icon: const Icon(
                        Icons.menu,
                        color: AppColors.ghostWhite,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mystical orb
                      AnimatedBuilder(
                        animation: _floatingAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatingAnimation.value),
                            child: AnimatedBuilder(
                              animation: _breathingAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _breathingAnimation.value,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.mysticPurple.withAlpha(100),
                                          blurRadius: 50,
                                          spreadRadius: 20,
                                        ),
                                        BoxShadow(
                                          color: AppColors.evilGlow.withAlpha(60),
                                          blurRadius: 80,
                                          spreadRadius: 30,
                                        ),
                                      ],
                                    ),
                                    child: GlassMorphismContainer(
                                      borderRadius: 100,
                                      child: const Icon(
                                        Icons.auto_awesome,
                                        size: 80,
                                        color: AppColors.ghostWhite,
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
                          );
                        },
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Question
                      Text(
                        '오늘 당신의 영혼은\n어떤 색을 띠고 있나요?',
                        style: AppTextStyles.mysticTitle.copyWith(
                          fontSize: 28,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: const Duration(seconds: 1)),
                      
                      const SizedBox(height: 40),
                      
                      // Mood grid
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: moods.map((mood) {
                          final isSelected = selectedMood == mood;
                          return GestureDetector(
                            onTap: () => _selectMood(mood),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.mysticPurple
                                    : AppColors.blackOverlay40,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.evilGlow
                                      : AppColors.whiteOverlay20,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.evilGlow.withAlpha(100),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                mood,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isSelected
                                      ? AppColors.ghostWhite
                                      : AppColors.fogGray,
                                ),
                              ),
                            ).animate().scale(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutBack,
                            ),
                          );
                        }).toList(),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 800),
                        delay: const Duration(milliseconds: 500),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Continue button
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: selectedMood != null ? 1.0 : 0.3,
                        child: GestureDetector(
                          onTap: selectedMood != null ? _proceedToCardSelection : null,
                          child: GlassMorphismContainer(
                            width: 200,
                            height: 60,
                            backgroundColor: selectedMood != null
                                ? AppColors.crimsonGlow.withAlpha(50)
                                : AppColors.blackOverlay40,
                            borderColor: selectedMood != null
                                ? AppColors.crimsonGlow
                                : AppColors.whiteOverlay10,
                            child: Center(
                              child: Text(
                                '카드 선택하기',
                                style: AppTextStyles.buttonLarge.copyWith(
                                  color: selectedMood != null
                                      ? AppColors.ghostWhite
                                      : AppColors.ashGray,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 800),
                        delay: const Duration(milliseconds: 800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}