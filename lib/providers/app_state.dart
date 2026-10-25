import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/coffee_record.dart';
import '../models/daily_observation.dart';
import '../models/memory_item.dart';
import '../models/sleep_record.dart';
import '../services/greeting_service.dart';
import '../services/insight_service.dart';
import '../services/memory_service.dart';

class AppState extends ChangeNotifier {
  AppState() {
    _init();
  }

  final List<CoffeeRecord> coffeeRecords = [];
  final List<SleepRecord> sleepRecords = [];
  final List<MemoryItem> memories = [];
  final List<DailyObservation> todayObservations = [];

  String? _lastInstantReply;
  MemoryCandidate? _pendingMemoryCandidate;
  String _todayMood = '有点累，但还可以 💪';
  bool _loaded = false;

  int get navIndex => _navIndex;
  int _navIndex = 0;

  String? get lastInstantReply => _lastInstantReply;
  MemoryCandidate? get pendingMemoryCandidate => _pendingMemoryCandidate;
  String get todayMood => _todayMood;
  bool get loaded => _loaded;

  int get todayCoffeeCount {
    final now = DateTime.now();
    return coffeeRecords
        .where(
          (r) =>
              r.recordedAt.year == now.year &&
              r.recordedAt.month == now.month &&
              r.recordedAt.day == now.day,
        )
        .length;
  }

  int get todayCaffeineMg {
    final now = DateTime.now();
    return coffeeRecords
        .where(
          (r) =>
              r.recordedAt.year == now.year &&
              r.recordedAt.month == now.month &&
              r.recordedAt.day == now.day,
        )
        .fold(0, (sum, r) => sum + r.caffeineMg);
  }

  int get recordingStreak {
    final dates = [
      ...coffeeRecords.map((r) => r.recordedAt),
      ...sleepRecords.map((r) => r.recordedAt),
    ];
    return InsightService.recordingStreak(dates);
  }

  bool get hasPreliminaryInsight =>
      InsightService.hasPreliminaryInsight(coffeeRecords, sleepRecords);

  String get catGreeting => GreetingService.catGreeting(
        now: DateTime.now(),
        sleepRecords: sleepRecords,
        coffeeRecords: coffeeRecords,
        lastInstantReply: _lastInstantReply,
      );

  String get timeGreeting => GreetingService.timeGreeting(DateTime.now());
  String get subGreeting => GreetingService.subGreeting(DateTime.now());
  String get todayStatus =>
      GreetingService.todayStatus(coffeeRecords, sleepRecords);

  String? get catObservation =>
      InsightService.catObservationInsight(coffeeRecords, sleepRecords);

  String get dailySuggestion =>
      InsightService.dailySuggestion(coffeeRecords, sleepRecords);

  Future<void> _init() async {
    memories.addAll(MemoryService.defaultMemories());
    await _loadFromPrefs();
    _seedDemoDataIfEmpty();
    _refreshObservations();
    _loaded = true;
    notifyListeners();
  }

  void _seedDemoDataIfEmpty() {
    if (coffeeRecords.isNotEmpty) return;
    final now = DateTime.now();
    coffeeRecords.add(
      CoffeeRecord(
        id: 'demo_c1',
        recordedAt: now.subtract(const Duration(hours: 2)),
        timeSlot: '下午',
        coffeeType: '美式',
        size: '中杯',
        options: ['饭后'],
        caffeineMg: 80,
      ),
    );
    sleepRecords.add(
      SleepRecord(
        id: 'demo_s1',
        recordedAt: now.subtract(const Duration(days: 1)),
        bedtime: '01:23',
        latency: '15-30分钟',
        qualityIndex: 3,
        wakeCount: '1次',
        wakeFeelingIndex: 3,
      ),
    );
  }

  void setNavIndex(int index) {
    _navIndex = index;
    notifyListeners();
  }

  void clearInstantReply() {
    _lastInstantReply = null;
    notifyListeners();
  }

  Future<void> addCoffeeRecord(CoffeeRecord record) async {
    coffeeRecords.insert(0, record);
    _lastInstantReply = GreetingService.coffeeInstantReply(record);
    _refreshObservations();
    _checkMemoryCandidate();
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> addSleepRecord(SleepRecord record) async {
    sleepRecords.insert(0, record);
    _lastInstantReply = GreetingService.sleepInstantReply(record);
    _refreshObservations();
    await _saveToPrefs();
    notifyListeners();
  }

  void _refreshObservations() {
    todayObservations
      ..clear()
      ..addAll(
        InsightService.buildTodayObservations(
          coffees: coffeeRecords,
          sleeps: sleepRecords,
          now: DateTime.now(),
        ),
      );
  }

  void _checkMemoryCandidate() {
    if (_pendingMemoryCandidate != null) return;
    _pendingMemoryCandidate = MemoryService.detectCandidate(coffeeRecords);
  }

  Future<void> confirmMemoryCandidate() async {
    final c = _pendingMemoryCandidate;
    if (c == null) return;
    memories.insert(
      0,
      MemoryItem(
        id: c.id,
        category: c.category,
        title: c.title,
        points: [c.description.replaceAll('要我记住', '已记住')],
        createdAt: c.detectedAt,
      ),
    );
    _pendingMemoryCandidate = null;
    _lastInstantReply = '好哒，我会好好记住的！以后会更懂你的～ ❤️';
    await _saveToPrefs();
    notifyListeners();
  }

  void dismissMemoryCandidate() {
    _pendingMemoryCandidate = null;
    notifyListeners();
  }

  void setTodayMood(String mood) {
    _todayMood = mood;
    notifyListeners();
  }

  List<MemoryItem> memoriesByCategory(MemoryCategory cat) {
    if (cat == MemoryCategory.all) return memories;
    return memories.where((m) => m.category == cat).toList();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'coffees',
      jsonEncode(coffeeRecords.map((r) => r.toJson()).toList()),
    );
    await prefs.setString(
      'sleeps',
      jsonEncode(sleepRecords.map((r) => r.toJson()).toList()),
    );
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final coffees = prefs.getString('coffees');
    final sleeps = prefs.getString('sleeps');
    if (coffees != null) {
      final list = jsonDecode(coffees) as List<dynamic>;
      coffeeRecords.addAll(
        list.map((e) => CoffeeRecord.fromJson(e as Map<String, dynamic>)),
      );
    }
    if (sleeps != null) {
      final list = jsonDecode(sleeps) as List<dynamic>;
      sleepRecords.addAll(
        list.map((e) => SleepRecord.fromJson(e as Map<String, dynamic>)),
      );
    }
  }
}
