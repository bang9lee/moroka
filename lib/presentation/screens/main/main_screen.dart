import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/utils/animation_controller_manager.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';
import '../../widgets/common/menu_bottom_sheet.dart';
import '../../widgets/common/accessible_icon_button.dart';
import 'main_viewmodel.dart';

/// 메인 스크린 - 사용자의 현재 감정 상태를 선택하는 첫 화면
/// 프로덕션 레벨의 반응형 디자인과 애니메이션이 적용됨
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with TickerProviderStateMixin, ManagedAnimationControllerMixin<MainScreen> {
  // Animation Controllers
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  
  // Animations
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  
  // Mood states list - emoji and color mapping
  List<Map<String, dynamic>> _getMoods(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {'key': 'anxious', 'name': l10n.moodAnxious, 'color': AppColors.bloodMoon, 'emoji': '😟'},
      {'key': 'lonely', 'name': l10n.moodLonely, 'color': AppColors.deepViolet, 'emoji': '😔'},
      {'key': 'curious', 'name': l10n.moodCurious, 'color': AppColors.mysticPurple, 'emoji': '🤔'},
      {'key': 'fearful', 'name': l10n.moodFearful, 'color': AppColors.shadowGray, 'emoji': '😨'},
      {'key': 'hopeful', 'name': l10n.moodHopeful, 'color': AppColors.spiritGlow, 'emoji': '😊'},
      {'key': 'confused', 'name': l10n.moodConfused, 'color': AppColors.omenGlow, 'emoji': '😕'},
      {'key': 'desperate', 'name': l10n.moodDesperate, 'color': AppColors.crimsonGlow, 'emoji': '🙏'},
      {'key': 'expectant', 'name': l10n.moodExpectant, 'color': AppColors.evilGlow, 'emoji': '😄'},
      {'key': 'mystical', 'name': l10n.moodMystical, 'color': AppColors.textMystic, 'emoji': '🔮'},
    ];
  }
  
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
      _floatingController = createManagedRepeatingController(
        tag: 'main_floating',
        duration: const Duration(seconds: 5),
        reverse: true,
      );
      
      _floatingAnimation = Tween<double>(
        begin: -8,
        end: 8,
      ).animate(CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOut,
      ));
      
      // Pulse animation for selected items
      _pulseController = createManagedRepeatingController(
        tag: 'main_pulse',
        duration: const Duration(milliseconds: 1500),
        reverse: true,
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
    // 애니메이션은 ManagedAnimationControllerMixin에서 자동 관리
  }

  Future<void> _initializeScreen() async {
    // Initialize ads in the background
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainViewModelProvider.notifier).initializeAds();
    });
  }

  @override
  void dispose() {
    // AnimationController는 ManagedAnimationControllerMixin에서 자동 정리
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
    
    // Check daily draw limit
    final dailyDrawData = ref.read(dailyDrawDataProvider);
    
    dailyDrawData.when(
      data: (data) async {
        if (data.totalDrawsRemaining <= 0) {
          // 횟수가 없으면 광고 시청 유도
          _showDrawLimitDialog();
          return;
        }
        
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
      },
      loading: () {},
      error: (_, __) {
        // 에러시에도 진행 가능하도록
        _navigateToSpreadSelection();
      },
    );
  }
  
  Future<void> _navigateToSpreadSelection() async {
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
  
  void _showDrawLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassMorphismContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.hourglass_empty,
                color: AppColors.crimsonGlow,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.dailyLimitReached,
                style: AppTextStyles.dialogTitle.copyWith(
                  color: AppColors.ghostWhite,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.watchAdForMore,
                style: AppTextStyles.dialogContent.copyWith(
                  color: AppColors.fogGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: AppTextStyles.dialogButton.copyWith(
                          color: AppColors.fogGray,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _watchAdForDraw();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.crimsonGlow,
                        foregroundColor: AppColors.ghostWhite,
                        textStyle: AppTextStyles.dialogButton.copyWith(
                          fontSize: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.watchAd),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _watchAdForDraw() async {
    final adRepository = ref.read(adRepositoryProvider);
    final l10n = AppLocalizations.of(context)!;
    
    final success = await adRepository.showRewardedAd(
      onRewarded: () async {
        // 광고 시청 성공시 뽑기 횟수 추가
        await ref.read(dailyDrawDataProvider.notifier).addAdDraw();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.celebration,
                    color: AppColors.ghostWhite,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.drawAddedMessage,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.ghostWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.deepViolet,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppColors.mysticPurple.withAlpha(100),
                  width: 1,
                ),
              ),
              margin: const EdgeInsets.all(20),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
    );
    
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.ghostWhite,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.adLoadFailed,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.ghostWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.bloodMoon,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.crimsonGlow.withAlpha(100),
              width: 1,
            ),
          ),
          margin: const EdgeInsets.all(20),
          duration: const Duration(seconds: 3),
        ),
      );
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
              // AppBar
              _buildAppBar(currentUser),
              
              // Main Content - Expanded로 감싸서 남은 공간 모두 사용
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return _buildMainContent(
                      constraints: constraints,
                      screenSize: screenSize,
                      isSmallScreen: isSmallScreen,
                      isTinyScreen: isTinyScreen,
                      isNarrowScreen: isNarrowScreen,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AsyncValue<UserModel?> currentUser) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User info
              Flexible(
                child: _buildUserInfo(currentUser, context),
              ),
              
              // Menu button
              _buildMenuButton(),
            ],
          ),
        ),
        // 남은 횟수 표시를 여기로 이동
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildDrawCountIndicator(),
        ),
      ],
    );
  }

  Widget _buildUserInfo(AsyncValue<UserModel?> currentUser, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return currentUser.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        
        final displayName = user.displayName ?? 
            user.email.split('@').first;
            
        return Semantics(
          label: '${l10n.currentUser}: $displayName',
          child: GlassMorphismContainer(
            height: 48,  // Minimum touch target height
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
          ),
        ).animate()
            .fadeIn(duration: const Duration(milliseconds: 600))
            .slideX(begin: -0.2, end: 0);
      },
      loading: () => const SizedBox(
        height: 48,
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
    final l10n = AppLocalizations.of(context)!;
    return GlassMorphismContainer(
      width: 48,  // Increased to ensure minimum touch target
      height: 48,
      backgroundColor: AppColors.blackOverlay40,
      borderColor: AppColors.whiteOverlay10,
      child: Center(
        child: AccessibleIconButton(
          icon: Icons.menu,
          onPressed: _showMenu,
          semanticLabel: l10n.openMenu,
          color: AppColors.ghostWhite,
          size: 22,
          tooltip: l10n.openMenu,
          padding: EdgeInsets.zero,  // Container already provides padding
        ),
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildMainContent({
    required BoxConstraints constraints,
    required Size screenSize,
    required bool isSmallScreen,
    required bool isTinyScreen,
    required bool isNarrowScreen,
  }) {
    final availableHeight = constraints.maxHeight;
    
    // 비율 기반 레이아웃 - 화면 크기에 따라 동적으로 조정
    final logoSection = isTinyScreen ? 0.25 : (isSmallScreen ? 0.28 : 0.30);
    const questionSection = 0.08;
    final gridSection = isTinyScreen ? 0.45 : (isSmallScreen ? 0.42 : 0.40);
    const buttonSection = 0.15;
    
    // 최소 간격 보장
    final minSpacing = isTinyScreen ? 8.0 : 12.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: minSpacing,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Section
          SizedBox(
            height: availableHeight * logoSection,
            child: Center(
              child: _buildLogo(
                screenSize: screenSize,
                isSmallScreen: isSmallScreen,
                isTinyScreen: isTinyScreen,
              ),
            ),
          ),
          
          // Question Text
          SizedBox(
            height: availableHeight * questionSection,
            child: Center(
              child: _buildQuestionText(
                isSmallScreen: isSmallScreen,
                isTinyScreen: isTinyScreen,
              ),
            ),
          ),
          
          // Mood Grid - Flexible로 감싸서 남은 공간 활용
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: availableHeight * gridSection,
              ),
              child: Center(
                child: _buildMoodGrid(
                  screenSize: screenSize,
                  isSmallScreen: isSmallScreen,
                  isTinyScreen: isTinyScreen,
                  isNarrowScreen: isNarrowScreen,
                  availableHeight: availableHeight * gridSection,
                ),
              ),
            ),
          ),
          
          SizedBox(height: minSpacing),
          
          // Continue Button
          SizedBox(
            height: math.min(availableHeight * buttonSection, 80),
            child: Center(
              child: _buildContinueButton(
                screenSize: screenSize,
                isSmallScreen: isSmallScreen,
                isTinyScreen: isTinyScreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo({
    required Size screenSize,
    required bool isSmallScreen,
    required bool isTinyScreen,
  }) {
    final l10n = AppLocalizations.of(context)!;
    // 화면 크기에 따라 동적으로 조정되는 로고 크기
    final logoSize = isTinyScreen ? 60.0 : (isSmallScreen ? 70.0 : 85.0);
    final titleFontSize = isTinyScreen ? 24.0 : (isSmallScreen ? 28.0 : 34.0);
    final subtitleFontSize = isTinyScreen ? 10.0 : (isSmallScreen ? 11.0 : 13.0);
    
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              
              SizedBox(height: isTinyScreen ? 8 : 12),
              
              // Title
              Text(
                l10n.appBrandName,
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
              
              const SizedBox(height: 2),
              
              // Subtitle
              Text(
                l10n.appTagline,
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
    final l10n = AppLocalizations.of(context)!;
    final fontSize = isTinyScreen ? 16.0 : (isSmallScreen ? 18.0 : 22.0);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        l10n.moodQuestion,
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
    required double availableHeight,
  }) {
    final gridWidth = math.min(screenSize.width * 0.9, 400.0);
    
    // 높이에 맞춰 그리드 파라미터 조정
    final gridParams = _getAdaptiveGridParameters(
      screenWidth: screenSize.width,
      availableHeight: availableHeight,
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
        itemCount: _getMoods(context).length,
        itemBuilder: (context, index) => _buildMoodItem(
          mood: _getMoods(context)[index],
          index: index,
          gridParams: gridParams,
        ),
      ),
    );
  }

  Map<String, double> _getAdaptiveGridParameters({
    required double screenWidth,
    required double availableHeight,
    required bool isSmallScreen,
    required bool isTinyScreen,
    required bool isNarrowScreen,
  }) {
    // 사용 가능한 높이에 따라 동적으로 조정
    final cellHeight = (availableHeight - 24) / 3; // 3행, spacing 고려
    final cellWidth = (screenWidth * 0.9 - 24) / 3; // 3열, spacing 고려
    final adaptiveAspectRatio = cellWidth / cellHeight;
    
    if (screenWidth < 320 || availableHeight < 250) {
      return {
        'fontSize': 13,
        'emojiSize': 18,
        'padding': 3,
        'spacing': 6,
        'aspectRatio': math.max(adaptiveAspectRatio, 0.7),
      };
    } else if (screenWidth < 375 || availableHeight < 300) {
      return {
        'fontSize': 13,
        'emojiSize': 20,
        'padding': 4,
        'spacing': 8,
        'aspectRatio': math.max(adaptiveAspectRatio, 0.8),
      };
    } else if (isTinyScreen || availableHeight < 350) {
      return {
        'fontSize': 13,
        'emojiSize': 22,
        'padding': 5,
        'spacing': 8,
        'aspectRatio': math.max(adaptiveAspectRatio, 0.85),
      };
    } else if (isSmallScreen || availableHeight < 400) {
      return {
        'fontSize': 13,
        'emojiSize': 24,
        'padding': 6,
        'spacing': 10,
        'aspectRatio': math.max(adaptiveAspectRatio, 0.9),
      };
    } else {
      return {
        'fontSize': 13,
        'emojiSize': 26,
        'padding': 8,
        'spacing': 10,
        'aspectRatio': math.max(adaptiveAspectRatio, 1.0),
      };
    }
  }

  Widget _buildMoodItem({
    required Map<String, dynamic> mood,
    required int index,
    required Map<String, double> gridParams,
  }) {
    final isSelected = _selectedMood == mood['key'];
    final l10n = AppLocalizations.of(context)!;
    
    return Semantics(
      button: true,
      label: '${mood['name']} ${mood['emoji']}',
      selected: isSelected,
      hint: isSelected ? l10n.currentlySelected : l10n.tapToSelect,
      child: GestureDetector(
        onTap: () => _selectMood(mood['key']),
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
                          (mood['color'] as Color).withAlpha(140),
                          (mood['color'] as Color).withAlpha(80),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: !isSelected ? AppColors.blackOverlay40 : null,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? mood['color'] as Color
                      : AppColors.whiteOverlay20,
                  width: isSelected ? 2.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (mood['color'] as Color).withAlpha(150),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: (mood['color'] as Color).withAlpha(80),
                          blurRadius: 10,
                          spreadRadius: -2,
                        ),
                      ]
                    : [
                        const BoxShadow(
                          color: AppColors.blackOverlay40,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

  Widget _buildDrawCountIndicator() {
    final l10n = AppLocalizations.of(context)!;
    final dailyDrawData = ref.watch(dailyDrawDataProvider);
    
    return dailyDrawData.when(
      data: (data) {
        final totalRemaining = data.totalDrawsRemaining;
        final adRemaining = data.adDrawsRemaining;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.blackOverlay40,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: totalRemaining > 0 
                  ? AppColors.spiritGlow.withAlpha(100)
                  : AppColors.crimsonGlow.withAlpha(100),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                totalRemaining > 0 ? Icons.style : Icons.hourglass_empty,
                color: totalRemaining > 0 
                    ? AppColors.spiritGlow
                    : AppColors.crimsonGlow,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                totalRemaining > 0
                    ? '${l10n.remainingDraws}: $totalRemaining'
                    : l10n.noDrawsRemaining,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: totalRemaining > 0 
                      ? AppColors.ghostWhite
                      : AppColors.crimsonGlow,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (totalRemaining > 0 && adRemaining > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.omenGlow.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${l10n.adDraws}: $adRemaining',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.omenGlow,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ).animate()
          .fadeIn(duration: const Duration(milliseconds: 600))
          .slideY(begin: 0.2, end: 0);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildContinueButton({
    required Size screenSize,
    required bool isSmallScreen,
    required bool isTinyScreen,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final buttonWidth = math.min(screenSize.width * 0.85, 320.0);
    final buttonHeight = isTinyScreen ? 44.0 : (isSmallScreen ? 52.0 : 60.0);
    final fontSize = isTinyScreen ? 14.0 : (isSmallScreen ? 15.0 : 17.0);
    final iconSize = isTinyScreen ? 16.0 : (isSmallScreen ? 18.0 : 22.0);
    
    return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _selectedMood != null ? 1.0 : 0.5,
          child: Semantics(
            button: true,
            label: l10n.selectSpreadButton,
            enabled: _selectedMood != null,
            hint: _selectedMood != null 
                ? l10n.proceedToSpreadSelection 
                : l10n.selectMoodFirst,
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
                      blurRadius: 20,
                      spreadRadius: -4,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: AppColors.deepViolet.withAlpha(77),
                      blurRadius: 12,
                      spreadRadius: -6,
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
              SizedBox(width: isSmallScreen ? 8 : 10),
              Text(
                l10n.selectSpreadButton,
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
          ),
    ).animate()
        .fadeIn(
          duration: const Duration(milliseconds: 1000),
          delay: const Duration(milliseconds: 800),
        );
  }
}