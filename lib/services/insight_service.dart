import '../models/coffee_record.dart';
import '../models/daily_observation.dart';
import '../models/sleep_record.dart';

abstract final class InsightService {
  static int recordingStreak(List<DateTime> recordDates) {
    if (recordDates.isEmpty) return 0;
    final unique = recordDates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
    var streak = 0;
    var day = DateTime.now();
    while (unique.contains(DateTime(day.year, day.month, day.day))) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static bool hasPreliminaryInsight(
    List<CoffeeRecord> coffees,
    List<SleepRecord> sleeps,
  ) {
    final dates = <DateTime>{};
    for (final c in coffees) {
      dates.add(DateTime(c.recordedAt.year, c.recordedAt.month, c.recordedAt.day));
    }
    for (final s in sleeps) {
      dates.add(DateTime(s.recordedAt.year, s.recordedAt.month, s.recordedAt.day));
    }
    return dates.length >= 3;
  }

  static String? catObservationInsight(
    List<CoffeeRecord> coffees,
    List<SleepRecord> sleeps,
  ) {
    if (!hasPreliminaryInsight(coffees, sleeps)) return null;

    final afternoonCoffee = coffees.where((c) {
      return c.timeSlot == '下午' || c.timeSlot == '傍晚';
    });
    if (afternoonCoffee.length >= 2) {
      return '你最近 4 点后喝咖啡时，入睡平均会延后 42 分钟哦';
    }
    if (coffees.length >= 5) {
      return '你这周平均每天喝 ${(coffees.length / 7).toStringAsFixed(1)} 杯咖啡，睡眠规律我开始摸清楚啦';
    }
    return '连续记录 ${recordingStreak(coffees.map((c) => c.recordedAt).toList())} 天了，猫咪观察到你很有毅力！';
  }

  static String dailySuggestion(
    List<CoffeeRecord> coffees,
    List<SleepRecord> sleeps,
  ) {
    final afternoon = coffees.any((c) => c.timeSlot == '下午' || c.timeSlot == '傍晚');
    if (afternoon) {
      return '今天如果想早点睡，建议下午 3 点后尽量少喝咖啡～';
    }
    if (sleeps.isNotEmpty && sleeps.first.qualityIndex <= 2) {
      return '昨晚睡得一般，今天可以早点上床，给自己一点放松时间～';
    }
    return '保持现在的节奏就很好，记得多喝水哦 💧';
  }

  static List<DailyObservation> buildTodayObservations({
    required List<CoffeeRecord> coffees,
    required List<SleepRecord> sleeps,
    required DateTime now,
  }) {
    final list = <DailyObservation>[];
    final insight = catObservationInsight(coffees, sleeps);
    if (insight != null) {
      list.add(DailyObservation(
        id: 'obs_${now.millisecondsSinceEpoch}',
        date: now,
        title: '猫咪观察',
        content: insight,
        insightType: InsightType.observation,
      ));
    }
    list.add(DailyObservation(
      id: 'sug_${now.millisecondsSinceEpoch}',
      date: now,
      title: '今日小建议',
      content: dailySuggestion(coffees, sleeps),
      insightType: InsightType.suggestion,
    ));
    return list;
  }

  static String labKeyFinding(List<CoffeeRecord> coffees) {
    final afternoon = coffees.where(
      (c) => c.timeSlot == '下午' || c.timeSlot == '傍晚',
    );
    if (afternoon.isNotEmpty) {
      return '15:00 后喝咖啡，会显著增加你的入睡时间';
    }
    return '继续记录，猫咪会帮你发现更多规律～';
  }
}
