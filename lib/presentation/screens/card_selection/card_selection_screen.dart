import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/tarot_card_model.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';
import '../main/main_viewmodel.dart';
import '../spread_selection/spread_selection_viewmodel.dart';
import 'card_selection_viewmodel.dart';

/// 카드 선택 화면 - 영적인 스와이프 스타일
class CardSelectionScreen extends ConsumerStatefulWidget {
  const CardSelectionScreen({super.key});

  @override
  ConsumerState<CardSelectionScreen> createState() => _CardSelectionScreenState();
}

class _CardSelectionScreenState extends ConsumerState<CardSelectionScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late final AnimationController _introController;
  late final AnimationController _cardFlowController;
  late final AnimationController _floatingController;
  late final AnimationController _pulseController;
  
  // Card State
  late final List<TarotCardModel> _shuffledCards;
  final Set<int> _selectedCardIds = {};
  int? _focusedCardId;
  
  // Swipe Card Layout - 무한 스크롤을 위해 큰 값 설정
  late final PageController _pageController;
  static const int _virtualInfinity = 1000000;
  
  double _currentPageValue = 0.0;
  bool _hasVibrator = false;
  
  // Card Dimensions
  static const double _cardWidth = 280.0;
  static const double _cardHeight = 420.0;
  static const double _cardAspectRatio = _cardWidth / _cardHeight;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _shuffleCards();
    _checkVibration();
    
    // PageController 초기화 - 중간값에서 시작하여 양방향 스크롤 가능
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: _virtualInfinity ~/ 2,
    );
    
    // PageController listener
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page ?? 0.0;
      });
    });
    
    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cardSelectionViewModelProvider.notifier).shuffleAndDeal();
      _introController.forward();
      _cardFlowController.repeat();
    });
  }
  
  void _initializeAnimations() {
    _introController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _cardFlowController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }
  
  void _shuffleCards() {
    _shuffledCards = List<TarotCardModel>.from(TarotCardModel.fullDeck)
      ..shuffle(math.Random());
  }
  
  Future<void> _checkVibration() async {
    try {
      _hasVibrator = await Vibration.hasVibrator() == true;
    } catch (_) {
      _hasVibrator = false;
    }
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _introController.dispose();
    _cardFlowController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  Future<void> _hapticFeedback({int duration = 20}) async {
    if (!_hasVibrator) return;
    
    try {
      await Vibration.vibrate(duration: duration);
    } catch (_) {
      // Fail silently
    }
  }
  
  void _onPageChanged(int index) {
    _hapticFeedback(duration: 10);
  }
  
  Future<void> _selectCard(int cardId) async {
    if (_selectedCardIds.contains(cardId)) return;
    
    setState(() {
      _focusedCardId = cardId;
    });
    
    await _hapticFeedback(duration: 30);
  }
  
  Future<void> _confirmCardSelection(int cardId) async {
    final selectedSpread = ref.read(selectedSpreadProvider);
    final requiredCards = selectedSpread?.cardCount ?? 1;
    final currentSelections = ref.read(cardSelectionViewModelProvider).selectedCards.length;
    
    if (currentSelections >= requiredCards) return;
    
    setState(() {
      _selectedCardIds.add(cardId);
      _focusedCardId = null;
    });
    
    final card = TarotCardModel.getCardById(cardId);
    ref.read(cardSelectionViewModelProvider.notifier).selectCard(card);
    
    await _hapticFeedback(duration: 50);
    
    // Check if selection is complete
    if (currentSelections + 1 >= requiredCards) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        final selectedCardIndices = ref.read(cardSelectionViewModelProvider)
            .selectedCards.map((c) => c.id).toList();
        context.push('/result-chat', extra: selectedCardIndices);
      }
    }
  }
  
  Widget _buildCard(int virtualIndex) {
    // 실제 카드 인덱스 계산
    final actualIndex = virtualIndex % _shuffledCards.length;
    final card = _shuffledCards[actualIndex];
    final isSelected = _selectedCardIds.contains(card.id);
    
    // 현재 페이지와의 거리 계산
    double distance = (virtualIndex - _currentPageValue).abs();
    double scale = 1.0 - (distance * 0.15).clamp(0.0, 0.3);
    double opacity = 1.0 - (distance * 0.3).clamp(0.0, 0.7);
    double rotation = (virtualIndex - _currentPageValue) * 0.05;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_floatingController, _pulseController]),
      builder: (context, child) {
        // 중앙 카드만 플로팅 효과
        final floatOffset = distance < 0.5 && !isSelected
            ? _floatingController.value * 10 - 5
            : 0.0;
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(0.0, floatOffset)
            ..rotateY(rotation)
            ..scale(scale),
          child: Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTap: distance < 0.5 ? () => _selectCard(card.id) : null,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 60),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 신비로운 광선 효과 (중앙 카드만)
                    if (distance < 0.5 && !isSelected)
                      Container(
                        width: _cardWidth,
                        height: _cardHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mysticPurple.withAlpha(60),
                              blurRadius: 40 + (_pulseController.value * 20),
                              spreadRadius: 10 + (_pulseController.value * 10),
                            ),
                          ],
                        ),
                      ),
                    
                    // 카드 본체
                    AspectRatio(
                      aspectRatio: _cardAspectRatio,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.blackOverlay80,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // 카드 뒷면
                              Image.asset(
                                'assets/images/card_back.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.deepViolet,
                                          AppColors.obsidianBlack,
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.auto_awesome,
                                        size: 60,
                                        color: AppColors.mysticPurple,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              // 카드 테두리 효과
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.spiritGlow
                                        : distance < 0.5
                                            ? AppColors.mysticPurple.withAlpha(150)
                                            : AppColors.whiteOverlay20,
                                    width: isSelected || distance < 0.5 ? 3 : 1,
                                  ),
                                ),
                              ),
                              
                              // 선택된 카드 오버레이
                              if (isSelected)
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.spiritGlow.withAlpha(40),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: const Icon(
                                      Icons.check_circle,
                                      size: 80,
                                      color: AppColors.spiritGlow,
                                    ).animate()
                                        .scale(
                                          begin: const Offset(0, 0),
                                          end: const Offset(1, 1),
                                          duration: 500.ms,
                                          curve: Curves.elasticOut,
                                        ),
                                  ),
                                ),
                              
                              // 미스틱 오버레이 (중앙 카드)
                              if (distance < 0.5 && !isSelected)
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: RadialGradient(
                                      center: Alignment(0, -0.5),
                                      radius: 1.5,
                                      colors: [
                                        AppColors.glowOverlay20,
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ).animate(
                                  onPlay: (controller) => controller.repeat(),
                                ).shimmer(
                                  duration: const Duration(seconds: 3),
                                  color: AppColors.whiteOverlay10,
                                ),
                              
                              // 카드 번호 (디버그용 - 나중에 제거)
                              if (distance < 1)
                                Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.blackOverlay60,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${actualIndex + 1} / 78',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.fogGray,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cardSelectionViewModelProvider);
    final userMood = ref.watch(userMoodProvider) ?? '';
    final selectedSpread = ref.watch(selectedSpreadProvider);
    final requiredCards = selectedSpread?.cardCount ?? 1;
    final remainingCards = requiredCards - state.selectedCards.length;
    
    return Scaffold(
      backgroundColor: AppColors.obsidianBlack,
      body: Stack(
        children: [
          // 배경
          AnimatedGradientBackground(
            gradients: const [
              AppColors.mysticGradient,
              AppColors.darkGradient,
            ],
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.blackOverlay40,
                  ],
                ),
              ),
            ),
          ),
          
          // 메인 컨텐츠
          SafeArea(
            child: AnimatedBuilder(
              animation: _introController,
              builder: (context, child) {
                return Opacity(
                  opacity: _introController.value,
                  child: Column(
                    children: [
                      _buildHeader(userMood, remainingCards),
                      
                      Expanded(
                        child: state.showingCards
                            ? _buildCardSwiper()
                            : _buildLoadingIndicator(),
                      ),
                      
                      _buildBottomInfo(state.selectedCards.length, requiredCards),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // 확인 다이얼로그
          if (_focusedCardId != null)
            _buildConfirmationDialog(),
            
          // 미스틱 파티클 효과
          _buildMysticParticles(),
        ],
      ),
    );
  }
  
  Widget _buildCardSwiper() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 카드 스와이퍼 - 무한 스크롤
        PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: _virtualInfinity,
          itemBuilder: (context, index) => _buildCard(index),
        ),
        
        // 좌우 힌트 애니메이션 (처음에만)
        if (_selectedCardIds.isEmpty)
          Positioned(
            bottom: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chevron_left,
                  color: AppColors.fogGray,
                  size: 30,
                ).animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                ).moveX(begin: 0, end: -10, duration: 1.seconds),
                const SizedBox(width: 40),
                Text(
                  '좌우로 스와이프',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.fogGray,
                  ),
                ),
                const SizedBox(width: 40),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.fogGray,
                  size: 30,
                ).animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                ).moveX(begin: 0, end: 10, duration: 1.seconds),
              ],
            ).animate()
                .fadeIn(duration: 1.seconds)
                .then(delay: 3.seconds)
                .fadeOut(duration: 1.seconds),
          ),
      ],
    );
  }
  
  Widget _buildMysticParticles() {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _cardFlowController,
        builder: (context, child) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: MysticParticlePainter(
              animation: _cardFlowController.value,
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildConfirmationDialog() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _focusedCardId = null;
        });
      },
      child: Container(
        color: AppColors.blackOverlay80,
        child: Center(
          child: GlassMorphismContainer(
            width: 320,
            padding: const EdgeInsets.all(24),
            borderRadius: 20,
            backgroundColor: AppColors.shadowGray,
            borderColor: AppColors.mysticPurple,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 타이틀
                Text(
                  '운명의 선택',
                  style: AppTextStyles.mysticTitle.copyWith(
                    fontSize: 24,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 카드 프리뷰
                Container(
                  width: 160,
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.mysticPurple,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mysticPurple.withAlpha(100),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/card_back.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.deepViolet,
                                AppColors.obsidianBlack,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 50,
                            color: AppColors.mysticPurple,
                          ),
                        );
                      },
                    ),
                  ),
                ).animate()
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      duration: 400.ms,
                      curve: Curves.easeOutBack,
                    ),
                
                const SizedBox(height: 24),
                
                Text(
                  '이 카드가 당신을 부르고 있습니다',
                  style: AppTextStyles.whisper.copyWith(
                    fontSize: 16,
                    color: AppColors.fogGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // 버튼들
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _focusedCardId = null;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          '다시 생각하기',
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: AppColors.fogGray,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _confirmCardSelection(_focusedCardId!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mysticPurple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '선택하기',
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: AppColors.ghostWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }
  
  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.mysticPurple.withAlpha(60),
                  Colors.transparent,
                ],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.mysticPurple,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '운명의 실이 엮이고 있습니다...',
            style: AppTextStyles.whisper,
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).fadeIn(duration: 1.seconds).then().fadeOut(duration: 1.seconds),
        ],
      ),
    );
  }
  
  Widget _buildHeader(String userMood, int remainingCards) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.blackOverlay40,
                  foregroundColor: AppColors.ghostWhite,
                ),
              ),
              Expanded(
                child: Text(
                  '운명의 카드를 선택하세요',
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(
                icon: Icons.mood,
                label: userMood,
                color: AppColors.fogGray,
              ),
              const SizedBox(width: 12),
              AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: remainingCards > 0 
                        ? 1.0 + (_floatingController.value * 0.05) 
                        : 1.0,
                    child: _buildInfoChip(
                      icon: remainingCards > 0 
                          ? Icons.style 
                          : Icons.check_circle,
                      label: remainingCards > 0
                          ? '$remainingCards장 더 선택'
                          : '선택 완료!',
                      color: remainingCards > 0
                          ? AppColors.evilGlow
                          : AppColors.spiritGlow,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GlassMorphismContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 20,
      backgroundColor: AppColors.blackOverlay40,
      borderColor: color.withAlpha(50),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomInfo(int selectedCount, int requiredCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 진행 상황 바
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.blackOverlay40,
              borderRadius: BorderRadius.circular(3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                widthFactor: selectedCount / requiredCount,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.mysticPurple,
                        AppColors.evilGlow,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 카운터
          Text(
            '$selectedCount / $requiredCount',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.ghostWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// 미스틱 파티클 페인터
class MysticParticlePainter extends CustomPainter {
  final double animation;
  
  MysticParticlePainter({required this.animation});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // 신비로운 파티클 그리기
    for (int i = 0; i < 20; i++) {
      final progress = (animation + i / 20) % 1.0;
      final y = size.height * (1 - progress);
      final x = size.width * 0.2 + 
          (size.width * 0.6) * math.sin(progress * math.pi * 2 + i);
      final opacity = (1 - progress) * 0.3;
      
      paint.color = AppColors.mysticPurple.withAlpha((opacity * 255).toInt());
      canvas.drawCircle(Offset(x, y), 2 + math.Random().nextDouble() * 2, paint);
    }
  }
  
  @override
  bool shouldRepaint(MysticParticlePainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}