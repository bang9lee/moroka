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
import '../../widgets/cards/tarot_card_widget.dart';
import '../main/main_viewmodel.dart';

class CardSelectionScreen extends ConsumerStatefulWidget {
  const CardSelectionScreen({super.key});

  @override
  ConsumerState<CardSelectionScreen> createState() => _CardSelectionScreenState();
}

class _CardSelectionScreenState extends ConsumerState<CardSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _shuffleController;
  late AnimationController _fanController;
  late AnimationController _glowController;
  
  final List<AnimationController> _cardControllers = [];
  final List<Animation<double>> _cardAnimations = [];
  
  bool _isShuffling = false;
  bool _cardsReady = false;
  int? _selectedCardIndex;

  @override
  void initState() {
    super.initState();
    
    _shuffleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fanController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    // Initialize card animations
    for (int i = 0; i < 22; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );
      _cardControllers.add(controller);
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
      _cardAnimations.add(animation);
    }
    
    _startInitialAnimation();
  }

  Future<void> _startInitialAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _shuffleCards();
  }

  Future<void> _shuffleCards() async {
    setState(() {
      _isShuffling = true;
    });
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(pattern: [0, 50, 100, 50, 100, 50]);
    }
    
    await _shuffleController.forward();
    
    setState(() {
      _isShuffling = false;
      _cardsReady = true;
    });
    
    _fanController.forward();
    
    // Animate cards appearing
    for (int i = 0; i < _cardControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      _cardControllers[i].forward();
    }
  }

  Future<void> _selectCard(int index) async {
    if (_selectedCardIndex != null || _isShuffling) return;
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 100);
    }
    
    setState(() {
      _selectedCardIndex = index;
    });
    
    ref.read(selectedCardIndexProvider.notifier).state = index;
    
    // Animate selected card
    await _cardControllers[index].reverse();
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (mounted) {
      context.push('/result-chat', extra: index);
    }
  }

  @override
  void dispose() {
    _shuffleController.dispose();
    _fanController.dispose();
    _glowController.dispose();
    for (final controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final userMood = ref.watch(userMoodProvider);
    
    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.darkGradient,
          AppColors.mysticGradient,
        ],
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.ghostWhite,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '운명의 카드를 선택하세요',
                        style: AppTextStyles.displaySmall.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // User mood display
              if (userMood != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassMorphismContainer(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '현재 당신의 기분: ',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.fogGray,
                          ),
                        ),
                        Text(
                          userMood,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textMystic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: const Duration(milliseconds: 600)),
                ),
              
              const SizedBox(height: 20),
              
              // Main content
              Expanded(
                child: Center(
                  child: _isShuffling
                      ? _buildShufflingAnimation()
                      : _cardsReady
                          ? _buildCardFan(screenSize)
                          : _buildWaitingState(),
                ),
              ),
              
              // Instructions
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _cardsReady ? 1.0 : 0.0,
                  child: Text(
                    '직감을 따라 한 장을 선택하세요',
                    style: AppTextStyles.whisper.copyWith(
                      fontSize: 18,
                      color: AppColors.fogGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShufflingAnimation() {
    return AnimatedBuilder(
      animation: _shuffleController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _shuffleController.value * 2 * math.pi,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(7, (index) {
              final angle = (index * 2 * math.pi) / 7;
              final radius = 80.0 + (index * 10);
              final x = radius * math.cos(angle + _shuffleController.value * 2 * math.pi);
              final y = radius * math.sin(angle + _shuffleController.value * 2 * math.pi);
              
              return Transform.translate(
                offset: Offset(x, y),
                child: Transform.rotate(
                  angle: _shuffleController.value * 4 * math.pi,
                  child: Container(
                    width: 60,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.mysticPurple,
                          AppColors.deepViolet,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.evilGlow.withAlpha(100),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildCardFan(Size screenSize) {
    const cardCount = 22;
    const fanAngle = math.pi / 2; // 90 degrees total fan
    const startAngle = -fanAngle / 2;
    
    return AnimatedBuilder(
      animation: _fanController,
      builder: (context, child) {
        return SizedBox(
          width: screenSize.width,
          height: screenSize.height * 0.6,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(cardCount, (index) {
              final progress = _fanController.value;
              final angle = startAngle + (fanAngle / (cardCount - 1)) * index;
              final radius = screenSize.width * 0.8;
              
              // Position calculation
              final x = radius * math.sin(angle) * progress;
              final y = radius * (1 - math.cos(angle)) * progress;
              
              return AnimatedBuilder(
                animation: _cardAnimations[index],
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(x, y),
                    child: Transform.rotate(
                      angle: angle * progress,
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () => _selectCard(index),
                        child: Transform.scale(
                          scale: _cardAnimations[index].value,
                          child: TarotCardBack(
                            index: index,
                            isSelected: _selectedCardIndex == index,
                            glowAnimation: _glowController,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildWaitingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.hourglass_empty,
          size: 64,
          color: AppColors.fogGray,
        ).animate(
          onPlay: (controller) => controller.repeat(),
        ).rotate(duration: const Duration(seconds: 2)),
        const SizedBox(height: 24),
        Text(
          '운명의 실이 엮이고 있습니다...',
          style: AppTextStyles.whisper.copyWith(
            fontSize: 20,
            color: AppColors.fogGray,
          ),
        ),
      ],
    );
  }
}