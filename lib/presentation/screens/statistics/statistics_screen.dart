import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/custom_loading_indicator.dart';
import 'statistics_viewmodel.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadStatistics();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animations = List.generate(
      6,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1,
            0.5 + index * 0.1,
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );

    _animationController.forward();
  }

  void _loadStatistics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statisticsViewModelProvider.notifier).loadStatistics();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statisticsViewModelProvider);
    final screenSize = MediaQuery.of(context).size;

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
                child: _buildContent(state, screenSize),
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.blackOverlay40,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.whiteOverlay10,
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.ghostWhite,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.menuStatistics,
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.menuStatisticsDesc,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.fogGray,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildContent(StatisticsState state, Size screenSize) {
    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomLoadingIndicator(
              size: 80,
              color: AppColors.mysticPurple,
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.analyzingDestiny,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.fogGray,
                fontSize: 18,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .shimmer(
                  duration: const Duration(seconds: 2),
                  color: AppColors.mysticPurple,
                ),
          ],
        ),
      );
    }

    if (state.statistics == null) {
      return _buildEmptyState();
    }

    return _buildStatisticsContent(state, screenSize);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.mysticPurple.withAlpha(40),
                    AppColors.deepViolet.withAlpha(20),
                  ],
                ),
              ),
              child: Icon(
                Icons.analytics,
                size: 60,
                color: AppColors.fogGray.withAlpha(150),
              ),
            ).animate().scale(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.noDataToAnalyze,
              style: AppTextStyles.displaySmall.copyWith(
                fontSize: 24,
                color: AppColors.fogGray,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.startTarotReading,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.ashGray,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => context.go('/main'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.mysticPurple, AppColors.deepViolet],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mysticPurple.withAlpha(100),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Text(
                  AppLocalizations.of(context)!.startReading,
                  style: AppTextStyles.buttonLarge.copyWith(
                    fontSize: 18,
                  ),
                ),
              ),
            ).animate().scale(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 600),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsContent(StatisticsState state, Size screenSize) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAnimatedStatCard(
            index: 0,
            title: AppLocalizations.of(context)!.totalTarotReadings,
            value: AppLocalizations.of(context)!.timesCount(state.statistics!['totalReadings'] ?? 0),
            icon: Icons.style,
            gradient: [AppColors.mysticPurple, AppColors.deepViolet],
          ),
          const SizedBox(height: 16),

          if (state.statistics!['mostFrequentCard'] != null) ...[
            _buildAnimatedStatCard(
              index: 1,
              title: AppLocalizations.of(context)!.mostFrequentCard,
              value: state.statistics!['mostFrequentCard'] ?? '',
              icon: Icons.star,
              gradient: [AppColors.omenGlow, AppColors.crimsonGlow],
            ),
            const SizedBox(height: 24),
          ],

          if ((state.statistics!['cardFrequency'] as Map).isNotEmpty) ...[
            _buildAnimatedChart(
              index: 2,
              title: AppLocalizations.of(context)!.cardFrequencyTop5,
              child: _buildCardFrequencyChart(
                state.statistics!['cardFrequency'] as Map<String, int>,
                screenSize,
              ),
              height: 300,
            ),
            const SizedBox(height: 24),
          ],

          if ((state.statistics!['moodFrequency'] as Map).isNotEmpty) ...[
            _buildAnimatedChart(
              index: 3,
              title: AppLocalizations.of(context)!.moodAnalysis,
              child: _buildMoodPieChart(
                state.statistics!['moodFrequency'] as Map<String, int>,
                screenSize,
              ),
              height: 700,
            ),
            const SizedBox(height: 24),
          ],

          if (state.monthlyTrend.isNotEmpty) ...[
            _buildAnimatedChart(
              index: 4,
              title: AppLocalizations.of(context)!.monthlyReadingTrend,
              child: _buildMonthlyTrendChart(state.monthlyTrend, screenSize),
              height: 300,
            ),
            const SizedBox(height: 24),
          ],

          // 하단 여백
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatCard({
    required int index,
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _animations[index].value,
          child: Opacity(
            opacity: _animations[index].value,
            child: _buildStatCard(
              title: title,
              value: value,
              icon: icon,
              gradient: gradient,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedChart({
    required int index,
    required String title,
    required Widget child,
    required double height,
  }) {
    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, chartChild) {
        return Transform.scale(
          scale: _animations[index].value,
          child: Opacity(
            opacity: _animations[index].value,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.blackOverlay40,
                    AppColors.blackOverlay60,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.whiteOverlay10,
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.blackOverlay40,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.mysticPurple.withAlpha(20),
                            Colors.transparent,
                          ],
                        ),
                        border: const Border(
                          bottom: BorderSide(
                            color: AppColors.whiteOverlay10,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.displaySmall.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ghostWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      height: height,
                      child: child,
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blackOverlay40,
            AppColors.blackOverlay60,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.whiteOverlay10,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackOverlay40,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withAlpha(100),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: AppColors.ghostWhite,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.fogGray,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: AppTextStyles.displaySmall.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ghostWhite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFrequencyChart(Map<String, int> frequency, Size screenSize) {
    final sortedEntries = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topEntries = sortedEntries.take(5).toList();

    if (topEntries.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noData,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.fogGray,
          ),
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: topEntries.first.value.toDouble() + 2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: AppColors.shadowGray,
            tooltipBorder: const BorderSide(
              color: AppColors.mysticPurple,
              width: 1,
            ),
            tooltipRoundedRadius: 12,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${topEntries[group.x.toInt()].key}\n${AppLocalizations.of(context)!.timesCount(rod.toY.toInt())}',
                AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.ghostWhite,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= topEntries.length) return const SizedBox();
                final cardName = topEntries[value.toInt()].key;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    cardName.length > 6
                        ? '${cardName.substring(0, 6)}...'
                        : cardName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 11,
                      color: AppColors.fogGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
              reservedSize: 32,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    color: AppColors.fogGray,
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: AppColors.whiteOverlay10,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: topEntries.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.value.toDouble(),
                gradient: const LinearGradient(
                  colors: [AppColors.mysticPurple, AppColors.evilGlow],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: screenSize.width < 400 ? 20 : 28,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: topEntries.first.value.toDouble() + 2,
                  color: AppColors.whiteOverlay10,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMoodPieChart(Map<String, int> moodFrequency, Size screenSize) {
    final total = moodFrequency.values.fold(0, (sum, value) => sum + value);
    if (total == 0) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noData,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.fogGray,
          ),
        ),
      );
    }

    final colors = [
      AppColors.mysticPurple,
      AppColors.evilGlow,
      AppColors.spiritGlow,
      AppColors.omenGlow,
      AppColors.crimsonGlow,
      AppColors.deepViolet,
      AppColors.bloodMoon,
    ];

    // 값이 큰 순서대로 정렬
    final sortedMoodEntries = moodFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        // 파이 차트
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 50,
              sections:
                  sortedMoodEntries.asMap().entries.map((entry) {
                final index = entry.key;
                final moodEntry = entry.value;
                final count = moodEntry.value;
                final percentage = (count / total * 100);
                final isLarge = percentage > 15;

                return PieChartSectionData(
                  color: colors[index % colors.length],
                  value: count.toDouble(),
                  title: '${percentage.toStringAsFixed(0)}%',
                  radius: isLarge ? 90 : 85,
                  titleStyle: AppTextStyles.bodyMedium.copyWith(
                    fontSize: isLarge ? 16 : 14,
                    color: AppColors.ghostWhite,
                    fontWeight: FontWeight.bold,
                  ),
                  titlePositionPercentageOffset: 0.55,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 30),
        // 레전드를 아래에 배치 - 2개씩 가로로 배치 (정렬된 순서대로)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              for (int i = 0; i < sortedMoodEntries.length; i += 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 첫 번째 아이템
                      Expanded(
                        child: _buildLegendItem(
                          sortedMoodEntries[i],
                          i,
                          colors,
                          total,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 두 번째 아이템 (있을 경우에만)
                      if (i + 1 < sortedMoodEntries.length)
                        Expanded(
                          child: _buildLegendItem(
                            sortedMoodEntries[i + 1],
                            i + 1,
                            colors,
                            total,
                          ),
                        )
                      else
                        const Expanded(child: SizedBox()), // 빈 공간 유지
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyTrendChart(
      Map<String, int> monthlyTrend, Size screenSize) {
    final sortedEntries = monthlyTrend.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (sortedEntries.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noData,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.fogGray,
          ),
        ),
      );
    }

    final maxY = sortedEntries
            .map((e) => e.value)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() +
        2;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: AppColors.whiteOverlay10,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= sortedEntries.length) {
                  return const SizedBox();
                }
                final month = sortedEntries[value.toInt()].key.split('-')[1];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    AppLocalizations.of(context)!.monthLabel(int.parse(month).toString()),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 11,
                      color: AppColors.fogGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
              reservedSize: 32,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    color: AppColors.fogGray,
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: sortedEntries.length.toDouble() - 1,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: sortedEntries.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
            }).toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [AppColors.mysticPurple, AppColors.evilGlow],
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: AppColors.evilGlow,
                  strokeWidth: 3,
                  strokeColor: AppColors.ghostWhite,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.mysticPurple.withAlpha(60),
                  AppColors.evilGlow.withAlpha(10),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppColors.shadowGray,
            tooltipBorder: const BorderSide(
              color: AppColors.mysticPurple,
              width: 1,
            ),
            tooltipRoundedRadius: 12,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final entry = sortedEntries[spot.x.toInt()];
                final month = entry.key.split('-')[1];
                return LineTooltipItem(
                  '${AppLocalizations.of(context)!.monthLabel(int.parse(month).toString())}\n${AppLocalizations.of(context)!.timesCount(spot.y.toInt())}',
                  AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.ghostWhite,
                    fontSize: 14,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    MapEntry<String, int> moodEntry,
    int index,
    List<Color> colors,
    int total,
  ) {
    final count = moodEntry.value;
    final percentage = (count / total * 100).toStringAsFixed(1);
    
    // 저장된 mood 텍스트를 현재 언어로 변환
    final moodText = _getLocalizedMoodText(moodEntry.key);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blackOverlay40,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors[index % colors.length].withAlpha(100),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              '$moodText ($percentage%)',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 15,
                color: AppColors.ghostWhite,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  // 저장된 mood 텍스트를 현재 언어로 변환하는 헬퍼 함수
  String _getLocalizedMoodText(String savedMood) {
    final l10n = AppLocalizations.of(context)!;
    
    // 각 mood 타입에 대한 모든 가능한 번역들
    final moodMappings = {
      'anxious': ['불안', 'Anxious', '不安', '焦虑', 'Anxieux', 'Ansioso', 'Ängstlich', 'กังวล', 'Lo lắng', 'चिंतित', 'Solo'],
      'lonely': ['외로움', 'Lonely', '孤独', 'Seul', 'Solitario', 'Einsam', 'Solitário', 'เหงา', 'Cô đơn', 'अकेला', '寂しい'],
      'curious': ['궁금', 'Curious', '好奇心', '好奇', 'Curieux', 'Curioso', 'Neugierig', 'อยากรู้', 'Tò mò', 'जिज्ञासु'],
      'fearful': ['두려움', 'Fearful', '恐怖', '恐惧', 'Craintif', 'Temeroso', 'Furchtsam', 'กลัว', 'Sợ hãi', 'भयभीत'],
      'hopeful': ['희망', 'Hopeful', '希望的', '충만희망', '充满希望', 'Plein d\'espoir', 'Esperanzado', 'Hoffnungsvoll', 'Esperançoso', 'มีความหวัง', 'Hy vọng', 'आशावान', '希望'],
      'confused': ['혼란', 'Confused', '困惑', '混乱', 'Confus', 'Confundido', 'Verwirrt', 'Confuso', 'สับสน', 'Bối rối', 'भ्रमित'],
      'desperate': ['간절', 'Desperate', '絶望的な', '절망적', '绝望', '迫切', '切実', 'Désespéré', 'Desesperado', 'Verzweifelt', 'สิ้นหวัง', 'Tuyệt vọng', 'निराश'],
      'expectant': ['기대', 'Expectant', '期待', 'Dans l\'attente', 'Expectante', 'Erwartungsvoll', 'คาดหวัง', 'Mong đợi', 'प्रत्याशी'],
      'mystical': ['신비', 'Mystical', '神秘的な', '신비로운', '神秘', 'Mystique', 'Místico', 'Mystisch', 'ลึกลับ', 'Huyền bí', 'रहस्यमय'],
    };
    
    // 저장된 텍스트를 소문자로 변환하여 비교 (대소문자 무시)
    final savedMoodLower = savedMood.toLowerCase();
    
    // 저장된 텍스트가 어떤 mood 타입인지 찾기
    String? moodKey;
    for (final entry in moodMappings.entries) {
      if (entry.value.any((translation) => translation.toLowerCase() == savedMoodLower)) {
        moodKey = entry.key;
        break;
      }
    }
    
    if (moodKey == null) {
      // 매핑을 찾을 수 없으면 원본 반환
      debugPrint('Warning: No mood mapping found for "$savedMood". Please add this to moodMappings.');
      return savedMood;
    }
    
    // mood 키에 해당하는 현재 언어의 텍스트 반환
    switch (moodKey) {
      case 'anxious':
        return l10n.moodAnxious;
      case 'lonely':
        return l10n.moodLonely;
      case 'curious':
        return l10n.moodCurious;
      case 'fearful':
        return l10n.moodFearful;
      case 'hopeful':
        return l10n.moodHopeful;
      case 'confused':
        return l10n.moodConfused;
      case 'desperate':
        return l10n.moodDesperate;
      case 'expectant':
        return l10n.moodExpectant;
      case 'mystical':
        return l10n.moodMystical;
      default:
        return savedMood;
    }
  }
}