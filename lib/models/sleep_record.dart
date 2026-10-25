class SleepRecord {
  SleepRecord({
    required this.id,
    required this.recordedAt,
    required this.bedtime,
    required this.latency,
    required this.qualityIndex,
    required this.wakeCount,
    required this.wakeFeelingIndex,
    this.notes,
  });

  final String id;
  final DateTime recordedAt;
  final String bedtime;
  final String latency;
  final int qualityIndex;
  final String wakeCount;
  final int wakeFeelingIndex;
  final String? notes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'recordedAt': recordedAt.toIso8601String(),
        'bedtime': bedtime,
        'latency': latency,
        'qualityIndex': qualityIndex,
        'wakeCount': wakeCount,
        'wakeFeelingIndex': wakeFeelingIndex,
        'notes': notes,
      };

  factory SleepRecord.fromJson(Map<String, dynamic> json) => SleepRecord(
        id: json['id'] as String,
        recordedAt: DateTime.parse(json['recordedAt'] as String),
        bedtime: json['bedtime'] as String,
        latency: json['latency'] as String,
        qualityIndex: json['qualityIndex'] as int,
        wakeCount: json['wakeCount'] as String,
        wakeFeelingIndex: json['wakeFeelingIndex'] as int,
        notes: json['notes'] as String?,
      );
}
