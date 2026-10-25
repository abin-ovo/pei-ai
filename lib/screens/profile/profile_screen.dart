import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/mew_card.dart';
import '../../providers/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                const Text(
                  '我的',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: _buildProfileHeader()),
        SliverToBoxAdapter(child: _buildStatsRow(state)),
        SliverToBoxAdapter(child: _buildMembershipCard()),
        SliverToBoxAdapter(child: _buildToolsGrid()),
        SliverToBoxAdapter(child: _buildAchievements()),
        SliverToBoxAdapter(child: _buildSupportMenu()),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryLight, AppColors.primary],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(color: Color(0x1A000000), blurRadius: 12),
              ],
            ),
            child: const Center(
              child: Text('🐱', style: TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '喵喵少女',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Lv.18 · 相伴 68 天',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AppState state) {
    final stats = [
      ('实验天数', '28'),
      ('记录天数', '${state.recordingStreak + 150}'),
      ('喵记忆', '${state.memories.length + 38}'),
      ('徽章', '12'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: Column(
              children: [
                Text(
                  s.$2,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.$1,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMembershipCard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2D2D2D), Color(0xFF4A4A4A)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '喵会员',
              style: TextStyle(
                color: Color(0xFFFFD98A),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '有效期至 2026.12.31',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFFD98A),
                side: const BorderSide(color: Color(0xFFFFD98A)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('查看权益'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolsGrid() {
    const tools = [
      ('📅', '数据日历'),
      ('🔔', '提醒'),
      ('📤', '导出数据'),
      ('📱', '小组件'),
      ('🎨', '主题'),
      ('🏅', '徽章'),
      ('👗', '猫咪装扮'),
      ('🧪', '实验记录'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的工具',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: tools.length,
            itemBuilder: (_, i) {
              return MewCard(
                padding: const EdgeInsets.all(8),
                radius: 12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tools[i].$1, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      tools[i].$2,
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    const badges = ['早起鸟', '咖啡达人', '睡眠卫士', '记录之星', '喵友'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的成就',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: badges.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryPale,
                            AppColors.lavender,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          ['🌅', '☕', '🌙', '⭐', '💕'][i],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badges[i],
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportMenu() {
    const items = ['帮助与反馈', '使用指南', '关于喵喵'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MewCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: items.map((item) {
            return ListTile(
              title: Text(item, style: const TextStyle(fontSize: 15)),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textHint,
                size: 20,
              ),
              onTap: () {},
            );
          }).toList(),
        ),
      ),
    );
  }
}
