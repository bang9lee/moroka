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
import '../../../data/models/tarot_spread_model.dart';

/// 타로 결과 및 채팅 화면
/// 선택된 카드의 해석과 AI 채팅을 제공합니다
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
  // Controllers
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  // Animation Controllers
  late AnimationController _layoutRevealController;
  late AnimationController _interpretationController;
  late AnimationController _cardFlipController;
  late Animation<double> _layoutFadeAnimation;
  late Animation<double> _interpretationFadeAnimation;
  
  // State
  bool _showInterpretation = false;
  bool _showChat = false;

  // Section Animations
  final List<AnimationController> _sectionControllers = [];
  final List<Animation<double>> _sectionAnimations = [];

  // Constants
  static const Duration _layoutRevealDuration = Duration(milliseconds: 1500);
  static const Duration _interpretationDuration = Duration(milliseconds: 800);
  static const Duration _cardFlipDuration = Duration(milliseconds: 600);
  static const Duration _sectionStaggerDelay = Duration(milliseconds: 200);
  static const int _maxSectionAnimations = 10;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startRevealSequence();
  }

  void _initializeAnimations() {
    // Main animations
    _layoutRevealController = AnimationController(
      duration: _layoutRevealDuration,
      vsync: this,
    );
    
    _interpretationController = AnimationController(
      duration: _interpretationDuration,
      vsync: this,
    );
    
    _cardFlipController = AnimationController(
      duration: _cardFlipDuration,
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
    
    // Section animations
    _initializeSectionAnimations();
  }

  void _initializeSectionAnimations() {
    for (int i = 0; i < _maxSectionAnimations; i++) {
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
        curve: Curves.easeOut,
      ));
      _sectionAnimations.add(animation);
    }
  }

  Future<void> _startRevealSequence() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final selectedSpread = ref.read(selectedSpreadProvider);
    final userMood = ref.read(userMoodProvider) ?? '';
    
    final cards = widget.selectedCardIndices
        .map((id) => TarotCardModel.getCardById(id))
        .toList();
    
    // Initialize viewmodel
    await Future(() {
      ref.read(resultChatViewModelProvider.notifier).initializeWithSpread(
        cards: cards,
        userMood: userMood,
        spread: selectedSpread!,
      );
    });
    
    // Animate layout reveal
    await Future.delayed(const Duration(milliseconds: 500));
    await _layoutRevealController.forward();
    
    // Animate interpretation
    await Future.delayed(const Duration(milliseconds: 1000));
    await _interpretationController.forward();
    
    if (mounted) {
      setState(() {
        _showInterpretation = true;
      });
    }
    
    // Animate sections
    await _animateSections();
    
    // Show chat
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _showChat = true;
      });
    }
  }

  Future<void> _animateSections() async {
    final sectionCount = math.min(_sectionControllers.length, 6);
    for (int i = 0; i < sectionCount; i++) {
      await Future.delayed(_sectionStaggerDelay);
      if (mounted && i < _sectionControllers.length) {
        _sectionControllers[i].forward();
      }
    }
  }

  List<Widget> _buildInterpretationSections(String interpretation) {
    AppLogger.debug('Building interpretation sections');
    
    if (interpretation.isEmpty) {
      return [_buildEmptyInterpretation()];
    }
    
    final sectionData = _parseInterpretation(interpretation);
    
    if (sectionData.isEmpty) {
      return [_buildSingleInterpretationCard(interpretation)];
    }
    
    return sectionData.asMap().entries.map((entry) {
      final index = entry.key;
      final section = entry.value;
      return _buildSectionCard(index, section);
    }).toList();
  }

  List<Map<String, dynamic>> _parseInterpretation(String interpretation) {
    final parts = interpretation.split('\n\n');
    final sectionData = <Map<String, dynamic>>[];
    
    String currentTitle = '';
    String currentContent = '';
    
    for (final part in parts) {
      if (part.trim().startsWith('[') && part.trim().contains(']')) {
        if (currentTitle.isNotEmpty) {
          sectionData.add({
            'title': currentTitle,
            'content': currentContent.trim(),
          });
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
    }
    
    return sectionData;
  }

  Widget _buildEmptyInterpretation() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(40),
      child: const Center(
        child: Text(
          '해석을 준비하는 중입니다...',
          style: TextStyle(
            color: AppColors.fogGray,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSingleInterpretationCard(String interpretation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blackOverlay40,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.whiteOverlay10,
          width: 1,
        ),
      ),
      child: Text(
        interpretation,
        style: AppTextStyles.bodyMedium.copyWith(
          height: 1.7,
          color: AppColors.textPrimary,
          fontSize: 15,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildSectionCard(int index, Map<String, dynamic> section) {
    final animationIndex = index < _sectionAnimations.length 
        ? index 
        : _sectionAnimations.length - 1;
    
    final style = _getSectionStyle(section['title']);
    
    return AnimatedBuilder(
      animation: _sectionAnimations[animationIndex],
      builder: (context, child) {
        final animationValue = _sectionAnimations[animationIndex].value.clamp(0.0, 1.0);
        
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.blackOverlay40,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.whiteOverlay10,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        section['title'],
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: style['color'] as Color,
                          fontSize: 17,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    
                    // Section Content
                    if (section['title'] == '실천 조언' && section['content'].contains('•'))
                      _buildBulletPoints(section['content'], style)
                    else if (section['content'].contains('**'))
                      _buildFormattedContent(section['content'], style)
                    else
                      Text(
                        section['content'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          height: 1.7,
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          letterSpacing: -0.3,
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

  Widget _buildFormattedContent(String content, Map<String, dynamic> style) {
    final parts = content.split('\n');
    final widgets = <Widget>[];
    
    for (final part in parts) {
      if (part.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
      } else if (part.trim().startsWith('**') && part.trim().endsWith('**')) {
        final text = part.trim().replaceAll('**', '');
        widgets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8, top: 4),
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.ghostWhite,
                fontSize: 16,
              ),
            ),
          ),
        );
      } else if (part.trim().startsWith('-') || part.trim().startsWith('•')) {
        final text = part.trim().substring(1).trim();
        widgets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: (style['color'] as Color).withAlpha(150),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: Text(
              part,
              style: AppTextStyles.bodyMedium.copyWith(
                height: 1.6,
                color: AppColors.textPrimary,
                fontSize: 15,
                letterSpacing: -0.3,
              ),
            ),
          ),
        );
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildBulletPoints(String content, Map<String, dynamic> style) {
    final items = content
        .split('•')
        .where((item) => item.trim().isNotEmpty)
        .toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        final trimmedItem = item.trim();
        final hasNumber = RegExp(r'^\d+\.').hasMatch(trimmedItem);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.only(left: hasNumber ? 0 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!hasNumber) ...[
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: (style['color'] as Color).withAlpha(150),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  trimmedItem,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.5,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> _getSectionStyle(String title) {
    const sectionStyles = {
      '카드의 메시지': {
        'icon': Icons.auto_awesome,
        'color': AppColors.spiritGlow,
      },
      '현재 상황': {
        'icon': Icons.remove_red_eye,
        'color': AppColors.fogGray,
      },
      '실천 조언': {
        'icon': Icons.lightbulb_outline,
        'color': AppColors.omenGlow,
      },
      '앞으로의 전망': {
        'icon': Icons.star_outline,
        'color': AppColors.mysticPurple,
      },
      '전체 흐름': {
        'icon': Icons.timeline,
        'color': AppColors.spiritGlow,
      },
      '과거의 영향': {
        'icon': Icons.history,
        'color': AppColors.ashGray,
      },
      '다가올 미래': {
        'icon': Icons.trending_up,
        'color': AppColors.mysticPurple,
      },
      '행동 지침': {
        'icon': Icons.directions_run,
        'color': AppColors.omenGlow,
      },
    };
    
    return sectionStyles[title] ?? {
      'icon': Icons.info_outline,
      'color': AppColors.fogGray,
    };
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    
    _messageController.clear();
    
    // Haptic feedback
    await _triggerHapticFeedback(30);
    
    // Send message
    await ref.read(resultChatViewModelProvider.notifier).sendMessage(message);
    
    // Scroll to bottom
    _scrollToBottom();
  }

  Future<void> _triggerHapticFeedback(int duration) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(duration: duration);
    }
  }

  void _scrollToBottom() {
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
      builder: (context) => _AdPromptDialog(
        onAdWatch: () async {
          Navigator.pop(context);
          await ref.read(resultChatViewModelProvider.notifier).showAd();
        },
      ),
    );
  }

  double _getLayoutHeight(int cardCount) {
    switch (cardCount) {
      case 1:
        return 280;
      case 3:
        return 320;
      case 5:
        return 320;
      case 7:
        return 400;
      case 10:
        return 450;
      default:
        return 380;
    }
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
              _buildHeader(spreadName),
              Expanded(
                child: _buildContent(state, selectedSpread, isOneCard),
              ),
              if (_showChat && !state.showAdPrompt)
                _buildChatInput(state),
              if (state.showAdPrompt)
                _buildAdPromptBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String spreadName) {
    return Container(
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
          _buildCloseButton(),
          Expanded(
            child: _buildSpreadNameBadge(spreadName),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Container(
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
    );
  }

  Widget _buildSpreadNameBadge(String spreadName) {
    return Container(
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
    );
  }

  Widget _buildContent(
    ResultChatState state,
    TarotSpread? selectedSpread,
    bool isOneCard,
  ) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      children: [
        if (selectedSpread != null)
          _buildCardLayout(state, selectedSpread),
        if (_showInterpretation)
          _buildInterpretationSection(state, isOneCard),
        const SizedBox(height: 20),
        if (_showChat) 
          ..._buildChatMessages(state),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildCardLayout(ResultChatState state, TarotSpread selectedSpread) {
    return AnimatedBuilder(
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
    );
  }

  Widget _buildInterpretationSection(ResultChatState state, bool isOneCard) {
    return AnimatedBuilder(
      animation: _interpretationFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _interpretationFadeAnimation.value,
          child: Column(
            children: [
              _buildInterpretationHeader(isOneCard),
              if (state.isLoadingInterpretation)
                _buildLoadingIndicator()
              else
                ..._buildInterpretationSections(
                  state.spreadInterpretation ?? '',
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInterpretationHeader(bool isOneCard) {
    return Container(
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
      child: Column(
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
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
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
    );
  }

  List<Widget> _buildChatMessages(ResultChatState state) {
    final widgets = <Widget>[];
    
    widgets.addAll(
      state.messages.map((message) => Padding(
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
    );
    
    if (state.isTyping) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: TypingIndicator(),
        ),
      );
    }
    
    return widgets;
  }

  Widget _buildChatInput(ResultChatState state) {
    return Container(
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
      child: SafeArea(
        bottom: true,
        child: Row(
          children: [
            Expanded(
              child: _buildMessageField(state),
            ),
            const SizedBox(width: 12),
            _buildSendButton(state),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageField(ResultChatState state) {
    return Container(
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
    );
  }

  Widget _buildSendButton(ResultChatState state) {
    return GestureDetector(
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
    );
  }

  Widget _buildAdPromptBar() {
    return Container(
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
        bottom: true,
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
    );
  }
}

/// 광고 프롬프트 다이얼로그
class _AdPromptDialog extends StatelessWidget {
  final VoidCallback onAdWatch;
  
  const _AdPromptDialog({
    required this.onAdWatch,
  });
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: GlassMorphismContainer(
          padding: const EdgeInsets.all(32),
          borderRadius: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(),
              const SizedBox(height: 24),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildDescription(),
              const SizedBox(height: 32),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildIcon() {
    return Container(
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
    );
  }
  
  Widget _buildTitle() {
    return Text(
      '더 깊은 진실을 원하시나요?',
      style: AppTextStyles.displaySmall.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _buildDescription() {
    return Text(
      '광고를 시청하고 무제한으로\n타로 마스터와 대화를 이어가세요',
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.fogGray,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCancelButton(context),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildWatchAdButton(),
        ),
      ],
    );
  }
  
  Widget _buildCancelButton(BuildContext context) {
    return GestureDetector(
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
    );
  }
  
  Widget _buildWatchAdButton() {
    return GestureDetector(
      onTap: onAdWatch,
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
    );
  }
}