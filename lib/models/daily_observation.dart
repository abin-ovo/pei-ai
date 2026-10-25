class DailyObservation {
  DailyObservation({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    this.insightType = InsightType.observation,
  });

  final String id;
  final DateTime date;
  final String title;
  final String content;
  final InsightType insightType;
}

enum InsightType { observation, suggestion, preliminary }
