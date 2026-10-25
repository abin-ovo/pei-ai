import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/character_illustration.dart';
import '../../core/widgets/mew_card.dart';
import '../../core/widgets/speech_bubble.dart';
import '../../providers/app_state.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final coffeeCount = state.coffeeRecords.length.clamp(0, 14);
    final avgCoffee = coffeeCount > 0 ? (coffeeCount / 7).toStringAsFixed(1) : '0';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('周报报告'),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          MewCard(
            color: AppColors.primaryPale,
            child: Column(
              children: [
                const Text(
                  '5.20 - 5.26',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                const CharacterIllustration(
                  variant: CharacterVariant.report,
                  height: 100,
                ),
                const SizedBox(height: 8),
                const SpeechBubble(
                  text: '喵～这周你很努力呢！一起来看看 ❤️',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _StatCard(
                emoji: '☕',
                value: '$coffeeCount 杯',
                label: '咖啡记录',
                sub: '日均 $avgCoffee 杯',
              ),
              const _StatCard(
                emoji: '⏱',
                value: '36 分钟',
                label: '平均入睡',
                sub: '较上周 +8 分钟',
              ),
              const _StatCard(
                emoji: '🌙',
                value: '78 分',
                label: '睡眠质量',
                sub: '整体不错',
              ),
              _StatCard(
                emoji: '📅',
                value: '${state.recordingStreak.clamp(1, 7)} 天',
                label: '记录天数',
                sub: '连续打卡',
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '本周关键发现',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          MewCard(
            child: Column(
              children: [
                _finding('☕', '本周共记录 $coffeeCount 杯咖啡'),
                _finding('😴', '平均入睡时间 36 分钟'),
                _finding('📈', state.hasPreliminaryInsight
                    ? '发现：下午喝咖啡与入睡延后有关'
                    : '再记录几天，猫咪会发现更多规律'),
                _finding('🔥', '连续记录 ${state.recordingStreak} 天'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildMiniChart('入睡趋势', AppColors.purple),
          const SizedBox(height: 12),
          _buildMiniChart('睡眠质量', AppColors.primary),
          const SizedBox(height: 12),
          _buildBarChart('咖啡摄入'),
          const SizedBox(height: 20),
          MewCard(
            color: AppColors.backgroundCream,
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.dailySuggestion,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _finding(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildMiniChart(String title, Color color) {
    return MewCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 2.5),
                      FlSpot(2, 4),
                      FlSpot(3, 3.5),
                      FlSpot(4, 3),
                      FlSpot(5, 4.2),
                      FlSpot(6, 3.8),
                    ],
                    isCurved: true,
                    color: color,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(String title) {
    return MewCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: BarChart(
              BarChartData(
                maxY: 4,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(show: false),
                barGroups: List.generate(7, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: (i % 3 + 1).toDouble(),
                        color: AppColors.primary,
                        width: 14,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.sub,
  });

  final String emoji;
  final String value;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return MewCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(fontSize: 10, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
