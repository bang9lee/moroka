import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_assets.dart';
import '../../../data/models/tarot_card_model.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';
import '../../widgets/cards/tarot_card_widget.dart';
import '../../widgets/chat/chat_bubble_widget.dart';
import '../../widgets/chat/typing_indicator.dart';
import '../main/main_viewmodel.dart';
import 'result_chat_viewmodel.dart';

class ResultChatScreen extends ConsumerStatefulWidget {
  final int selectedCardIndex;
  
  const ResultChatScreen({
    super.key,
    required this.selectedCardIndex,
  });

  @override
  ConsumerState<ResultChatScreen> createState() => _ResultChatScreenState();
}

class _ResultChatScreenState extends ConsumerState<ResultChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  late AnimationController _cardRevealController;
  late AnimationController _interpretationController;
  late Animation<double> _cardFlipAnimation;
  late Animation<double> _interpretationFadeAnimation;
  
  bool _showInterpretation = false;
  bool _showChat = false;

  @override
  void initState() {
    super.initState();
    
    _cardRevealController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _interpretationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _cardFlipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardRevealController,
      curve: Curves.easeInOut,
    ));
    
    _interpretationFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _interpretationController,
      curve: Curves.easeIn,
    ));
    
    _startRevealSequence();
  }

  Future<void> _startRevealSequence() async {
    // Get initial interpretation
    final card = TarotCardModel.getCardById(widget.selectedCardIndex);
    final userMood = ref.read(userMoodProvider) ?? '';
    
    ref.read(resultChatViewModelProvider.notifier).initialize(
      card: card,
      userMood: userMood,
    );
    
    // Start reveal animation
    await Future.delayed(const Duration(milliseconds: 500));
    await _cardRevealController.forward();
    
    setState(() {
    });
    
    await Future.delayed(const Duration(milliseconds: 500));
    await _interpretationController.forward();
    
    setState(() {
      _showInterpretation = true;
    });
    
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _showChat = true;
    });
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
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showAdPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassMorphismContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.remove_red_eye,
                size: 64,
                color: AppColors.evilGlow,
              ).animate(
                onPlay: (controller) => controller.repeat(),
              ).shimmer(
                duration: const Duration(seconds: 2),
                color: AppColors.spiritGlow,
              ),
              
              const SizedBox(height: 24),
              
              Text(
                '더 깊은 진실',
                style: AppTextStyles.displaySmall.copyWith(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                AppStrings.watchAdPrompt,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.fogGray,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '거부하기',
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: AppColors.ashGray,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await ref.read(resultChatViewModelProvider.notifier).showAd();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.crimsonGlow,
                    ),
                    child: Text(
                      '받아들이기',
                      style: AppTextStyles.buttonMedium,
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _cardRevealController.dispose();
    _interpretationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resultChatViewModelProvider);
    final card = state.selectedCard;
    
    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.bloodGradient,
          AppColors.darkGradient,
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
                      onPressed: () => context.go('/main'),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.ghostWhite,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        card?.nameKr ?? '',
                        style: AppTextStyles.displaySmall.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Card reveal
                      AnimatedBuilder(
                        animation: _cardFlipAnimation,
                        builder: (context, child) {
                          final isShowingFront = _cardFlipAnimation.value >= 0.5;
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(_cardFlipAnimation.value * 3.14159),
                            child: isShowingFront
                                ? Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..rotateY(3.14159),
                                    child: TarotCardFront(
                                      cardName: card?.nameKr ?? '',
                                      imagePath: AppAssets.getCardImage(widget.selectedCardIndex),
                                    ),
                                  )
                                : Container(
                                    width: 200,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: AppColors.mysticGradient,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.cardBorder,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        size: 80,
                                        color: AppColors.ghostWhite,
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Initial interpretation
                      if (_showInterpretation)
                        AnimatedBuilder(
                          animation: _interpretationFadeAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _interpretationFadeAnimation.value,
                              child: GlassMorphismContainer(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      '첫 번째 속삭임',
                                      style: AppTextStyles.mysticTitle.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (state.isLoadingInterpretation)
                                      const CircularProgressIndicator(
                                        color: AppColors.evilGlow,
                                      )
                                    else
                                      Text(
                                        state.interpretation?.interpretation ?? '',
                                        style: AppTextStyles.interpretation,
                                        textAlign: TextAlign.center,
                                      ),
                                  ],
                                ),
                              ).animate().shimmer(
                                duration: const Duration(seconds: 3),
                                color: AppColors.whiteOverlay10,
                              ),
                            );
                          },
                        ),
                      
                      const SizedBox(height: 24),
                      
                      // Chat messages
                      if (_showChat) ...[
                        ...state.messages.map((message) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ChatBubbleWidget(
                            message: message.message,
                            isUser: message.isUser,
                            timestamp: message.timestamp,
                          ),
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
              ),
              
                // Input area
              if (_showChat && !state.showAdPrompt)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.shadowGray,
                    border: Border(
                      top: BorderSide(color: AppColors.cardBorder),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          focusNode: _focusNode,
                          style: AppTextStyles.bodyMedium,
                          decoration: InputDecoration(
                            hintText: AppStrings.typeMessageHint,
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.ashGray,
                            ),
                            filled: true,
                            fillColor: AppColors.blackOverlay40,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                          enabled: !state.isLoading,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: state.isLoading ? null : _sendMessage,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: state.isLoading
                                ? AppColors.ashGray
                                : AppColors.crimsonGlow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send,
                            color: AppColors.ghostWhite,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Ad prompt
              if (state.showAdPrompt)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.shadowGray,
                    border: Border(
                      top: BorderSide(color: AppColors.cardBorder),
                    ),
                  ),
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: _showAdPrompt,
                      child: GlassMorphismContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: AppColors.bloodMoon.withAlpha(50),
                        borderColor: AppColors.crimsonGlow,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.remove_red_eye,
                              color: AppColors.crimsonGlow,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              AppStrings.continueReading,
                              style: AppTextStyles.buttonLarge.copyWith(
                                color: AppColors.ghostWhite,
                              ),
                            ),
                          ],
                        ),
                      ).animate(
                        onPlay: (controller) => controller.repeat(),
                      ).shimmer(
                        duration: const Duration(seconds: 3),
                        color: AppColors.omenGlow,
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