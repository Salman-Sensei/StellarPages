import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/book_model.dart';
import '../themes/app_themes.dart';

class AppState extends ChangeNotifier {
  static const _themeKey = 'theme_id';
  static const _fontSizeKey = 'font_size';
  static const _fontFamilyKey = 'font_family';
  static const _lineHeightKey = 'line_height';
  static const _autoScrollKey = 'auto_scroll_speed';

  late Box<Book> _bookBox;
  late Box<Bookmark> _bookmarkBox;
  late Box<Highlight> _highlightBox;
  late Box<dynamic> _settingsBox;

  StellarTheme _currentTheme = AppThemes.all[0];
  double _fontSize = 17.0;
  String _fontFamily = 'Georgia';
  double _lineHeight = 1.7;
  int _autoScrollSpeed = 0; // 0 = off, 1-5 = speed levels

  // ─── Getters ───────────────────────────────────────────────
  StellarTheme get currentTheme => _currentTheme;
  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  double get lineHeight => _lineHeight;
  int get autoScrollSpeed => _autoScrollSpeed;

  List<Book> get books {
    if (!_bookBox.isOpen) return [];
    return _bookBox.values.toList()
      ..sort((a, b) => (b.lastReadAt ?? b.addedAt)
          .compareTo(a.lastReadAt ?? a.addedAt));
  }

  List<Bookmark> bookmarksFor(String bookId) {
    if (!_bookmarkBox.isOpen) return [];
    return _bookmarkBox.values
        .where((b) => b.bookId == bookId)
        .toList()
      ..sort((a, b) => a.page.compareTo(b.page));
  }

  List<Highlight> highlightsFor(String bookId) {
    if (!_highlightBox.isOpen) return [];
    return _highlightBox.values
        .where((h) => h.bookId == bookId)
        .toList()
      ..sort((a, b) => a.page.compareTo(b.page));
  }

  // ─── Stats ──────────────────────────────────────────────────
  int get totalBooksRead => books.where((b) => b.isFinished).length;

  int get totalReadingSeconds =>
      books.fold(0, (sum, b) => sum + b.readingTimeSeconds);

  String get totalReadingTimeFormatted {
    final hours = totalReadingSeconds ~/ 3600;
    final minutes = (totalReadingSeconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  // ─── Init ───────────────────────────────────────────────────
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(BookAdapter());
    Hive.registerAdapter(BookmarkAdapter());
    Hive.registerAdapter(HighlightAdapter());

    _bookBox = await Hive.openBox<Book>('books');
    _bookmarkBox = await Hive.openBox<Bookmark>('bookmarks');
    _highlightBox = await Hive.openBox<Highlight>('highlights');
    _settingsBox = await Hive.openBox('settings');

    _loadSettings();
  }

  void _loadSettings() {
    final themeId = _settingsBox.get(_themeKey, defaultValue: 'deep_space');
    _currentTheme = AppThemes.getById(themeId);
    _fontSize = _settingsBox.get(_fontSizeKey, defaultValue: 17.0);
    _fontFamily = _settingsBox.get(_fontFamilyKey, defaultValue: 'Georgia');
    _lineHeight = _settingsBox.get(_lineHeightKey, defaultValue: 1.7);
    _autoScrollSpeed = _settingsBox.get(_autoScrollKey, defaultValue: 0);
  }

  // ─── Theme ──────────────────────────────────────────────────
  void setTheme(String themeId) {
    _currentTheme = AppThemes.getById(themeId);
    _settingsBox.put(_themeKey, themeId);
    notifyListeners();
  }

  // ─── Reading settings ───────────────────────────────────────
  void setFontSize(double size) {
    _fontSize = size.clamp(12.0, 28.0);
    _settingsBox.put(_fontSizeKey, _fontSize);
    notifyListeners();
  }

  void setFontFamily(String family) {
    _fontFamily = family;
    _settingsBox.put(_fontFamilyKey, family);
    notifyListeners();
  }

  void setLineHeight(double height) {
    _lineHeight = height.clamp(1.2, 2.5);
    _settingsBox.put(_lineHeightKey, _lineHeight);
    notifyListeners();
  }

  void setAutoScrollSpeed(int speed) {
    _autoScrollSpeed = speed.clamp(0, 5);
    _settingsBox.put(_autoScrollKey, _autoScrollSpeed);
    notifyListeners();
  }

  // ─── Books ──────────────────────────────────────────────────
  Future<void> addBook(Book book) async {
    await _bookBox.put(book.id, book);
    notifyListeners();
  }

  Future<void> removeBook(String bookId) async {
    await _bookBox.delete(bookId);
    // Clean up related data
    final bmKeys = _bookmarkBox.values
        .where((b) => b.bookId == bookId)
        .map((b) => b.key)
        .toList();
    await _bookmarkBox.deleteAll(bmKeys);
    final hlKeys = _highlightBox.values
        .where((h) => h.bookId == bookId)
        .map((h) => h.key)
        .toList();
    await _highlightBox.deleteAll(hlKeys);
    notifyListeners();
  }

  Future<void> updateBookProgress(String bookId, int page, int totalPages) async {
    final book = _bookBox.get(bookId);
    if (book != null) {
      book.currentPage = page;
      book.totalPages = totalPages;
      book.lastReadAt = DateTime.now();
      if (page >= totalPages - 1) book.isFinished = true;
      await book.save();
      notifyListeners();
    }
  }

  Future<void> addReadingTime(String bookId, int seconds) async {
    final book = _bookBox.get(bookId);
    if (book != null) {
      book.readingTimeSeconds += seconds;
      await book.save();
    }
  }

  // ─── Bookmarks ──────────────────────────────────────────────
  Future<void> addBookmark(Bookmark bookmark) async {
    await _bookmarkBox.put(bookmark.id, bookmark);
    notifyListeners();
  }

  Future<void> removeBookmark(String bookmarkId) async {
    await _bookmarkBox.delete(bookmarkId);
    notifyListeners();
  }

  // ─── Highlights ─────────────────────────────────────────────
  Future<void> addHighlight(Highlight highlight) async {
    await _highlightBox.put(highlight.id, highlight);
    notifyListeners();
  }

  Future<void> removeHighlight(String highlightId) async {
    await _highlightBox.delete(highlightId);
    notifyListeners();
  }
}
