import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/tarot_reading_model.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';
import '../../widgets/common/custom_loading_indicator.dart';
import 'history_viewmodel.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late final ScrollController _scrollController;
  late final DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');
    _initializeScreen();
  }

  void _initializeScreen() {
    // Load initial readings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyViewModelProvider.notifier).loadReadings();
    });
    
    // Setup pagination
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      ref.read(historyViewModelProvider.notifier).loadMoreReadings();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyViewModelProvider);

    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.darkGradient,
          AppColors.mysticGradient,
        ],
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildContent(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.ghostWhite,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '지난 타로 기록',
                  style: AppTextStyles.displaySmall.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  '과거의 운명을 되돌아보세요',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.fogGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(HistoryState state) {
    if (state.isLoading && state.readings.isEmpty) {
      return const Center(
        child: CustomLoadingIndicator(
          size: 60,
          color: AppColors.evilGlow,
          message: '기록을 불러오는 중...',
        ),
      );
    }

    if (state.readings.isEmpty) {
      return _buildEmptyState();
    }

    return _buildReadingsList(state);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppColors.fogGray.withAlpha(100),
          ),
          const SizedBox(height: 24),
          Text(
            '아직 타로 기록이 없습니다',
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 20,
              color: AppColors.fogGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 번째 운명을 읽어보세요',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.ashGray,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/main'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mysticPurple,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: const Text(
              '타로 읽기 시작',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingsList(HistoryState state) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(historyViewModelProvider.notifier).refreshReadings();
      },
      color: AppColors.evilGlow,
      backgroundColor: AppColors.shadowGray,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        itemCount: state.readings.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.readings.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CustomLoadingIndicator(
                  size: 40,
                  color: AppColors.evilGlow,
                ),
              ),
            );
          }
          
          final reading = state.readings[index];
          return _buildReadingCard(reading, index);
        },
      ),
    );
  }

  Widget _buildReadingCard(TarotReadingModel reading, int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to reading detail
        _showReadingDetail(reading);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: GlassMorphismContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(reading),
              const SizedBox(height: 16),
              _buildCardTags(reading),
              const SizedBox(height: 12),
              _buildCardFooter(reading),
            ],
          ),
        ),
      ).animate()
          .fadeIn(
            duration: const Duration(milliseconds: 400),
            delay: Duration(milliseconds: index * 100),
          )
          .slideY(
            begin: 0.1,
            end: 0,
            duration: const Duration(milliseconds: 400),
            delay: Duration(milliseconds: index * 100),
          ),
    );
  }

  Widget _buildCardHeader(TarotReadingModel reading) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.mysticPurple, AppColors.deepViolet],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '${reading.cardCount ?? 1}',
              style: AppTextStyles.displaySmall.copyWith(
                fontSize: 24,
                color: AppColors.ghostWhite,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reading.spreadName,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _dateFormat.format(reading.createdAt),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.fogGray,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.fogGray,
        ),
      ],
    );
  }

  Widget _buildCardTags(TarotReadingModel reading) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: reading.cardNames.map((cardName) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.mysticPurple.withAlpha(50),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.mysticPurple.withAlpha(100),
              width: 1,
            ),
          ),
          child: Text(
            cardName,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMystic,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCardFooter(TarotReadingModel reading) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.mood,
              size: 16,
              color: AppColors.fogGray,
            ),
            const SizedBox(width: 8),
            Text(
              '기분: ${reading.userMood}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.fogGray,
              ),
            ),
          ],
        ),
        if (reading.chatHistory.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: AppColors.fogGray,
                ),
                const SizedBox(width: 8),
                Text(
                  '대화 ${reading.chatHistory.length}회',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.fogGray,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showReadingDetail(TarotReadingModel reading) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.shadowGray,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            border: Border(
              top: BorderSide(color: AppColors.cardBorder, width: 1),
              left: BorderSide(color: AppColors.cardBorder, width: 1),
              right: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: Column(
            children: [
              _buildDetailHandle(),
              Expanded(
                child: _buildDetailContent(reading, scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.whiteOverlay30,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _buildDetailContent(
    TarotReadingModel reading,
    ScrollController scrollController,
  ) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      children: [
        _buildDetailHeader(reading),
        const SizedBox(height: 24),
        _buildDetailCards(reading),
        const SizedBox(height: 24),
        _buildDetailInterpretation(reading),
        if (reading.chatHistory.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildDetailChatHistory(reading),
        ],
        const SizedBox(height: 24),
        _buildDeleteButton(reading),
      ],
    );
  }

  Widget _buildDetailHeader(TarotReadingModel reading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reading.spreadName,
          style: AppTextStyles.displaySmall.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          _dateFormat.format(reading.createdAt),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.fogGray,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCards(TarotReadingModel reading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '선택된 카드',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: reading.cardNames.map((cardName) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.mysticPurple,
                    AppColors.deepViolet,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cardName,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.ghostWhite,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDetailInterpretation(TarotReadingModel reading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '해석',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.blackOverlay20,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.whiteOverlay10,
              width: 1,
            ),
          ),
          child: Text(
            reading.interpretation,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailChatHistory(TarotReadingModel reading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '대화 기록',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...reading.chatHistory.map((chat) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChatMessage(
                title: '질문',
                content: chat.userMessage,
                color: AppColors.mysticPurple,
                backgroundColor: AppColors.mysticPurple.withAlpha(50),
              ),
              const SizedBox(height: 8),
              _buildChatMessage(
                title: '타로 마스터',
                content: chat.aiResponse,
                color: AppColors.evilGlow,
                backgroundColor: AppColors.blackOverlay20,
                hasBorder: true,
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildChatMessage({
    required String title,
    required String content,
    required Color color,
    required Color backgroundColor,
    bool hasBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: hasBorder
            ? Border.all(color: AppColors.whiteOverlay10, width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(TarotReadingModel reading) {
    return GestureDetector(
      onTap: () => _showDeleteConfirmation(reading.id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.bloodMoon.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.bloodMoon,
            width: 1,
          ),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_outline,
                color: AppColors.crimsonGlow,
              ),
              SizedBox(width: 8),
              Text(
                '기록 삭제',
                style: TextStyle(
                  color: AppColors.crimsonGlow,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String readingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.shadowGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        title: Text(
          '기록을 삭제하시겠습니까?',
          style: AppTextStyles.displaySmall.copyWith(fontSize: 20),
        ),
        content: Text(
          '삭제된 기록은 복구할 수 없습니다',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.fogGray,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textMystic,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              await ref.read(historyViewModelProvider.notifier)
                  .deleteReading(readingId);
            },
            child: Text(
              '삭제',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.crimsonGlow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}