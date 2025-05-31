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

/// 메인 스크린 - 사용자의 현재 감정 상태를 선택하는 첫 화면
/// 프로덕션 레벨의 반응형 디자인과 애니메이션이 적용됨
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  
  // Animations
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  
  // 감정 상태 목록 - 이모지와 색상 매핑
  static const List<Map<String, dynamic>> _moods = [
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
  
  // State
  String? _selectedMood;
  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _initializeScreen();
  }

  void _initializeAnimations() {
    try {
      // Floating animation for logo
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
      
      // Pulse animation for selected items
      _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      
      _pulseAnimation = Tween<double>(
        begin: 1.0,
        end: 1.05,
      ).animate(CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ));
      
      setState(() {
        _animationsInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing animations: $e');
    }
  }

  void _startAnimations() {
    _floatingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }

  Future<void> _initializeScreen() async {
    // Initialize ads in the background
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainViewModelProvider.notifier).initializeAds();
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _selectMood(String mood) async {
    // Haptic feedback
    if (await Vibration.hasVibrator() == true) {
      await Vibration.vibrate(duration: 50);
    }
    
    setState(() => _selectedMood = mood);
  }

  Future<void> _proceedToSpreadSelection() async {
    if (_selectedMood == null) return;
    
    // Strong haptic feedback
    if (await Vibration.hasVibrator() == true) {
      await Vibration.vibrate(duration: 100);
    }
    
    // Save mood to state
    ref.read(mainViewModelProvider.notifier).setUserMood(_selectedMood!);
    
    // Navigate to spread selection
    if (mounted) {
      await context.push('/spread-selection');
    }
  }

  void _showMenu() {
    // Haptic feedback
    Vibration.hasVibrator().then((hasVibrator) {
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 30);
      }
    });
    
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
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final safeAreaPadding = MediaQuery.of(context).padding;
    
    // Responsive breakpoints
    final isSmallScreen = screenHeight < 700;
    final isTinyScreen = screenHeight < 600;
    final isNarrowScreen = screenWidth < 375;
    
    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.darkGradient,
          AppColors.mysticGradient,
        ],
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(currentUser),
              Expanded(
                child: _buildMainContent(
                  screenSize: screenSize,
                  isSmallScreen: isSmallScreen,
                  isTinyScreen: isTinyScreen,
                  isNarrowScreen: isNarrowScreen,
                  safeAreaPadding: safeAreaPadding,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AsyncValue<dynamic> currentUser) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User info
          Flexible(
            child: _buildUserInfo(currentUser),
          ),
          
          // Menu button
          _buildMenuButton(),
        ],
      ),
    );
  }

  Widget _buildUserInfo(AsyncValue<dynamic> currentUser) {
    return currentUser.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        
        final displayName = user.displayName ?? 
            user.email?.split('@').first ?? 
            '영혼';
            
        return GlassMorphismContainer(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: AppColors.blackOverlay40,
          borderColor: AppColors.whiteOverlay10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildUserAvatar(),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  displayName,
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
        ).animate()
            .fadeIn(duration: const Duration(milliseconds: 600))
            .slideX(begin: -0.2, end: 0);
      },
      loading: () => const SizedBox(
        height: 45,
        width: 100,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.fogGray),
            ),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
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
    );
  }

  Widget _buildMenuButton() {
    return GlassMorphismContainer(
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
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildMainContent({
    required Size screenSize,
    required bool isSmallScreen,
    required bool isTinyScreen,
    required bool isNarrowScreen,
    required EdgeInsets safeAreaPadding,
  }) {
    // Dynamic spacing based on screen size
    final topSpacing = isTinyScreen ? 5.0 : (isSmallScreen ? 10.0 : 20.0);
    final logoBottomSpacing = isTinyScreen ? 10.0 : (isSmallScreen ? 15.0 : 25.0);
    final gridBottomSpacing = isTinyScreen ? 10.0 : (isSmallScreen ? 15.0 : 25.0);
    final bottomSpacing = isTinyScreen ? 5.0 : (isSmallScreen ? 10.0 : 20.0);
    
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        constraints: BoxConstraints(
          minHeight: screenSize.height - 
              safeAreaPadding.top - 
              safeAreaPadding.bottom - 
              69, // AppBar height
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: topSpacing),
            _buildLogo(
              screenSize: screenSize,
              isSmallScreen: isSmallScreen,
              isTinyScreen: isTinyScreen,
            ),
            SizedBox(height: logoBottomSpacing),
            _buildQuestionText(
              isSmallScreen: isSmallScreen,
              isTinyScreen: isTinyScreen,
            ),
            SizedBox(height: logoBottomSpacing),
            _buildMoodGrid(
              screenSize: screenSize,
              isSmallScreen: isSmallScreen,
              isTinyScreen: isTinyScreen,
              isNarrowScreen: isNarrowScreen,
            ),
            SizedBox(height: gridBottomSpacing),
            _buildContinueButton(
              screenSize: screenSize,
              isSmallScreen: isSmallScreen,
              isTinyScreen: isTinyScreen,
            ),
            SizedBox(height: bottomSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo({
    required Size screenSize,
    required bool isSmallScreen,
    required bool isTinyScreen,
  }) {
    // Dynamic logo size
    final logoSize = isTinyScreen ? 70.0 : (isSmallScreen ? 80.0 : 100.0);
    final titleFontSize = isTinyScreen ? 28.0 : (isSmallScreen ? 32.0 : 38.0);
    final subtitleFontSize = isTinyScreen ? 11.0 : (isSmallScreen ? 12.0 : 14.0);
    
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.5),
          child: Column(
            children: [
              // Logo Image
              Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mysticPurple.withAlpha(77),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo/icon.png',
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildFallbackLogo(logoSize);
                    },
                  ),
                ),
              ).animate()
                  .scale(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(duration: const Duration(milliseconds: 600)),
              
              const SizedBox(height: 16),
              
              // Title
              Text(
                'MOROKA',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: titleFontSize,
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
              
              // Subtitle
              Text(
                'Oracle of Shadows',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w300,
                  color: AppColors.fogGray,
                  letterSpacing: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ).animate()
                  .fadeIn(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 300),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFallbackLogo(double size) {
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
          color: AppColors.textMystic.withAlpha(128),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.auto_awesome,
        size: size * 0.4,
        color: AppColors.ghostWhite,
      ),
    );
  }

  Widget _buildQuestionText({
    required bool isSmallScreen,
    required bool isTinyScreen,
  }) {
    final fontSize = isTinyScreen ? 18.0 : (isSmallScreen ? 20.0 : 26.0);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '지금 어떤 마음이신가요?',
        style: AppTextStyles.mysticTitle.copyWith(
          fontSize: fontSize,
          height: 1.3,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
          shadows: [
            Shadow(
              color: AppColors.mysticPurple.withAlpha(128),
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

  Widget _buildMoodGrid({
    required Size screenSize,
    required bool isSmallScreen,
    required bool isTinyScreen,
    required bool isNarrowScreen,
  }) {
    final gridWidth = math.min(screenSize.width * 0.9, 400.0);
    
    // Responsive parameters
    final gridParams = _getGridParameters(
      screenWidth: screenSize.width,
      isSmallScreen: isSmallScreen,
      isTinyScreen: isTinyScreen,
      isNarrowScreen: isNarrowScreen,
    );
    
    return SizedBox(
      width: gridWidth,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: gridParams['aspectRatio']!,
          crossAxisSpacing: gridParams['spacing']!,
          mainAxisSpacing: gridParams['spacing']!,
        ),
        itemCount: _moods.length,
        itemBuilder: (context, index) => _buildMoodItem(
          mood: _moods[index],
          index: index,
          gridParams: gridParams,
        ),
      ),
    );
  }

  Map<String, double> _getGridParameters({
    required double screenWidth,
    required bool isSmallScreen,
    required bool isTinyScreen,
    required bool isNarrowScreen,
  }) {
    if (screenWidth < 320) {
      return {
        'fontSize': 9,
        'emojiSize': 20,
        'padding': 4,
        'spacing': 6,
        'aspectRatio': 0.85,
      };
    } else if (screenWidth < 375) {
      return {
        'fontSize': 10,
        'emojiSize': 24,
        'padding': 6,
        'spacing': 8,
        'aspectRatio': 0.9,
      };
    } else if (screenWidth < 414) {
      return {
        'fontSize': 11,
        'emojiSize': 28,
        'padding': 8,
        'spacing': 10,
        'aspectRatio': 1.0,
      };
    } else if (isTinyScreen) {
      return {
        'fontSize': 11,
        'emojiSize': 28,
        'padding': 8,
        'spacing': 10,
        'aspectRatio': 1.05,
      };
    } else if (isSmallScreen) {
      return {
        'fontSize': 12,
        'emojiSize': 30,
        'padding': 10,
        'spacing': 12,
        'aspectRatio': 1.1,
      };
    } else {
      return {
        'fontSize': 13,
        'emojiSize': 32,
        'padding': 10,
        'spacing': 12,
        'aspectRatio': 1.2,
      };
    }
  }

  Widget _buildMoodItem({
    required Map<String, dynamic> mood,
    required int index,
    required Map<String, double> gridParams,
  }) {
    final isSelected = _selectedMood == mood['name'];
    
    return GestureDetector(
      onTap: () => _selectMood(mood['name']),
      child: AnimatedBuilder(
        animation: isSelected && _animationsInitialized ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
        builder: (context, child) {
          final scale = isSelected && _animationsInitialized ? _pulseAnimation.value : 1.0;
          return Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(gridParams['padding']!),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          (mood['color'] as Color).withAlpha(77),
                          (mood['color'] as Color).withAlpha(26),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: !isSelected ? AppColors.blackOverlay40 : null,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? mood['color'] as Color
                      : AppColors.whiteOverlay20,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (mood['color'] as Color).withAlpha(102),
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
                    mood['emoji'] as String,
                    style: TextStyle(
                      fontSize: gridParams['emojiSize']!,
                    ),
                  ),
                  SizedBox(height: gridParams['padding']! / 2),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          mood['name'] as String,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: gridParams['fontSize']!,
                            color: isSelected
                                ? AppColors.ghostWhite
                                : AppColors.fogGray,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate()
        .scale(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
        )
        .fadeIn(
          duration: Duration(milliseconds: 600 + (index * 60)),
          delay: Duration(milliseconds: 300 + (index * 60)),
        );
  }

  Widget _buildContinueButton({
    required Size screenSize,
    required bool isSmallScreen,
    required bool isTinyScreen,
  }) {
    final buttonWidth = math.min(screenSize.width * 0.85, 320.0);
    final buttonHeight = isTinyScreen ? 48.0 : (isSmallScreen ? 56.0 : 64.0);
    final fontSize = isTinyScreen ? 15.0 : (isSmallScreen ? 16.0 : 18.0);
    final iconSize = isTinyScreen ? 18.0 : (isSmallScreen ? 20.0 : 24.0);
    
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _selectedMood != null ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: _selectedMood != null ? _proceedToSpreadSelection : null,
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            gradient: _selectedMood != null
                ? const LinearGradient(
                    colors: [
                      AppColors.mysticPurple,
                      AppColors.deepViolet,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: _selectedMood == null ? AppColors.blackOverlay40 : null,
            borderRadius: BorderRadius.circular(buttonHeight / 2),
            border: Border.all(
              color: _selectedMood != null
                  ? AppColors.mysticPurple.withAlpha(128)
                  : AppColors.whiteOverlay10,
              width: 1.5,
            ),
            boxShadow: _selectedMood != null
                ? [
                    BoxShadow(
                      color: AppColors.mysticPurple.withAlpha(102),
                      blurRadius: 24,
                      spreadRadius: -4,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.deepViolet.withAlpha(77),
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
                color: _selectedMood != null
                    ? AppColors.ghostWhite
                    : AppColors.ashGray,
                size: iconSize,
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Text(
                '타로 카드 펼치기',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: _selectedMood != null
                      ? AppColors.ghostWhite
                      : AppColors.ashGray,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ).animate(
          target: _selectedMood != null ? 1 : 0,
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