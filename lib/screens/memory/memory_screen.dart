import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/character_illustration.dart';
import '../../core/widgets/mew_card.dart';
import '../../core/widgets/speech_bubble.dart';
import '../../models/memory_item.dart';
import '../../providers/app_state.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  MemoryCategory _filter = MemoryCategory.all;

  static const _filters = [
    (MemoryCategory.all, '全部'),
    (MemoryCategory.preference, '偏好'),
    (MemoryCategory.habit, '习惯'),
    (MemoryCategory.status, '状态'),
    (MemoryCategory.event, '事件'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = state.memoriesByCategory(_filter);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: [
                const Text('💕', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                const Text(
                  '记忆中心',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 22),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.tune, size: 22),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: MewCard(
              child: Column(
                children: [
                  const CharacterIllustration(
                    variant: CharacterVariant.memory,
                    height: 120,
                  ),
                  const SizedBox(height: 12),
                  const SpeechBubble(
                    text: '我会好好记住的，因为你对我来说很重要～ ❤️',
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final (cat, label) = _filters[i];
                final selected = _filter == cat;
                return GestureDetector(
                  onTap: () => setState(() => _filter = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected
                            ? AppColors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  index == 0 ? 16 : 0,
                  20,
                  12,
                ),
                child: _MemoryCard(item: item),
              );
            },
            childCount: items.length,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: AppColors.primary),
              label: const Text(
                '添加重要事件',
                style: TextStyle(color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppColors.primaryLight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.item});
  final MemoryItem item;

  @override
  Widget build(BuildContext context) {
    return MewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...item.points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: AppColors.primary)),
                  Expanded(
                    child: Text(
                      p,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
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
}
