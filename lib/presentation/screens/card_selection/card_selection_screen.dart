import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/tarot_card_model.dart';
import '../main/main_viewmodel.dart';
import '../spread_selection/spread_selection_viewmodel.dart';
import 'card_selection_viewmodel.dart';

/// 프로덕션급 타로 카드 선택 화면
/// 고급 애니메이션과 상호작용을 제공하는 카드 선택 인터페이스
class CardSelectionScreen extends ConsumerStatefulWidget {
  const CardSelectionScreen({super.key});

  @override
  ConsumerState<CardSelectionScreen> createState() => _CardSelectionScreenState();
}

class _CardSelectionScreenState extends ConsumerState<CardSelectionScreen>
    with TickerProviderStateMixin {
  // ===== Animation Controllers =====
  late final AnimationController _spreadController;
  late final AnimationController _breathingController;
  late final AnimationController _glowController;
  late final AnimationController _selectionController;
  late final AnimationController _particleController;
  
  // ===== Card State =====
  late final List<TarotCardModel> _shuffledCards;
  final Set<int> _selectedCardIds = {};
  final Map<int, CardAnimationState> _cardAnimations = {};
  
  // ===== Interaction State =====
  final ScrollController _scrollController = ScrollController();
  int? _hoveredCardIndex;
  int? _tappedCardIndex;
  TarotCardModel? _pendingCard;
  bool _showConfirmDialog = false;
  
  // ===== Layout Constants =====
  static const double _cardWidth = 120.0;
  static const double _cardHeight = 180.0;
  static const double _cardSpacing = 15.0;
  static const double _selectedCardTop = 170.0;
  static const double _selectedCardHeight = 90.0;
  static const double _selectedCardHeightLarge = 180.0;
  
  // ===== Card Calling Effect =====
  final Map<int, double> _cardCallingIntensity = {};
  
  // ===== Device State =====
  bool _hasVibrator = false;
  DateTime _lastHapticTime = DateTime.now();
  Size _screenSize = Size.zero;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _shuffleCards();
    _checkVibration();
    _startCallingEffect();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cardSelectionViewModelProvider.notifier).shuffleAndDeal();
      _spreadController.forward();
    });
  }
  
  void _initializeAnimations() {
    _spreadController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _breathingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }
  
  void _shuffleCards() {
    // 78장 타로 카드를 섞기
    _shuffledCards = List<TarotCardModel>.from(TarotCardModel.fullDeck)
      ..shuffle(math.Random());
    
    // Initialize card animations
    for (int i = 0; i < _shuffledCards.length; i++) {
      _cardAnimations[i] = CardAnimationState();
      _cardCallingIntensity[i] = 0.3 + math.Random().nextDouble() * 0.4;
    }
  }
  
  void _startCallingEffect() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      
      setState(() {
        // 랜덤으로 몇 개 카드의 calling intensity 증가
        final callingCount = math.Random().nextInt(3) + 2;
        final indices = List.generate(_shuffledCards.length, (i) => i)..shuffle();
        
        for (int i = 0; i < callingCount; i++) {
          _cardCallingIntensity[indices[i]] = 0.7 + math.Random().nextDouble() * 0.3;
        }
        
        // 나머지는 약간 감소
        for (int i = callingCount; i < indices.length; i++) {
          _cardCallingIntensity[indices[i]] = 
              (_cardCallingIntensity[indices[i]]! * 0.95).clamp(0.2, 1.0);
        }
      });
      
      _startCallingEffect();
    });
  }
  
  Future<void> _checkVibration() async {
    _hasVibrator = await Vibration.hasVibrator() == true;
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _spreadController.dispose();
    _breathingController.dispose();
    _glowController.dispose();
    _selectionController.dispose();
    _particleController.dispose();
    super.dispose();
  }
  
  // ===== Haptic Feedback =====
  Future<void> _hapticFeedback({int duration = 20, double intensity = 1.0}) async {
    if (!_hasVibrator) return;
    
    final now = DateTime.now();
    if (now.difference(_lastHapticTime).inMilliseconds < 50) return;
    _lastHapticTime = now;
    
    await Vibration.vibrate(duration: (duration * intensity).toInt());
  }
  
  // ===== Card Selection =====
  void _onCardTap(int index) {
    final card = _shuffledCards[index];
    
    // 이미 선택된 카드는 무시
    if (_selectedCardIds.contains(card.id)) return;
    
    // 최대 선택 개수 체크
    final selectedSpread = ref.read(selectedSpreadProvider);
    final requiredCards = selectedSpread?.cardCount ?? 1;
    
    // 현재 선택된 카드들 중 같은 카드가 있는지 체크
    final currentSelections = ref.read(cardSelectionViewModelProvider).selectedCards;
    if (currentSelections.any((c) => c.id == card.id)) return;
    
    if (currentSelections.length >= requiredCards) return;
    
    setState(() {
      _tappedCardIndex = index;
      _pendingCard = card;
      _showConfirmDialog = true;
    });
    
    _hapticFeedback(duration: 30);
  }
  
  Future<void> _confirmSelection() async {
    if (_pendingCard == null || _tappedCardIndex == null) return;
    
    setState(() {
      _selectedCardIds.add(_pendingCard!.id);
      _cardAnimations[_tappedCardIndex!]?.isSelected = true;
      _showConfirmDialog = false;
    });
    
    await _hapticFeedback(duration: 100, intensity: 1.0);
    await _selectionController.forward();
    _selectionController.reset();
    
    ref.read(cardSelectionViewModelProvider.notifier).selectCard(_pendingCard!);
    
    // 선택된 모든 인덱스의 카드를 선택된 것으로 표시
    for (int i = 0; i < _shuffledCards.length; i++) {
      if (_shuffledCards[i].id == _pendingCard!.id) {
        setState(() {
          _selectedCardIds.add(_shuffledCards[i].id);
        });
      }
    }
    
    // 완료 체크
    final selectedSpread = ref.read(selectedSpreadProvider);
    final requiredCards = selectedSpread?.cardCount ?? 1;
    final currentSelections = ref.read(cardSelectionViewModelProvider).selectedCards.length;
    
    if (currentSelections >= requiredCards) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        final selectedCardIndices = ref.read(cardSelectionViewModelProvider)
            .selectedCards.map((c) => c.id).toList();
        context.push('/result-chat', extra: selectedCardIndices);
      }
    }
    
    _pendingCard = null;
    _tappedCardIndex = null;
  }
  
  void _cancelSelection() {
    setState(() {
      _showConfirmDialog = false;
      _pendingCard = null;
      _tappedCardIndex = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    
    final state = ref.watch(cardSelectionViewModelProvider);
    final userMood = ref.watch(userMoodProvider) ?? '';
    final selectedSpread = ref.watch(selectedSpreadProvider);
    final requiredCards = selectedSpread?.cardCount ?? 1;
    final remainingCards = requiredCards - state.selectedCards.length;
    
    return Scaffold(
      backgroundColor: AppColors.obsidianBlack,
      body: Stack(
        children: [
          // 신비로운 배경
          _buildMysticalBackground(),
          
          // 메인 컨텐츠
          SafeArea(
            child: Column(
              children: [
                _buildHeader(userMood, remainingCards),
                
                Expanded(
                  child: state.showingCards
                      ? _buildCardScrollView()
                      : _buildShufflingAnimation(),
                ),
                
                _buildBottomInfo(state.selectedCards.length, requiredCards),
                _buildInstructions(remainingCards > 0),
              ],
            ),
          ),
          
          // 선택된 카드 표시
          if (_selectedCardIds.isNotEmpty)
            _buildSelectedCardsDisplay(),
          
          // 파티클 효과
          _buildParticleOverlay(),
          
          // 확인 다이얼로그
          if (_showConfirmDialog && _pendingCard != null)
            _buildConfirmationDialog(),
        ],
      ),
    );
  }
  
  Widget _buildCardScrollView() {
    return Center(
      child: Container(
        height: _cardHeight + 40,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _spreadController,
            _breathingController,
            _glowController,
          ]),
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    for (int i = 0; i < _shuffledCards.length; i++)
                      if (!_selectedCardIds.contains(_shuffledCards[i].id))
                        Padding(
                          padding: const EdgeInsets.only(
                            right: _cardSpacing,
                          ),
                          child: _buildSingleCard(_shuffledCards[i], i),
                        ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildSingleCard(TarotCardModel card, int index) {
    final isHovered = _hoveredCardIndex == index;
    final isTapped = _tappedCardIndex == index;
    final callingIntensity = _cardCallingIntensity[index] ?? 0.5;
    
    final double cardScale = isTapped 
        ? 1.15 
        : (isHovered ? 1.05 : 1.0);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredCardIndex = index),
      onExit: (_) => setState(() => _hoveredCardIndex = null),
      child: GestureDetector(
        onTap: () => _onCardTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: _cardWidth,
          height: _cardHeight,
          transform: Matrix4.identity()
            ..translate(0.0, isHovered ? -10.0 : 0.0)
            ..scale(cardScale),
          child: Opacity(
            opacity: _spreadController.value,
            child: Stack(
              children: [
                // 카드가 부르는 효과
                if (callingIntensity > 0.6 || isHovered)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mysticPurple
                                .withAlpha(((callingIntensity * 150 + (isHovered ? 50 : 0)) * _glowController.value).toInt()),
                            blurRadius: 30 + (callingIntensity * 20),
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // 카드 본체
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isTapped
                          ? AppColors.spiritGlow
                          : isHovered 
                              ? AppColors.mysticPurple
                              : AppColors.mysticPurple.withAlpha(100),
                      width: isTapped ? 3 : (isHovered ? 2 : 1),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.blackOverlay80,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 카드 뒷면
                        _buildCardBack(callingIntensity, isHovered),
                        
                        // 호버 오버레이
                        if (isHovered)
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.whiteOverlay10,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate()
            .slideX(
              begin: 0.2,
              end: 0,
              delay: Duration(milliseconds: 50 * (index % 20)),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
            ),
      ),
    );
  }
  
  Widget _buildCardBack(double callingIntensity, bool isHovered) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 카드 뒷면 이미지
        Image.asset(
          'assets/images/card_back.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // 이미지 로드 실패시 대체 디자인
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.deepViolet,
                    AppColors.obsidianBlack,
                  ],
                ),
              ),
              child: CustomPaint(
                painter: TarotCardBackPainter(
                  breathingValue: _breathingController.value,
                  callingIntensity: callingIntensity,
                  isHovered: isHovered,
                ),
              ),
            );
          },
        ),
        
        // 카드가 강하게 부를 때 오버레이 효과
        if (callingIntensity > 0.7 || isHovered)
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  AppColors.mysticPurple.withAlpha((callingIntensity * 30).toInt()),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        
        // 카드가 강하게 부를 때 중앙에 빛
        if (callingIntensity > 0.8)
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.spiritGlow.withAlpha(60),
                    AppColors.spiritGlow.withAlpha(30),
                    Colors.transparent,
                  ],
                ),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(),
            ).scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.2, 1.2),
              duration: const Duration(seconds: 2),
            ),
          ),
      ],
    );
  }
  
  Widget _buildConfirmationDialog() {
    return GestureDetector(
      onTap: _cancelSelection,
      child: Container(
        color: AppColors.blackOverlay60,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // 다이얼로그 내부 클릭은 무시
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                constraints: const BoxConstraints(maxWidth: 320),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.blackOverlay80,
                      AppColors.blackOverlay60,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.mysticPurple.withAlpha(100),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mysticPurple.withAlpha(40),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 상단 아이콘 영역
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 배경 원
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.mysticPurple.withAlpha(50),
                                    AppColors.mysticPurple.withAlpha(20),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            // 아이콘
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.spiritGlow,
                                    AppColors.mysticPurple,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.spiritGlow.withAlpha(80),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.visibility,
                                color: AppColors.ghostWhite,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 텍스트 영역
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            Text(
                              '운명의 카드',
                              style: AppTextStyles.displaySmall.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ghostWhite,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '이 카드를 선택하시겠습니까?',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 16,
                                color: AppColors.fogGray,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // 버튼 영역
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppColors.blackOverlay20,
                          border: Border(
                            top: BorderSide(
                              color: AppColors.whiteOverlay10,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildDialogButton(
                                text: '다시 보기',
                                onTap: _cancelSelection,
                                isPrimary: false,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDialogButton(
                                text: '선택하기',
                                onTap: _confirmSelection,
                                isPrimary: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate()
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                  )
                  .fadeIn(duration: const Duration(milliseconds: 300)),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDialogButton({
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.spiritGlow,
                    AppColors.mysticPurple,
                  ],
                )
              : null,
          color: isPrimary ? null : AppColors.blackOverlay40,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPrimary 
                ? Colors.transparent
                : AppColors.whiteOverlay20,
            width: 1.5,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.spiritGlow.withAlpha(60),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.buttonMedium.copyWith(
              color: isPrimary ? AppColors.ghostWhite : AppColors.fogGray,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSelectedCardsDisplay() {
    final selectedSpread = ref.watch(selectedSpreadProvider);
    final requiredCards = selectedSpread?.cardCount ?? 1;
    final isLargeSpread = requiredCards >= 10;
    
    return Positioned(
      top: _selectedCardTop,
      left: 0,
      right: 0,
      child: Container(
        height: isLargeSpread ? _selectedCardHeightLarge : _selectedCardHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: isLargeSpread
              ? _buildTwoRowLayout()
              : _buildSingleRowLayout(),
        ),
      ),
    );
  }
  
  Widget _buildSingleRowLayout() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20),
          ..._selectedCardIds.map((cardId) {
            final cardIndex = _selectedCardIds.toList().indexOf(cardId);
            return _buildSelectedCard(cardIndex + 1);
          }),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
  
  Widget _buildTwoRowLayout() {
    final selectedList = _selectedCardIds.toList();
    final firstRow = selectedList.take(5).toList();
    final secondRow = selectedList.skip(5).toList();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 첫 번째 줄 (1-5)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              ...firstRow.asMap().entries.map((entry) {
                return _buildSelectedCard(entry.key + 1);
              }),
              const SizedBox(width: 20),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // 두 번째 줄 (6-10)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              ...secondRow.asMap().entries.map((entry) {
                return _buildSelectedCard(entry.key + 6);
              }),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSelectedCard(int number) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 55,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.deepViolet,
            AppColors.obsidianBlack,
          ],
        ),
        border: Border.all(
          color: AppColors.spiritGlow,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.spiritGlow.withAlpha(60),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$number',
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.spiritGlow,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    ).animate()
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
        )
        .slideY(
          begin: -0.5,
          end: 0,
          duration: const Duration(milliseconds: 400),
        );
  }
  
  Widget _buildShufflingAnimation() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300,
            height: 400,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(15, (index) {
                return AnimatedBuilder(
                  animation: _spreadController,
                  builder: (context, child) {
                    final progress = (_spreadController.value * 15 - index).clamp(0.0, 1.0);
                    final shufflePhase = (_spreadController.value * 4).floor() % 4;
                    
                    double xOffset = 0;
                    double yOffset = 0;
                    double rotation = 0;
                    
                    switch (shufflePhase) {
                      case 0:
                        xOffset = math.sin(progress * math.pi) * 100;
                        yOffset = -progress * 50;
                        rotation = progress * 0.5;
                        break;
                      case 1:
                        xOffset = math.cos(progress * math.pi) * 100;
                        yOffset = progress * 50;
                        rotation = -progress * 0.5;
                        break;
                      case 2:
                        xOffset = -math.sin(progress * math.pi) * 100;
                        yOffset = math.sin(progress * math.pi * 2) * 30;
                        rotation = progress * math.pi / 4;
                        break;
                      case 3:
                        xOffset = (0.5 - progress) * 200;
                        yOffset = 0;
                        rotation = 0;
                        break;
                    }
                    
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..translate(xOffset, yOffset)
                        ..rotateZ(rotation),
                      child: Opacity(
                        opacity: progress,
                        child: Container(
                          width: _cardWidth,
                          height: _cardHeight,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.deepViolet, AppColors.obsidianBlack],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.mysticPurple,
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.blackOverlay80,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            '운명의 카드를 섞고 있습니다...',
            style: AppTextStyles.whisper,
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).shimmer(
            duration: const Duration(seconds: 2),
            color: AppColors.mysticPurple,
          ),
        ],
      ),
    );
  }
  
  Widget _buildMysticalBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.3),
          radius: 1.5,
          colors: [
            AppColors.deepViolet.withAlpha(50),
            AppColors.obsidianBlack,
          ],
        ),
      ),
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return CustomPaint(
            size: _screenSize,
            painter: MysticalBackgroundPainter(
              animationValue: _particleController.value,
            ),
          );
        },
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
                  '마음이 끌리는 카드를 선택하세요',
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 18,
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
              _buildInfoChip(
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blackOverlay40,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withAlpha(50),
          width: 1,
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
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
  
  Widget _buildInstructions(bool showInstructions) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: showInstructions
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '카드를 탭하여 선택하세요',
                  key: const ValueKey('instructions'),
                  style: AppTextStyles.whisper.copyWith(
                    color: AppColors.fogGray,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ).animate(
                  onPlay: (controller) => controller.repeat(),
                ).fadeIn(duration: 2.seconds).then(delay: 3.seconds).fadeOut(duration: 2.seconds),
              )
            : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }
  
  Widget _buildParticleOverlay() {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return CustomPaint(
            size: _screenSize,
            painter: MysticalParticlePainter(
              animationValue: _particleController.value,
            ),
          );
        },
      ),
    );
  }
}

// ===== Data Classes =====

class CardAnimationState {
  bool isSelected = false;
  bool isReturning = false;
  double elevation = 0.0;
}

// ===== Custom Painters =====

class TarotCardBackPainter extends CustomPainter {
  final double breathingValue;
  final double callingIntensity;
  final bool isHovered;
  
  TarotCardBackPainter({
    required this.breathingValue,
    required this.callingIntensity,
    required this.isHovered,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    final center = Offset(size.width / 2, size.height / 2);
    
    // 외곽 프레임
    paint.color = AppColors.mysticPurple.withAlpha(100);
    final rect = Rect.fromLTWH(8, 8, size.width - 16, size.height - 16);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
    
    // 중앙 원형 패턴
    for (int i = 0; i < 3; i++) {
      final radius = 15.0 + i * 12.0 + breathingValue * 3;
      paint.color = AppColors.mysticPurple
          .withAlpha((80 + callingIntensity * 50 + (isHovered ? 30 : 0)).toInt());
      canvas.drawCircle(center, radius, paint);
    }
    
    // 별 문양
    _drawStar(canvas, center, 30 + breathingValue * 5, paint);
    
    // 모서리 장식
    _drawCornerOrnaments(canvas, size, paint);
  }
  
  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 8;
    
    for (int i = 0; i < points; i++) {
      final angle = (i * 2 * math.pi / points) - math.pi / 2;
      final isOuter = i % 2 == 0;
      final r = isOuter ? radius : radius * 0.5;
      final point = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    
    paint.style = PaintingStyle.fill;
    paint.color = AppColors.evilGlow
        .withAlpha((40 + callingIntensity * 60 + (isHovered ? 20 : 0)).toInt());
    canvas.drawPath(path, paint);
    
    paint.style = PaintingStyle.stroke;
    paint.color = AppColors.mysticPurple.withAlpha(150);
    canvas.drawPath(path, paint);
  }
  
  void _drawCornerOrnaments(Canvas canvas, Size size, Paint paint) {
    paint.color = AppColors.mysticPurple.withAlpha(80);
    const ornamentSize = 20.0;
    
    // 각 모서리에 작은 장식
    final corners = [
      const Offset(ornamentSize, ornamentSize),
      Offset(size.width - ornamentSize, ornamentSize),
      Offset(ornamentSize, size.height - ornamentSize),
      Offset(size.width - ornamentSize, size.height - ornamentSize),
    ];
    
    for (final corner in corners) {
      canvas.drawCircle(corner, 3, paint);
      
      // 작은 십자가
      canvas.drawLine(
        Offset(corner.dx - 5, corner.dy),
        Offset(corner.dx + 5, corner.dy),
        paint,
      );
      canvas.drawLine(
        Offset(corner.dx, corner.dy - 5),
        Offset(corner.dx, corner.dy + 5),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(TarotCardBackPainter oldDelegate) => true;
}

class MysticalBackgroundPainter extends CustomPainter {
  final double animationValue;
  
  MysticalBackgroundPainter({required this.animationValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // 은은한 오로라 효과
    for (int i = 0; i < 3; i++) {
      final offset = Offset(
        size.width * (0.3 + i * 0.2),
        size.height * 0.3 + math.sin(animationValue * math.pi * 2 + i) * 50,
      );
      
      paint.shader = ui.Gradient.radial(
        offset,
        300,
        [
          AppColors.mysticPurple.withAlpha(10),
          AppColors.deepViolet.withAlpha(5),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      );
      
      canvas.drawCircle(offset, 300, paint);
    }
  }
  
  @override
  bool shouldRepaint(MysticalBackgroundPainter oldDelegate) => true;
}

class MysticalParticlePainter extends CustomPainter {
  final double animationValue;
  
  MysticalParticlePainter({required this.animationValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // 떠다니는 빛 입자들
    for (int i = 0; i < 30; i++) {
      final progress = (animationValue + i / 30) % 1.0;
      final y = size.height * (1 - progress);
      final x = size.width * 0.2 + 
          (size.width * 0.6) * math.sin(progress * math.pi * 2 + i);
      final opacity = math.sin(progress * math.pi) * 0.5;
      
      paint.color = AppColors.spiritGlow.withAlpha((opacity * 255).toInt());
      canvas.drawCircle(
        Offset(x, y), 
        1 + math.sin(animationValue * math.pi * 2 + i) * 2, 
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(MysticalParticlePainter oldDelegate) => true;
}