import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';
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
  }

  void _loadStatistics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statisticsViewModelProvider.notifier).loadStatistics();
      _animationController.forward();
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
                  '통계 & 분석',
                  style: AppTextStyles.displaySmall.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  '당신의 운명 패턴을 분석합니다',
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

  Widget _buildContent(StatisticsState state) {
    if (state.isLoading) {
      return const Center(
        child: CustomLoadingIndicator(
          size: 60,
          color: AppColors.evilGlow,
          message: '운명을 분석하는 중...',
        ),
      );
    }

    if (state.statistics == null) {
      return _buildEmptyState();
    }

    return _buildStatisticsList(state);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics,
            size: 80,
            color: AppColors.fogGray.withAlpha(100),
          ),
          const SizedBox(height: 24),
          Text(
            '아직 분석할 데이터가 없습니다',
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 20,
              color: AppColors.fogGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '타로 리딩을 시작해보세요',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.ashGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsList(StatisticsState state) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildAnimatedStatCard(
          index: 0,
          title: '총 타로 리딩',
          value: '${state.statistics!['totalReadings'] ?? 0}회',
          icon: Icons.style,
          gradient: [AppColors.mysticPurple, AppColors.deepViolet],
        ),
        const SizedBox(height: 16),
        if (state.statistics!['mostFrequentCard'] != null) ...[
          _buildAnimatedStatCard(
            index: 1,
            title: '가장 많이 나온 카드',
            value: state.statistics!['mostFrequentCard'] ?? '',
            icon: Icons.star,
            gradient: [AppColors.omenGlow, AppColors.crimsonGlow],
          ),
          const SizedBox(height: 24),
        ],
        if ((state.statistics!['cardFrequency'] as Map).isNotEmpty) ...[
          _buildAnimatedChart(
            index: 2,
            title: '카드 출현 빈도',
            child: _buildCardFrequencyChart(
              state.statistics!['cardFrequency'] as Map<String, int>,
            ),
          ),
          const SizedBox(height: 24),
        ],
        if ((state.statistics!['moodFrequency'] as Map).isNotEmpty) ...[
          _buildAnimatedChart(
            index: 3,
            title: '기분별 리딩 횟수',
            child: _buildMoodPieChart(
              state.statistics!['moodFrequency'] as Map<String, int>,
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (state.monthlyTrend.isNotEmpty) ...[
          _buildAnimatedChart(
            index: 4,
            title: '월별 리딩 추이',
            child: _buildMonthlyTrendChart(state.monthlyTrend),
          ),
        ],
      ],
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
  }) {
    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _animations[index].value,
          child: Opacity(
            opacity: _animations[index].value,
            child: GlassMorphismContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.displaySmall.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(height: 200, child: child!),
                ],
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return GlassMorphismContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.ghostWhite, size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.fogGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.displaySmall.copyWith(fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFrequencyChart(Map<String, int> frequency) {
    final sortedEntries = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topEntries = sortedEntries.take(5).toList();
    
    if (topEntries.isEmpty) return const SizedBox();
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: topEntries.first.value.toDouble() + 2,
        barTouchData: _buildBarTouchData(topEntries),
        titlesData: _buildTitlesData(topEntries),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(topEntries),
      ),
    );
  }

  BarTouchData _buildBarTouchData(List<MapEntry<String, int>> entries) {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: AppColors.shadowGray,
        tooltipBorder: const BorderSide(
          color: AppColors.cardBorder,
          width: 1,
        ),
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            '${entries[group.x.toInt()].key}\n${rod.toY.toInt()}회',
            AppTextStyles.bodySmall,
          );
        },
      ),
    );
  }

  FlTitlesData _buildTitlesData(List<MapEntry<String, int>> entries) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value.toInt() >= entries.length) return const SizedBox();
            final cardName = entries[value.toInt()].key;
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                cardName.length > 8 ? '${cardName.substring(0, 8)}...' : cardName,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.fogGray,
                ),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 10,
                color: AppColors.fogGray,
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<MapEntry<String, int>> entries) {
    return entries.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value.toDouble(),
            gradient: const LinearGradient(
              colors: [AppColors.mysticPurple, AppColors.deepViolet],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildMoodPieChart(Map<String, int> moodFrequency) {
    final total = moodFrequency.values.fold(0, (sum, value) => sum + value);
    if (total == 0) return const SizedBox();
    
    final colors = [
      AppColors.mysticPurple,
      AppColors.evilGlow,
      AppColors.spiritGlow,
      AppColors.omenGlow,
      AppColors.crimsonGlow,
    ];
    
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: _buildPieSections(moodFrequency, total, colors),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(
    Map<String, int> moodFrequency,
    int total,
    List<Color> colors,
  ) {
    return moodFrequency.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final mood = entry.value.key;
      final count = entry.value.value;
      final percentage = (count / total * 100).toStringAsFixed(1);
      
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: count.toDouble(),
        title: '$percentage%',
        radius: 80,
        titleStyle: AppTextStyles.bodySmall.copyWith(
          fontSize: 12,
          color: AppColors.ghostWhite,
          fontWeight: FontWeight.bold,
        ),
        badgeWidget: _buildMoodBadge(mood),
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }

  Widget _buildMoodBadge(String mood) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.shadowGray,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        mood,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 10,
          color: AppColors.ghostWhite,
        ),
      ),
    );
  }

  Widget _buildMonthlyTrendChart(Map<String, int> monthlyTrend) {
    final sortedEntries = monthlyTrend.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    if (sortedEntries.isEmpty) return const SizedBox();
    
    final maxY = sortedEntries
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b)
        .toDouble() + 2;
    
    return LineChart(
      LineChartData(
        gridData: _buildGridData(),
        titlesData: _buildLineTitlesData(sortedEntries),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.whiteOverlay10),
        ),
        minX: 0,
        maxX: sortedEntries.length.toDouble() - 1,
        minY: 0,
        maxY: maxY,
        lineBarsData: [_buildLineChartBarData(sortedEntries)],
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: AppColors.whiteOverlay10,
          strokeWidth: 1,
        );
      },
    );
  }

  FlTitlesData _buildLineTitlesData(List<MapEntry<String, int>> entries) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            if (value.toInt() >= entries.length) return const SizedBox();
            final month = entries[value.toInt()].key.split('-')[1];
            return Text(
              '${int.parse(month)}월',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 10,
                color: AppColors.fogGray,
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 10,
                color: AppColors.fogGray,
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  LineChartBarData _buildLineChartBarData(List<MapEntry<String, int>> entries) {
    return LineChartBarData(
      spots: entries.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
      }).toList(),
      isCurved: true,
      gradient: const LinearGradient(
        colors: [AppColors.mysticPurple, AppColors.evilGlow],
      ),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: AppColors.evilGlow,
            strokeWidth: 2,
            strokeColor: AppColors.ghostWhite,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            AppColors.mysticPurple.withAlpha(50),
            AppColors.evilGlow.withAlpha(10),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}