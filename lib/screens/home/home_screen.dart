import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/character_illustration.dart';
import '../../core/widgets/mew_card.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/speech_bubble.dart';
import '../../models/daily_observation.dart';
import '../../providers/app_state.dart';
import '../coffee/coffee_log_screen.dart';
import '../sleep/sleep_log_screen.dart';
import '../memory/memory_dialog.dart';
import 'widgets/quick_log_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AppState>();
      if (state.pendingMemoryCandidate != null) {
        showMemoryConfirmDialog(context, state);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context, state)),
            SliverToBoxAdapter(child: _buildHeroCard(state)),
            SliverToBoxAdapter(child: _buildStatusBar(state)),
            SliverToBoxAdapter(child: _buildQuickLog(context, state)),
            if (state.catObservation != null)
              SliverToBoxAdapter(child: _buildInsightCard(state)),
            SliverToBoxAdapter(child: _buildSuggestionCard(state)),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.timeGreeting,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.subGreeting,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _HeaderAction(
            icon: Icons.calendar_today_outlined,
            label: '打卡',
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _HeaderAction(
            icon: Icons.notifications_outlined,
            label: '提醒',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(AppState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MewCard(
        padding: const EdgeInsets.all(20),
        color: AppColors.white,
        child: Column(
          children: [
            const CharacterIllustration(
              variant: CharacterVariant.home,
              height: 140,
            ),
            const SizedBox(height: 12),
            SpeechBubble(text: state.catGreeting),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(AppState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MewCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        radius: 16,
        child: Row(
          children: [
            const Text('今日状态', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                state.todayStatus,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _showMoodPicker(context, state),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text('记录心情', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLog(BuildContext context, AppState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: '快速记录',
            subtitle: '随手记一下，猫咪会帮你分析哦～',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: QuickLogCard(
                  emoji: '☕',
                  title: '记咖啡',
                  subtitle: state.todayCoffeeCount > 0
                      ? '已记录 ${state.todayCoffeeCount} 杯'
                      : '今天喝了几杯？',
                  color: const Color(0xFFFFF3E0),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CoffeeLogScreen(),
                      ),
                    );
                    if (context.mounted) {
                      final s = context.read<AppState>();
                      if (s.pendingMemoryCandidate != null) {
                        showMemoryConfirmDialog(context, s);
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickLogCard(
                  emoji: '😴',
                  title: '记睡眠',
                  subtitle: state.sleepRecords.isEmpty
                      ? '昨晚睡得怎么样？'
                      : '已记录睡眠',
                  color: const Color(0xFFEDE7F6),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SleepLogScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(AppState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: MewCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.primaryPale,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Row(
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
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.catObservation!,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.bar_chart, size: 16),
                    label: const Text('查看详情'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primaryLight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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

  Widget _buildSuggestionCard(AppState state) {
    final obs = state.todayObservations
        .where((o) => o.insightType == InsightType.suggestion)
        .toList();
    final text = obs.isNotEmpty ? obs.first.content : state.dailySuggestion;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MewCard(
        color: AppColors.backgroundCream,
        child: Row(
          children: [
            const Text('💡', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '今日小建议',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
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

  void _showMoodPicker(BuildContext context, AppState state) {
    final moods = ['很开心 ✨', '还不错 🙂', '有点累 💪', '有点烦 😮‍💨', '需要抱抱 🫂'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '今天心情如何？',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ...moods.map(
              (m) => ListTile(
                title: Text(m),
                onTap: () {
                  state.setTodayMood(m);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Color(0x0A000000), blurRadius: 8),
              ],
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
