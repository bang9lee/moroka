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

class CardSelectionScreen extends ConsumerStatefulWidget {
  const CardSelectionScreen({super.key});

  @override
  ConsumerState<CardSelectionScreen> createState() => _CardSelectionScreenState();
}

class _CardSelectionScreenState extends ConsumerState<CardSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fanAnimationController;
  late AnimationController _selectedCardController;
  late Animation<double> _selectedCardAnimation;
  
  // 카드 선택 관련
  int? _hoveredCardIndex;
  int? _selectedCardIndex;
  bool _showConfirmation = false;
  
  // 드래그 관련
  double _verticalDragOffset = 0;
  int _startIndex = 0; // 현재 보여지는 첫 번째 카드 인덱스
  final int _visibleCardCount = 22; // 한 번에 보여지는 카드 수
  double _dragOffset = 0;
  double _currentOffset = 0;
  
  // 섞인 카드 리스트
  late List<TarotCardModel> _shuffledCards;
  
  @override
  void initState() {
    super.initState();
    
    // 카드 섞기
    _shuffledCards = List.from(TarotCardModel.fullDeck)..shuffle();
    
    // 부채꼴 애니메이션
    _fanAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // 선택된 카드 애니메이션
    _selectedCardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _selectedCardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _selectedCardController,
      curve: Curves.easeOut,
    ));
    
    // 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cardSelectionViewModelProvider.notifier).shuffleAndDeal();
      _fanAnimationController.forward();
    });
  }
  
  @override
  void dispose() {
    _fanAnimationController.dispose();
    _selectedCardController.dispose();
    super.dispose();
  }
  
  // 카드 위치 계산
  Offset _calculateCardPosition(int indexInView, Size screenSize) {
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height * 0.5;
    
    // 부채꼴 반경
    final radius = screenSize.width * 0.35;
    
    // 보이는 카드들의 각도 범위
    const visibleAngle = math.pi * 0.8; // 144도
    const angleStep = visibleAngle / 21; // 22장을 위한 간격
    const baseAngle = -math.pi / 2 - visibleAngle / 2;
    
    // 드래그 오프셋 적용
    final angle = baseAngle + (angleStep * indexInView) + (_currentOffset * 0.01);
    
    final x = centerX + radius * math.cos(angle);
    final y = centerY + radius * math.sin(angle);
    
    return Offset(x, y);
  }
  
  // 카드 회전 각도 계산
  double _calculateCardRotation(int indexInView) {
    const visibleAngle = math.pi * 0.8;
    const angleStep = visibleAngle / 21;
    
    return (angleStep * indexInView) - visibleAngle / 2 + (_currentOffset * 0.01);
  }
  
  Widget _buildCard(int cardIndex, int indexInView, TarotCardModel card, Size screenSize) {
    final position = _calculateCardPosition(indexInView, screenSize);
    final rotation = _calculateCardRotation(indexInView);
    final isHovered = _hoveredCardIndex == cardIndex;
    final isSelected = _selectedCardIndex == cardIndex;
    
    return AnimatedBuilder(
      animation: _fanAnimationController,
      builder: (context, child) {
        return Positioned(
          left: position.dx - 40,
          top: position.dy - 60,
          child: Transform.rotate(
            angle: rotation * _fanAnimationController.value,
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () => _selectCard(cardIndex, card),
              child: MouseRegion(
                onEnter: (_) => setState(() => _hoveredCardIndex = cardIndex),
                onExit: (_) => setState(() => _hoveredCardIndex = null),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()
                    ..translate(0.0, isHovered || isSelected ? -20.0 : 0.0)
                    ..scale(isHovered || isSelected ? 1.05 : 1.0),
                  child: Container(
                    width: 80,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF1a1a2e),
                      border: Border.all(
                        color: isHovered || isSelected 
                            ? AppColors.evilGlow 
                            : const Color(0xFF3a3a4e),
                        width: isHovered || isSelected ? 2 : 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '?',
                        style: TextStyle(
                          fontSize: 40,
                          color: Color(0xFF5a5a6e),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  void _selectCard(int index, TarotCardModel card) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 50);
    }
    
    setState(() {
      _selectedCardIndex = index;
      _showConfirmation = true;
    });
    
    _selectedCardController.forward();
  }
  
  void _confirmSelection(TarotCardModel card) async {
    if (_verticalDragOffset < -50) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 100);
      }
      
      // 카드 선택
      ref.read(cardSelectionViewModelProvider.notifier).selectCard(card);
      
      // 상태 초기화
      setState(() {
        _selectedCardIndex = null;
        _showConfirmation = false;
        _verticalDragOffset = 0;
      });
      
      _selectedCardController.reset();
      
      // 다음 화면으로 이동 체크
      final state = ref.read(cardSelectionViewModelProvider);
      final selectedSpread = ref.read(selectedSpreadProvider);
      
      if (state.selectedCards.length >= (selectedSpread?.cardCount ?? 1)) {
        final selectedCardIndices = state.selectedCards.map((c) => c.id).toList();
        if (mounted) {
          context.push('/result-chat', extra: selectedCardIndices);
        }
      }
    }
  }
  
  void _handleHorizontalDrag(double delta) {
    setState(() {
      _dragOffset += delta;
      
      // 카드 하나의 너비만큼 드래그하면 다음/이전 카드로
      if (_dragOffset.abs() > 50) {
        if (_dragOffset > 0 && _startIndex > 0) {
          // 오른쪽으로 드래그 - 이전 카드들 보기
          _startIndex = math.max(0, _startIndex - 5);
          _dragOffset = 0;
        } else if (_dragOffset < 0 && _startIndex + _visibleCardCount < 78) {
          // 왼쪽으로 드래그 - 다음 카드들 보기
          _startIndex = math.min(78 - _visibleCardCount, _startIndex + 5);
          _dragOffset = 0;
        }
      }
      
      _currentOffset = _dragOffset;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cardSelectionViewModelProvider);
    final userMood = ref.watch(userMoodProvider) ?? '';
    final selectedSpread = ref.watch(selectedSpreadProvider);
    final requiredCards = selectedSpread?.cardCount ?? 1;
    final remainingCards = requiredCards - state.selectedCards.length;
    
    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.mysticGradient,
          AppColors.darkGradient,
        ],
        child: SafeArea(
          child: GestureDetector(
            // 좌우 드래그로 카드 넘기기
            onHorizontalDragUpdate: (details) {
              if (!_showConfirmation) {
                _handleHorizontalDrag(details.delta.dx);
              }
            },
            onHorizontalDragEnd: (details) {
              setState(() {
                _currentOffset = 0;
                _dragOffset = 0;
              });
            },
            child: Stack(
              children: [
                // 카드 부채꼴 - 현재 범위의 카드만 표시
                if (state.showingCards)
                  for (int i = 0; i < _visibleCardCount && _startIndex + i < 78; i++)
                    _buildCard(
                      _startIndex + i,
                      i,
                      _shuffledCards[_startIndex + i],
                      MediaQuery.of(context).size,
                    ),
                
                // Header
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.shadowGray,
                          AppColors.shadowGray.withAlpha(0),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
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
                        const SizedBox(height: 8),
                        
                        // 정보 표시
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GlassMorphismContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                '기분: $userMood',
                                style: AppTextStyles.bodySmall,
                              ),
                            ),
                            const SizedBox(width: 12),
                            GlassMorphismContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                remainingCards > 0
                                    ? '$remainingCards장 더 선택'
                                    : '모든 카드 선택됨',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: remainingCards > 0
                                      ? AppColors.evilGlow
                                      : AppColors.spiritGlow,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // 드래그 힌트
                if (state.showingCards && state.selectedCards.isEmpty)
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GlassMorphismContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.swipe,
                              color: AppColors.fogGray,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '좌우로 드래그하여 더 많은 카드를 보세요',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.fogGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate(
                      onPlay: (controller) => controller.repeat(),
                    ).fadeIn().then().fadeOut(
                      delay: const Duration(seconds: 3),
                    ),
                  ),
                
                // 현재 카드 범위 표시
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GlassMorphismContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        '${_startIndex + 1} - ${math.min(_startIndex + _visibleCardCount, 78)} / 78',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.ghostWhite,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // 선택된 카드 개수 표시
                if (state.selectedCards.isNotEmpty)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: GlassMorphismContainer(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.style,
                            color: AppColors.spiritGlow,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${state.selectedCards.length}장 선택됨',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.spiritGlow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // 좌우 화살표 힌트
                if (_startIndex > 0)
                  Positioned(
                    left: 10,
                    top: MediaQuery.of(context).size.height / 2,
                    child: Icon(
                      Icons.chevron_left,
                      color: AppColors.fogGray.withAlpha(100),
                      size: 40,
                    ),
                  ),
                if (_startIndex + _visibleCardCount < 78)
                  Positioned(
                    right: 10,
                    top: MediaQuery.of(context).size.height / 2,
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColors.fogGray.withAlpha(100),
                      size: 40,
                    ),
                  ),
                
                // 카드 선택 확인 오버레이
                if (_showConfirmation && _selectedCardIndex != null)
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        _verticalDragOffset = math.min(0, _verticalDragOffset + details.delta.dy);
                      });
                    },
                    onVerticalDragEnd: (details) {
                      final card = _shuffledCards[_selectedCardIndex!];
                      _confirmSelection(card);
                    },
                    onTap: () {
                      setState(() {
                        _showConfirmation = false;
                        _selectedCardIndex = null;
                        _verticalDragOffset = 0;
                      });
                      _selectedCardController.reset();
                    },
                    child: Container(
                      color: AppColors.blackOverlay60,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _selectedCardAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _verticalDragOffset),
                              child: Transform.scale(
                                scale: _selectedCardAnimation.value,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // 선택된 카드 (여전히 뒷면)
                                    Container(
                                      width: 200,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: const Color(0xFF1a1a2e),
                                        border: Border.all(
                                          color: AppColors.evilGlow,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.evilGlow.withAlpha(150),
                                            blurRadius: 30,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '?',
                                              style: TextStyle(
                                                fontSize: 80,
                                                color: Color(0xFF5a5a6e),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              '운명의 카드',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF7a7a9a),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 30),
                                    
                                    // 안내 메시지
                                    GlassMorphismContainer(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Text(
                                            '이 카드를 선택하시겠습니까?',
                                            style: AppTextStyles.mysticTitle.copyWith(
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.swipe_up,
                                                color: AppColors.fogGray,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '위로 드래그하여 선택',
                                                style: AppTextStyles.bodyMedium.copyWith(
                                                  color: AppColors.fogGray,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '탭하여 취소',
                                            style: AppTextStyles.bodySmall.copyWith(
                                              color: AppColors.ashGray,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
  }
}