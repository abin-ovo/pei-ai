import '../models/coffee_record.dart';
import '../models/sleep_record.dart';

abstract final class GreetingService {
  static String timeGreeting(DateTime now) {
    final hour = now.hour;
    if (hour < 6) return '夜深了 🌙';
    if (hour < 11) return '早安呀 🌸';
    if (hour < 14) return '午安呀 ☀️';
    if (hour < 18) return '下午好呀 🌤';
    return '晚上好呀 🌆';
  }

  static String subGreeting(DateTime now) {
    final hour = now.hour;
    if (hour < 11) return '今天也要好好照顾自己哦～';
    if (hour < 18) return '记得多喝水，适当休息～';
    return '今天辛苦啦，早点休息哦～';
  }

  static String catGreeting({
    required DateTime now,
    List<SleepRecord>? sleepRecords,
    List<CoffeeRecord>? coffeeRecords,
    String? lastInstantReply,
  }) {
    if (lastInstantReply != null) return lastInstantReply;

    if (sleepRecords != null && sleepRecords.isNotEmpty) {
      final latest = sleepRecords.first;
      return '我记得你昨晚 ${latest.bedtime} 才睡着呢，今天要早点休息呀 ❤️';
    }

    final hour = now.hour;
    if (hour < 11) {
      return '喵～新的一天开始了！今天想记录点什么吗？';
    }
    if (coffeeRecords != null && coffeeRecords.isNotEmpty) {
      final today = coffeeRecords.where(
        (r) =>
            r.recordedAt.year == now.year &&
            r.recordedAt.month == now.month &&
            r.recordedAt.day == now.day,
      );
      if (today.isNotEmpty) {
        return '今天已经喝了 ${today.length} 杯咖啡啦，记得适量哦～';
      }
    }
    return '喵～我一直在呢，有什么想和我分享的吗？';
  }

  static String coffeeInstantReply(CoffeeRecord record) {
    if (record.timeSlot == '下午' || record.timeSlot == '傍晚') {
      return '喵～下午喝咖啡要注意哦，可能会影响今晚的睡眠呢 💤';
    }
    if (record.options.contains('空腹')) {
      return '空腹喝咖啡对胃不太好哦，下次试试饭后喝吧～';
    }
    return '记录好啦！${record.coffeeType} ${record.size}，我会帮你留着的 ☕';
  }

  static String sleepInstantReply(SleepRecord record) {
    if (record.qualityIndex <= 1) {
      return '昨晚睡得不太好呀，今天记得多休息，我会陪着你的 🌙';
    }
    if (record.latency == '30-60分钟' || record.latency == '>60分钟') {
      return '入睡花了挺久的呢，今晚试试早点放下手机吧～';
    }
    return '睡眠记录保存好啦！你的休息对我很重要哦 💤';
  }

  static String todayStatus(List<CoffeeRecord> coffees, List<SleepRecord> sleeps) {
    final todayCoffees = coffees.length;
    if (todayCoffees >= 3) return '咖啡因有点多，注意休息 ☕';
    if (sleeps.isNotEmpty && sleeps.first.qualityIndex <= 2) {
      return '有点累，但还可以 💪';
    }
    return '状态不错，继续保持 ✨';
  }
}
