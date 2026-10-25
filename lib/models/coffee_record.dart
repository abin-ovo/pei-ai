class CoffeeRecord {
  CoffeeRecord({
    required this.id,
    required this.recordedAt,
    required this.timeSlot,
    required this.coffeeType,
    required this.size,
    this.options = const [],
    this.feeling,
    this.caffeineMg = 80,
  });

  final String id;
  final DateTime recordedAt;
  final String timeSlot;
  final String coffeeType;
  final String size;
  final List<String> options;
  final String? feeling;
  final int caffeineMg;

  Map<String, dynamic> toJson() => {
        'id': id,
        'recordedAt': recordedAt.toIso8601String(),
        'timeSlot': timeSlot,
        'coffeeType': coffeeType,
        'size': size,
        'options': options,
        'feeling': feeling,
        'caffeineMg': caffeineMg,
      };

  factory CoffeeRecord.fromJson(Map<String, dynamic> json) => CoffeeRecord(
        id: json['id'] as String,
        recordedAt: DateTime.parse(json['recordedAt'] as String),
        timeSlot: json['timeSlot'] as String,
        coffeeType: json['coffeeType'] as String,
        size: json['size'] as String,
        options: (json['options'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        feeling: json['feeling'] as String?,
        caffeineMg: json['caffeineMg'] as int? ?? 80,
      );
}
