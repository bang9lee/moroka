import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../data/models/tarot_spread_model.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/accessible_icon_button.dart';
import '../../widgets/spreads/spread_card_widget.dart';
import 'spread_selection_viewmodel.dart';
import '../card_selection/card_selection_viewmodel.dart';
import '../result_chat/result_chat_viewmodel.dart';

class SpreadSelectionScreen extends ConsumerStatefulWidget {
  const SpreadSelectionScreen({super.key});

  @override
  ConsumerState<SpreadSelectionScreen> createState() => _SpreadSelectionScreenState();
}

class _SpreadSelectionScreenState extends ConsumerState<SpreadSelectionScreen>
    with TickerProviderStateMixin {
  // Constants
  static const Duration _animationDuration = Duration(milliseconds: 600);
  static const Duration _staggerDelay = Duration(milliseconds: 100);
  static const Duration _initialDelay = Duration(milliseconds: 300);
  static const int _tabCount = 3;
  
  // Animation Controllers
  late final TabController _tabController;
  late final List<AnimationController> _cardControllers;
  late final List<Animation<double>> _cardAnimations;
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _startInitialAnimation();
  }
  
  void _initializeControllers() {
    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    _cardControllers = List.generate(
      TarotSpread.allSpreads.length,
      (_) => AnimationController(
        duration: _animationDuration,
        vsync: this,
      ),
    );
  }
  
  void _initializeAnimations() {
    _cardAnimations = _cardControllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      );
    }).toList();
  }
  
  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _animateTabChange();
    }
  }
  
  Future<void> _startInitialAnimation() async {
    await Future.delayed(_initialDelay);
    _animateCards();
  }
  
  Future<void> _animateTabChange() async {
    // Reset animations
    for (final controller in _cardControllers) {
      controller.reset();
    }
    
    // Start new animations
    await Future.delayed(const Duration(milliseconds: 200));
    _animateCards();
  }
  
  Future<void> _animateCards() async {
    for (int i = 0; i < _cardControllers.length; i++) {
      if (!mounted) return;
      
      await Future.delayed(_staggerDelay);
      _cardControllers[i].forward();
    }
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    for (final controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  Future<void> _selectSpread(TarotSpread spread) async {
    // Haptic feedback
    if (await Vibration.hasVibrator() == true) {
      await Vibration.vibrate(duration: 100);
    }
    
    // Reset previous states
    _resetPreviousStates();
    
    // Set selected spread
    ref.read(spreadSelectionViewModelProvider.notifier).selectSpread(spread);
    
    // Navigate
    if (mounted) {
      context.push('/card-selection');
    }
  }
  
  void _resetPreviousStates() {
    ref.read(cardSelectionViewModelProvider.notifier).clearSelection();
    ref.read(resultChatViewModelProvider.notifier).reset();
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final spreads = ref.watch(spreadSelectionViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    
    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.darkGradient,
          AppColors.mysticGradient,
        ],
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, l10n),
              _buildDescription(isSmallScreen, l10n),
              SizedBox(height: isSmallScreen ? 16 : 20),
              _buildTabBar(isSmallScreen, l10n),
              SizedBox(height: isSmallScreen ? 16 : 20),
              Expanded(
                child: _buildTabBarView(spreads, screenSize, isSmallScreen),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildBackButton(context),
          Expanded(
            child: Hero(
              tag: 'spread_title',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  l10n.spreadSelectionTitle,
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
  
  Widget _buildBackButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.blackOverlay20,
            AppColors.blackOverlay20,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.whiteOverlay10,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackOverlay20,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: AccessibleIconButton(
        icon: Icons.arrow_back_ios_new,
        onPressed: () => context.pop(),
        semanticLabel: l10n.goBack,
        color: AppColors.ghostWhite,
        size: 20,
        tooltip: l10n.goBack,
        padding: EdgeInsets.zero,
      ),
    );
  }
  
  Widget _buildDescription(bool isSmallScreen, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.mysticPurple.withAlpha(25),
              AppColors.deepViolet.withAlpha(13),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.mysticPurple.withAlpha(76),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_fix_high,
              color: AppColors.textMystic,
              size: isSmallScreen ? 18 : 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.spreadSelectionSubtitle,
                style: AppTextStyles.whisper.copyWith(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: AppColors.textMystic,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(duration: _animationDuration)
        .shimmer(
          duration: const Duration(seconds: 2),
          color: AppColors.spiritGlow.withAlpha(76),
        );
  }
  
  Widget _buildTabBar(bool isSmallScreen, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      height: isSmallScreen ? 48 : 54,
      decoration: BoxDecoration(
        color: AppColors.blackOverlay20,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: AppColors.whiteOverlay10,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackOverlay40,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.mysticPurple,
              AppColors.deepViolet,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(23),
          boxShadow: [
            BoxShadow(
              color: AppColors.mysticPurple.withAlpha(127),
              blurRadius: 12,
              spreadRadius: -2,
            ),
          ],
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        labelColor: Colors.white, // Brighter white for better visibility
        unselectedLabelColor: AppColors.fogGray,
        labelStyle: AppTextStyles.buttonMedium.copyWith(
          fontSize: isSmallScreen ? 14 : 15,
          fontWeight: FontWeight.w700, // Bolder weight
          letterSpacing: 0.5,
          shadows: [ // Text shadow for better visibility
            const Shadow(
              offset: Offset(0, 1),
              blurRadius: 4,
              color: Colors.black54,
            ),
          ],
        ),
        unselectedLabelStyle: AppTextStyles.buttonMedium.copyWith(
          fontSize: isSmallScreen ? 13 : 14,
          fontWeight: FontWeight.w500,
        ),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: [
          Tab(text: l10n.spreadDifficultyBeginner),
          Tab(text: l10n.spreadDifficultyIntermediate),
          Tab(text: l10n.spreadDifficultyAdvanced),
        ],
      ),
    ).animate()
        .fadeIn(delay: const Duration(milliseconds: 300))
        .slideY(begin: 0.1, end: 0)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
  
  Widget _buildTabBarView(
    SpreadSelectionState spreads,
    Size screenSize,
    bool isSmallScreen,
  ) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildSpreadGrid(
          spreads.beginnerSpreads,
          screenSize,
          isSmallScreen,
        ),
        _buildSpreadGrid(
          spreads.intermediateSpreads,
          screenSize,
          isSmallScreen,
        ),
        _buildSpreadGrid(
          spreads.advancedSpreads,
          screenSize,
          isSmallScreen,
        ),
      ],
    );
  }
  
  Widget _buildSpreadGrid(
    List<TarotSpread> spreads,
    Size screenSize,
    bool isSmallScreen,
  ) {
    final crossAxisCount = _calculateCrossAxisCount(screenSize);
    final aspectRatio = _calculateAspectRatio(isSmallScreen);
    final spacing = isSmallScreen ? 12.0 : 16.0;
    
    return GridView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: spreads.length,
      itemBuilder: (context, index) {
        return _buildAnimatedSpreadCard(spreads[index]);
      },
    );
  }
  
  int _calculateCrossAxisCount(Size screenSize) {
    if (screenSize.width < 350) return 1;
    if (screenSize.width < 600) return 2;
    return 3;
  }
  
  double _calculateAspectRatio(bool isSmallScreen) {
    return isSmallScreen ? 0.85 : 0.75;
  }
  
  Widget _buildAnimatedSpreadCard(TarotSpread spread) {
    final animationIndex = TarotSpread.allSpreads.indexOf(spread);
    
    if (animationIndex < 0 || animationIndex >= _cardAnimations.length) {
      return const SizedBox();
    }
    
    return AnimatedBuilder(
      animation: _cardAnimations[animationIndex],
      builder: (context, child) {
        // Clamp opacity value to 0.0 ~ 1.0 range
        final clampedOpacity = _cardAnimations[animationIndex].value.clamp(0.0, 1.0);
        
        return Transform.scale(
          scale: _cardAnimations[animationIndex].value,
          child: Opacity(
            opacity: clampedOpacity,
            child: SpreadCardWidget(
              spread: spread,
              onTap: () => _selectSpread(spread),
            ),
          ),
        );
      },
    );
  }
}