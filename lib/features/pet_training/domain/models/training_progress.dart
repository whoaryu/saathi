class TrainingBadge {
  final String id;
  final String title;
  final String description;
  final DateTime unlockedAt;

  const TrainingBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.unlockedAt,
  });

  factory TrainingBadge.fromJson(Map<String, dynamic> json) {
    return TrainingBadge(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'unlockedAt': unlockedAt.toIso8601String(),
    };
  }
}

class TrainingProgress {
  final String id;
  final String userId;
  final String petType;
  final List<String> completedModules;
  final List<String> unlockedModules;
  final int streak;
  final DateTime? lastActiveDate;
  final List<TrainingBadge> badges;

  const TrainingProgress({
    required this.id,
    required this.userId,
    required this.petType,
    required this.completedModules,
    required this.unlockedModules,
    required this.streak,
    this.lastActiveDate,
    required this.badges,
  });

  factory TrainingProgress.fromJson(Map<String, dynamic> json) {
    final completed = List<String>.from(json['completedModules'] ?? []);
    final unlocked = List<String>.from(json['unlockedModules'] ?? []);
    final badgesList = (json['badges'] as List? ?? [])
        .map((b) => TrainingBadge.fromJson(b))
        .toList();

    return TrainingProgress(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      petType: json['petType'] ?? '',
      completedModules: completed,
      unlockedModules: unlocked,
      streak: json['streak'] ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'])
          : null,
      badges: badgesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'petType': petType,
      'completedModules': completedModules,
      'unlockedModules': unlockedModules,
      'streak': streak,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'badges': badges.map((b) => b.toJson()).toList(),
    };
  }
}
