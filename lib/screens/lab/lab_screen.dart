import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/character_illustration.dart';
import '../../core/widgets/mew_card.dart';
import '../../providers/app_state.dart';
import '../../services/insight_service.dart';
import '../weekly/weekly_report_screen.dart';

class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: [
                const Text('🧪', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                const Text(
                  '实验室',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.assessment_outlined),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WeeklyReportScreen(),
                    ),
                  ),
                  tooltip: '周报',
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: _buildFeaturedExperiment(state)),
        SliverToBoxAdapter(child: _buildExperimentGrid()),
        SliverToBoxAdapter(child: _buildChartSection(state)),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildFeaturedExperiment(AppState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MewCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '咖啡与睡眠观察',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              state.hasPreliminaryInsight
                  ? '已有初步观察，继续记录可获得更精准洞察'
                  : '再记录 ${3 - state.recordingStreak.clamp(0, 3)} 天即可生成初步观察',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const CharacterIllustration(
              variant: CharacterVariant.lab,
              height: 100,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                ),
                child: const Text('继续记录'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperimentGrid() {
    final items = [
      ('咖啡 & 睡眠', Icons.coffee, AppColors.orange),
      ('熬夜 & 情绪', Icons.nightlight, AppColors.purple),
      ('午睡 & 夜间', Icons.bedtime, AppColors.blue),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的实验',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: items.map((item) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: item == items.last ? 0 : 8,
                  ),
                  child: MewCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(item.$2, color: item.$3, size: 20),
                        const SizedBox(height: 8),
                        Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 32,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: const [
                                    FlSpot(0, 2),
                                    FlSpot(1, 3),
                                    FlSpot(2, 2.5),
                                    FlSpot(3, 4),
                                  ],
                                  isCurved: true,
                                  color: item.$3,
                                  barWidth: 2,
                                  dotData: const FlDotData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(AppState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MewCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: _tabCtrl,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textHint,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: '趋势'),
                Tab(text: '关联分析'),
                Tab(text: '数据记录'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _buildMainChart(),
                  _buildMainChart(),
                  _buildDataTable(state),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryPale,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('🐱', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 6),
                      Text(
                        '猫咪观察',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    InsightService.labKeyFinding(state.coffeeRecords),
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 5,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) => Text(
                '${v.toInt() + 1}',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: List.generate(7, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: (i % 3 + 1).toDouble(),
                color: AppColors.primary.withValues(alpha: 0.7),
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: (i % 2 + 2).toDouble(),
                color: AppColors.purple.withValues(alpha: 0.6),
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDataTable(AppState state) {
    final rows = state.coffeeRecords.take(5).toList();
    if (rows.isEmpty) {
      return const Center(child: Text('暂无数据，快去记录吧～'));
    }
    return ListView.separated(
      itemCount: rows.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final r = rows[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '${r.recordedAt.month}/${r.recordedAt.day}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(r.coffeeType, style: const TextStyle(fontSize: 12)),
              ),
              Expanded(
                flex: 2,
                child: Text(r.size, style: const TextStyle(fontSize: 12)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('已记录', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        );
      },
    );
  }
}
