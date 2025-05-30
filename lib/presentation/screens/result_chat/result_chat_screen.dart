import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/tarot_card_model.dart';
import '../../../core/utils/app_logger.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';
import '../../widgets/common/custom_loading_indicator.dart';
import '../../widgets/spreads/spread_layout_widget.dart';
import '../../widgets/chat/chat_bubble_widget.dart';
import '../../widgets/chat/typing_indicator.dart';
import '../main/main_viewmodel.dart';
import '../spread_selection/spread_selection_viewmodel.dart';
import 'result_chat_viewmodel.dart';

class ResultChatScreen extends ConsumerStatefulWidget {
  final List<int> selectedCardIndices;
  
  const ResultChatScreen({
    super.key,
    required this.selectedCardIndices,
  });

  @override
  ConsumerState<ResultChatScreen> createState() => _ResultChatScreenState();
}

class _ResultChatScreenState extends ConsumerState<ResultChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  late AnimationController _layoutRevealController;
  late AnimationController _interpretationController;
  late AnimationController _cardFlipController;
  late Animation<double> _layoutFadeAnimation;
  late Animation<double> _interpretationFadeAnimation;
  
  bool _showInterpretation = false;
  bool _showChat = false;
  bool _isExpanded = false;

  final List<AnimationController> _sectionControllers = [];
  final List<Animation<double>> _sectionAnimations = [];

  @override
  void initState() {
    super.initState();
    
    _layoutRevealController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _interpretationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _cardFlipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _layoutFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _layoutRevealController,
      curve: Curves.easeIn,
    ));
    
    _interpretationFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _interpretationController,
      curve: Curves.easeIn,
    ));
    
    // 섹션별 애니메이션 초기화 - 최대 10개까지 지원
    for (int i = 0; i < 10; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 400 + (i * 100)),
        vsync: this,
      );
      _sectionControllers.add(controller);
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
      _sectionAnimations.add(animation);
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRevealSequence();
    });
  }

  Future<void> _startRevealSequence() async {
    final selectedSpread = ref.read(selectedSpreadProvider);
    final userMood = ref.read(userMoodProvider) ?? '';
    
    final cards = widget.selectedCardIndices
        .map((id) => TarotCardModel.getCardById(id))
        .toList();
    
    Future(() {
      ref.read(resultChatViewModelProvider.notifier).initializeWithSpread(
        cards: cards,
        userMood: userMood,
        spread: selectedSpread!,
      );
    });
    
    await Future.delayed(const Duration(milliseconds: 500));
    await _layoutRevealController.forward();
    
    await Future.delayed(const Duration(milliseconds: 1000));
    await _interpretationController.forward();
    
    setState(() {
      _showInterpretation = true;
    });
    
    // 섹션별 애니메이션 시작 - 실제 섹션 개수만큼만
    final sectionCount = math.min(_sectionControllers.length, 6); // 보통 4-6개 섹션
    for (int i = 0; i < sectionCount; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted && i < _sectionControllers.length) {
        _sectionControllers[i].forward();
      }
    }
    
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _showChat = true;
    });
  }

  // 해석을 섹션별로 파싱하여 카드로 만들기
  List<Widget> _buildInterpretationSections(String interpretation) {
    AppLogger.debug('해석 전체 내용: $interpretation');
    AppLogger.debug('해석 길이: ${interpretation.length}');
    
    final sections = <Widget>[];
    final parts = interpretation.split('\n\n');
    
    AppLogger.debug('파싱된 부분 개수: ${parts.length}');
    
    final sectionData = <Map<String, dynamic>>[];
    String currentTitle = '';
    String currentContent = '';
    
    for (final part in parts) {
      AppLogger.debug('현재 파트: $part');
      if (part.trim().startsWith('[') && part.trim().contains(']')) {
        if (currentTitle.isNotEmpty) {
          sectionData.add({
            'title': currentTitle,
            'content': currentContent.trim(),
          });
          AppLogger.debug('섹션 추가: $currentTitle');
        }
        currentTitle = part.trim().replaceAll('[', '').replaceAll(']', '');
        currentContent = '';
      } else {
        currentContent += '$part\n';
      }
    }
    
    if (currentTitle.isNotEmpty) {
      sectionData.add({
        'title': currentTitle,
        'content': currentContent.trim(),
      });
      AppLogger.debug('마지막 섹션 추가: $currentTitle');
    }
    
    AppLogger.debug('최종 섹션 개수: ${sectionData.length}');
    
    // 섹션이 없으면 전체 텍스트를 하나의 카드로 표시
    if (sectionData.isEmpty) {
      AppLogger.debug('섹션 파싱 실패 - 원본 텍스트 표시');
      return [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.mysticPurple.withAlpha(30),
                AppColors.deepViolet.withAlpha(20),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.mysticPurple.withAlpha(100),
              width: 1,
            ),
          ),
          child: Text(
            interpretation,
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
        ),
      ];
    }
    
    // 섹션별 아이콘과 색상 매핑
    final sectionStyles = {
      '카드의 메시지': {
        'icon': Icons.auto_awesome,
        'color': AppColors.spiritGlow,
        'gradient': [AppColors.spiritGlow, AppColors.mysticPurple],
      },
      '현재 상황': {
        'icon': Icons.remove_red_eye,
        'color': AppColors.evilGlow,
        'gradient': [AppColors.evilGlow, AppColors.crimsonGlow],
      },
      '실천 조언': {
        'icon': Icons.lightbulb_outline,
        'color': AppColors.omenGlow,
        'gradient': [AppColors.omenGlow, AppColors.mysticPurple],
      },
      '앞으로의 전망': {
        'icon': Icons.star_outline,
        'color': AppColors.spiritGlow,
        'gradient': [AppColors.mysticPurple, AppColors.deepViolet],
      },
    };
    
    for (int i = 0; i < sectionData.length; i++) {
      final animationIndex = i < _sectionAnimations.length ? i : _sectionAnimations.length - 1;
      final section = sectionData[i];
      final style = sectionStyles[section['title']] ?? {
        'icon': Icons.info_outline,
        'color': AppColors.fogGray,
        'gradient': [AppColors.fogGray, AppColors.ashGray],
      };
      
      sections.add(
        AnimatedBuilder(
          animation: _sectionAnimations[animationIndex],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - _sectionAnimations[animationIndex].value)),
              child: Opacity(
                opacity: _sectionAnimations[animationIndex].value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      // 탭하면 확장/축소
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            (style['gradient'] as List<Color>)[0].withAlpha(30),
                            (style['gradient'] as List<Color>)[1].withAlpha(20),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (style['color'] as Color).withAlpha(100),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 헤더
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: (style['color'] as Color).withAlpha(50),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      style['icon'] as IconData,
                                      color: style['color'] as Color,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      section['title'],
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: style['color'] as Color,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // 내용
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  section['content'],
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    height: 1.6,
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                  ),
                                  maxLines: _isExpanded ? null : 3,
                                  overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                ),
                              ),
                              // 실천 조언의 경우 특별 처리
                              if (section['title'] == '실천 조언' && section['content'].contains('•'))
                                Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    children: section['content']
                                        .split('•')
                                        .where((item) => item.trim().isNotEmpty)
                                        .map((item) => Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 4),
                                                    width: 6,
                                                    height: 6,
                                                    decoration: BoxDecoration(
                                                      color: style['color'] as Color,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      item.trim(),
                                                      style: AppTextStyles.bodyMedium.copyWith(
                                                        color: AppColors.textPrimary,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ).animate()
                        .shimmer(
                          duration: const Duration(seconds: 3),
                          color: (style['color'] as Color).withAlpha(30),
                          delay: Duration(milliseconds: i * 500),
                        ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    
    return sections;
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    
    _messageController.clear();
    
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 30);
    }
    
    await ref.read(resultChatViewModelProvider.notifier).sendMessage(message);
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAdPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: GlassMorphismContainer(
            padding: const EdgeInsets.all(32),
            borderRadius: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.evilGlow, AppColors.crimsonGlow],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.evilGlow.withAlpha(100),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.remove_red_eye,
                    size: 40,
                    color: AppColors.ghostWhite,
                  ),
                ).animate(
                  onPlay: (controller) => controller.repeat(),
                ).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  '더 깊은 진실을 원하시나요?',
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  '광고를 시청하고 무제한으로\n타로 마스터와 대화를 이어가세요',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.fogGray,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.ashGray,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            '다음에',
                            style: AppTextStyles.buttonMedium.copyWith(
                              color: AppColors.ashGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          await ref.read(resultChatViewModelProvider.notifier).showAd();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.crimsonGlow, AppColors.evilGlow],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.crimsonGlow.withAlpha(100),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Text(
                            '광고 보기',
                            style: AppTextStyles.buttonMedium,
                            textAlign: TextAlign.center,
                          ),
                        ).animate()
                            .shimmer(
                              duration: const Duration(seconds: 2),
                              color: AppColors.whiteOverlay20,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _layoutRevealController.dispose();
    _interpretationController.dispose();
    _cardFlipController.dispose();
    for (final controller in _sectionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  // 카드 개수에 따른 레이아웃 높이 계산
  double _getLayoutHeight(int cardCount) {
    switch (cardCount) {
      case 1:
        return 280; // 원카드
      case 3:
        return 320; // 쓰리카드
      case 5:
        return 320; // 예/아니오
      case 7:
        return 400; // 관계
      case 10:
        return 450; // 켈틱크로스
      default:
        return 380;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resultChatViewModelProvider);
    final selectedSpread = ref.watch(selectedSpreadProvider);
    final spreadName = selectedSpread?.nameKr ?? '';
    final isOneCard = state.selectedCards.length == 1;
    
    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.bloodGradient,
          AppColors.darkGradient,
        ],
        child: SafeArea(
          child: Column(
            children: [
              // 헤더 - 더 세련되게
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.shadowGray.withAlpha(200),
                      AppColors.shadowGray.withAlpha(0),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteOverlay10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => context.go('/main'),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.ghostWhite,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteOverlay10,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.whiteOverlay20,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          spreadName,
                          style: AppTextStyles.displaySmall.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // 컨텐츠
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // 카드 레이아웃
                    if (selectedSpread != null)
                      AnimatedBuilder(
                        animation: _layoutFadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _layoutFadeAnimation.value,
                            child: Container(
                              height: _getLayoutHeight(state.selectedCards.length),
                              margin: const EdgeInsets.only(bottom: 24),
                              child: SpreadLayoutWidget(
                                spread: selectedSpread,
                                drawnCards: state.selectedCards,
                                showCardNames: true,
                                isInteractive: false,
                              ),
                            ),
                          );
                        },
                      ),
                    
                    // 해석 섹션
                    if (_showInterpretation)
                      AnimatedBuilder(
                        animation: _interpretationFadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _interpretationFadeAnimation.value,
                            child: Column(
                              children: [
                                // 제목 카드
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.mysticPurple.withAlpha(50),
                                        AppColors.deepViolet.withAlpha(30),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.mysticPurple.withAlpha(100),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              AppColors.mysticPurple,
                                              AppColors.deepViolet,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          isOneCard ? Icons.style : Icons.dashboard,
                                          color: AppColors.ghostWhite,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isOneCard ? '카드가 전하는 메시지' : '카드들이 그리는 이야기',
                                              style: AppTextStyles.displaySmall.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '당신을 위한 특별한 해석',
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.fogGray,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // 로딩 또는 해석 내용
                                if (state.isLoadingInterpretation)
                                  Container(
                                    padding: const EdgeInsets.all(40),
                                    child: Column(
                                      children: [
                                        const CustomLoadingIndicator(
                                          size: 60,
                                          color: AppColors.evilGlow,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          '카드의 의미를 해석하는 중...',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: AppColors.fogGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  ..._buildInterpretationSections(
                                    state.spreadInterpretation ?? '',
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // 채팅 메시지들
                    if (_showChat) ...[
                      ...state.messages.map((message) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ChatBubbleWidget(
                          message: message.message,
                          isUser: message.isUser,
                          timestamp: message.timestamp,
                        ).animate()
                            .slideX(
                              begin: message.isUser ? 0.1 : -0.1,
                              duration: const Duration(milliseconds: 300),
                            )
                            .fadeIn(),
                      )),
                      
                      if (state.isTyping)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: TypingIndicator(),
                        ),
                    ],
                    
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              
              // 입력 영역 - 더 세련되게
              if (_showChat && !state.showAdPrompt)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.shadowGray,
                        AppColors.shadowGray.withAlpha(240),
                      ],
                    ),
                    border: const Border(
                      top: BorderSide(
                        color: AppColors.whiteOverlay10,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.blackOverlay40,
                                AppColors.blackOverlay60,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: AppColors.whiteOverlay10,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _messageController,
                            focusNode: _focusNode,
                            style: AppTextStyles.bodyMedium,
                            decoration: InputDecoration(
                              hintText: '궁금한 것을 물어보세요...',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.ashGray,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                            enabled: !state.isLoading,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: state.isLoading ? null : _sendMessage,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: state.isLoading
                                  ? [AppColors.ashGray, AppColors.fogGray]
                                  : [AppColors.crimsonGlow, AppColors.evilGlow],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: state.isLoading
                                ? []
                                : [
                                    BoxShadow(
                                      color: AppColors.crimsonGlow.withAlpha(100),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: AppColors.ghostWhite,
                            size: 22,
                          ),
                        ).animate()
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              duration: const Duration(milliseconds: 200),
                            ),
                      ),
                    ],
                  ),
                ),
              
              // 광고 프롬프트 - 프리미엄 디자인
              if (state.showAdPrompt)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.shadowGray,
                        AppColors.shadowGray.withAlpha(240),
                      ],
                    ),
                    border: const Border(
                      top: BorderSide(
                        color: AppColors.crimsonGlow,
                        width: 2,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: _showAdPrompt,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.crimsonGlow,
                              AppColors.evilGlow,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.crimsonGlow.withAlpha(100),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.remove_red_eye,
                              color: AppColors.ghostWhite,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '대화 계속하기',
                              style: AppTextStyles.buttonLarge.copyWith(
                                color: AppColors.ghostWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ).animate(
                        onPlay: (controller) => controller.repeat(),
                      ).scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.05, 1.05),
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeInOut,
                      ),
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