import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../l10n/generated/app_localizations.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/tarot_reading_model.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';
import '../../widgets/common/custom_loading_indicator.dart';
import '../../widgets/common/accessible_button.dart';
import '../../widgets/common/accessible_icon_button.dart';
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
    _initializeScreen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize date format with current locale
    final locale = Localizations.localeOf(context);
    _dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();
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

  String _getLocalizedSpreadNameFromKey(String spreadNameKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (spreadNameKey) {
      case 'spreadOneCard':
        return l10n.spreadOneCard;
      case 'spreadThreeCard':
        return l10n.spreadThreeCard;
      case 'spreadCelticCross':
        return l10n.spreadCelticCross;
      case 'spreadRelationship':
        return l10n.spreadRelationship;
      case 'spreadYesNo':
        return l10n.spreadYesNo;
      default:
        return l10n.spreadOneCard;
    }
  }

  String _getLocalizedSpreadName(String? spreadType) {
    final l10n = AppLocalizations.of(context)!;
    switch (spreadType) {
      case 'SpreadType.oneCard':
        return l10n.spreadOneCard;
      case 'SpreadType.threeCard':
        return l10n.spreadThreeCard;
      case 'SpreadType.celticCross':
        return l10n.spreadCelticCross;
      case 'SpreadType.relationship':
        return l10n.spreadRelationship;
      case 'SpreadType.yesNo':
        return l10n.spreadYesNo;
      default:
        return spreadType ?? '';
    }
  }

  Widget _buildDeleteAllButton(AppLocalizations l10n) {
    return GestureDetector(
      onTap: _showDeleteAllConfirmDialog,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.bloodMoon.withAlpha(30),
              AppColors.crimsonGlow.withAlpha(20),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.bloodMoon.withAlpha(50),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.bloodMoon.withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _showDeleteAllConfirmDialog,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete_sweep_rounded,
                    color: AppColors.crimsonGlow,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      l10n.deleteAll,
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: AppColors.crimsonGlow,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate()
        .fadeIn(duration: const Duration(milliseconds: 400))
        .slideY(
          begin: -0.2,
          end: 0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
        ),
    );
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(historyViewModelProvider);
    
    return Column(
      children: [
        Container(
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
                child: AccessibleIconButton(
                  onPressed: () => context.pop(),
                  icon: Icons.arrow_back,
                  semanticLabel: l10n.back,
                  color: AppColors.ghostWhite,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.menuHistory,
                      style: AppTextStyles.displaySmall.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.menuHistoryDesc,
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
        if (state.readings.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _buildDeleteAllButton(l10n),
          ),
      ],
    );
  }

  Widget _buildContent(HistoryState state) {
    final l10n = AppLocalizations.of(context)!;
    
    if (state.isLoading && state.readings.isEmpty) {
      return Center(
        child: CustomLoadingIndicator(
          size: 60,
          color: AppColors.evilGlow,
          message: l10n.loadingHistory,
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
            AppLocalizations.of(context)!.noHistoryTitle,
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 20,
              color: AppColors.fogGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noHistoryMessage,
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
            child: Text(
              AppLocalizations.of(context)!.startReading,
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
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: '${_getLocalizedSpreadNameFromKey(reading.spreadNameKey)}, ${l10n.date}: ${_dateFormat.format(reading.createdAt)}',
      button: true,
      child: GestureDetector(
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
                _getLocalizedSpreadName(reading.spreadType),
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
          child: Semantics(
            label: '${AppLocalizations.of(context)!.card}: $cardName',
            child: Text(
              cardName,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMystic,
              ),
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
            Semantics(
              label: '${AppLocalizations.of(context)!.currentMoodLabel}${reading.userMood}',
              child: Text(
                '${AppLocalizations.of(context)!.currentMoodLabel}${reading.userMood}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.fogGray,
                ),
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
                Semantics(
                  label: '${AppLocalizations.of(context)!.chatCount}: ${reading.chatHistory.length}',
                  child: Text(
                    AppLocalizations.of(context)!.chatCount(reading.chatHistory.length),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.fogGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _showDeleteAllConfirmDialog() async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassMorphismContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.error,
                  size: 64,
                ).animate()
                  .scale(duration: const Duration(milliseconds: 600))
                  .shake(duration: const Duration(milliseconds: 600)),
                const SizedBox(height: 24),
                Text(
                  l10n.deleteAllConfirmTitle,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.deleteAllConfirmMessage,
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: AccessibleButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        text: l10n.cancel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AccessibleButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        text: l10n.deleteAllButton,
                        icon: Icons.delete_forever,
                        isDestructive: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    
    if ((confirmed ?? false) && mounted) {
      await ref.read(historyViewModelProvider.notifier).deleteAllReadings();
    }
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
          _getLocalizedSpreadNameFromKey(reading.spreadNameKey),
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
          AppLocalizations.of(context)!.selectedCards,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.interpretation,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.chatHistory,
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
                title: l10n.question,
                content: chat.userMessage,
                color: AppColors.mysticPurple,
                backgroundColor: AppColors.mysticPurple.withAlpha(50),
              ),
              const SizedBox(height: 8),
              _buildChatMessage(
                title: l10n.tarotMaster,
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
    final l10n = AppLocalizations.of(context)!;
    return AccessibleButton(
      onPressed: () => _showDeleteConfirmation(reading.id),
      text: l10n.deleteReading,
      semanticLabel: l10n.deleteReadingDescription,
      icon: Icons.delete_outline,
      isDestructive: true,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    );
  }

  void _showDeleteConfirmation(String readingId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.shadowGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        title: Text(
          l10n.deleteReadingTitle,
          style: AppTextStyles.dialogTitle,
        ),
        content: Text(
          l10n.deleteReadingMessage,
          style: AppTextStyles.dialogContent.copyWith(
            color: AppColors.fogGray,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: AppTextStyles.dialogButton.copyWith(
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
              l10n.delete,
              style: AppTextStyles.dialogButton.copyWith(
                color: AppColors.crimsonGlow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}