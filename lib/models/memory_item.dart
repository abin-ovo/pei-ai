enum MemoryCategory { all, preference, habit, status, event }

class MemoryItem {
  MemoryItem({
    required this.id,
    required this.category,
    required this.title,
    required this.points,
    required this.createdAt,
    this.confirmed = true,
  });

  final String id;
  final MemoryCategory category;
  final String title;
  final List<String> points;
  final DateTime createdAt;
  final bool confirmed;

  MemoryItem copyWith({bool? confirmed}) => MemoryItem(
        id: id,
        category: category,
        title: title,
        points: points,
        createdAt: createdAt,
        confirmed: confirmed ?? this.confirmed,
      );
}

class MemoryCandidate {
  MemoryCandidate({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.detectedAt,
  });

  final String id;
  final MemoryCategory category;
  final String title;
  final String description;
  final DateTime detectedAt;
}
