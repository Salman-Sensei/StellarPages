import 'package:hive/hive.dart';

part 'book_model.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String author;

  @HiveField(3)
  late String filePath;

  @HiveField(4)
  late String fileType; // 'epub', 'pdf', 'txt'

  @HiveField(5)
  String? coverPath;

  @HiveField(6)
  late DateTime addedAt;

  @HiveField(7)
  int currentPage = 0;

  @HiveField(8)
  int totalPages = 0;

  @HiveField(9)
  int readingTimeSeconds = 0;

  @HiveField(10)
  bool isFinished = false;

  @HiveField(11)
  DateTime? lastReadAt;

  @HiveField(12)
  String? description;

  double get progress =>
      totalPages > 0 ? (currentPage / totalPages).clamp(0.0, 1.0) : 0.0;

  String get progressPercent => '${(progress * 100).toStringAsFixed(0)}%';

  String get readingTimeFormatted {
    final hours = readingTimeSeconds ~/ 3600;
    final minutes = (readingTimeSeconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.filePath,
    required this.fileType,
    this.coverPath,
    this.description,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
}

@HiveType(typeId: 1)
class Bookmark extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String bookId;

  @HiveField(2)
  late int page;

  @HiveField(3)
  late String note;

  @HiveField(4)
  late DateTime createdAt;

  Bookmark({
    required this.id,
    required this.bookId,
    required this.page,
    required this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

@HiveType(typeId: 2)
class Highlight extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String bookId;

  @HiveField(2)
  late String text;

  @HiveField(3)
  late int page;

  @HiveField(4)
  String? note;

  @HiveField(5)
  late int colorIndex; // 0=yellow, 1=green, 2=blue, 3=pink

  @HiveField(6)
  late DateTime createdAt;

  Highlight({
    required this.id,
    required this.bookId,
    required this.text,
    required this.page,
    this.note,
    this.colorIndex = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
