import '../models/coffee_record.dart';
import '../models/memory_item.dart' show MemoryCandidate, MemoryCategory, MemoryItem;

abstract final class MemoryService {
  static List<MemoryItem> defaultMemories() => [
        MemoryItem(
          id: 'm1',
          category: MemoryCategory.preference,
          title: '我的偏好',
          points: [
            '喜欢喝拿铁，不太喜欢太苦的咖啡',
            '偏爱粉色、奶油色系的温柔风格',
            '喜欢猫咪陪伴的感觉',
          ],
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        MemoryItem(
          id: 'm2',
          category: MemoryCategory.habit,
          title: '我的习惯',
          points: [
            '通常上午 10:00 左右喝咖啡',
            '周末倾向于晚睡晚起',
            '压力大时容易熬夜',
          ],
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        MemoryItem(
          id: 'm3',
          category: MemoryCategory.status,
          title: '我的状态',
          points: [
            '下午容易感到疲惫',
            '压力大时容易熬夜',
            '睡眠质量与咖啡摄入有关',
          ],
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        MemoryItem(
          id: 'm4',
          category: MemoryCategory.event,
          title: '重要事件',
          points: [
            '我们相遇的日子：2024.01.15',
            '连续记录 30 天成就达成！',
          ],
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

  static MemoryCandidate? detectCandidate(List<CoffeeRecord> coffees) {
    if (coffees.length < 3) return null;

    final typeCount = <String, int>{};
    for (final c in coffees) {
      typeCount[c.coffeeType] = (typeCount[c.coffeeType] ?? 0) + 1;
    }
    final top = typeCount.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );
    if (top.value >= 3) {
      return MemoryCandidate(
        id: 'cand_${DateTime.now().millisecondsSinceEpoch}',
        category: MemoryCategory.preference,
        title: '咖啡偏好',
        description: '你好像很喜欢喝「${top.key}」，要我记住这个偏好吗？',
        detectedAt: DateTime.now(),
      );
    }

    final afternoon = coffees.where(
      (c) => c.timeSlot == '下午',
    );
    if (afternoon.length >= 3) {
      return MemoryCandidate(
        id: 'cand_${DateTime.now().millisecondsSinceEpoch}',
        category: MemoryCategory.habit,
        title: '喝咖啡时间',
        description: '你经常在下午喝咖啡，要我记住这个习惯吗？',
        detectedAt: DateTime.now(),
      );
    }
    return null;
  }
}
