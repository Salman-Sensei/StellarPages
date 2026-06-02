import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/book_model.dart';
import '../utils/app_state.dart';
import '../widgets/starfield_background.dart';
import '../widgets/book_card.dart';
import 'reader_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';

class BookshelfScreen extends StatefulWidget {
  const BookshelfScreen({super.key});

  @override
  State<BookshelfScreen> createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _importBook(AppState state) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'pdf', 'txt'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    final ext = file.extension?.toLowerCase() ?? 'txt';
    final title = file.name.replaceAll('.${file.extension}', '');

    final book = Book(
      id: const Uuid().v4(),
      title: title,
      author: 'Unknown Author',
      filePath: file.path!,
      fileType: ext,
    );

    await state.addBook(book);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${book.title}" added to library'),
          backgroundColor: state.currentTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _openBook(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReaderScreen(book: book)),
    );
  }

  void _showBookOptions(BuildContext context, Book book, AppState state) {
    final theme = state.currentTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.subtext.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  book.title,
                  style: GoogleFonts.outfit(
                    color: theme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _OptionTile(
                icon: Icons.menu_book_rounded,
                label: 'Read',
                color: theme.primary,
                theme: theme,
                onTap: () {
                  Navigator.pop(context);
                  _openBook(context, book);
                },
              ),
              _OptionTile(
                icon: Icons.info_outline_rounded,
                label: 'Details',
                color: theme.text,
                theme: theme,
                onTap: () {
                  Navigator.pop(context);
                  _showBookDetails(context, book, theme);
                },
              ),
              _OptionTile(
                icon: Icons.delete_outline_rounded,
                label: 'Remove',
                color: Colors.redAccent,
                theme: theme,
                onTap: () async {
                  Navigator.pop(context);
                  await state.removeBook(book.id);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookDetails(BuildContext context, Book book, theme) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          book.title,
          style: GoogleFonts.outfit(
            color: theme.text,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Author', book.author, theme),
            _detailRow('Format', book.fileType.toUpperCase(), theme),
            _detailRow('Progress', book.progressPercent, theme),
            _detailRow('Time Read', book.readingTimeFormatted, theme),
            _detailRow(
                'Added',
                '${book.addedAt.day}/${book.addedAt.month}/${book.addedAt.year}',
                theme),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: theme.primary)),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, theme) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(
              '$label  ',
              style: GoogleFonts.outfit(color: theme.subtext, fontSize: 13),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.outfit(
                  color: theme.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final theme = state.currentTheme;
        final books = state.books;

        return Theme(
          data: theme.toThemeData(),
          child: Scaffold(
            body: StarfieldBackground(
              gradientColors: theme.gradientColors,
              showStars: theme.isDark,
              child: SafeArea(
                child: FadeTransition(
                  opacity: _fadeController,
                  child: Column(
                    children: [
                      _buildHeader(context, state, theme),
                      Expanded(
                        child: books.isEmpty
                            ? _buildEmptyState(context, state, theme)
                            : _buildGrid(context, state, books, theme),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _importBook(state),
              backgroundColor: theme.primary,
              foregroundColor: theme.isDark ? Colors.black : Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(
                'Import',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppState state, theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
      child: Row(
        children: [
          // App icon + name
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.auto_stories_rounded, color: theme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'StellarPages',
                style: GoogleFonts.outfit(
                  color: theme.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                '${state.books.length} ${state.books.length == 1 ? 'book' : 'books'}',
                style: GoogleFonts.outfit(color: theme.subtext, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          _HeaderIconButton(
            icon: Icons.bar_chart_rounded,
            color: theme.primary,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatsScreen()),
            ),
          ),
          _HeaderIconButton(
            icon: Icons.tune_rounded,
            color: theme.primary,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppState state, theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories_outlined,
                size: 44,
                color: theme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your library is empty',
              style: GoogleFonts.outfit(
                color: theme.text,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Import an EPUB, PDF, or TXT file\nto start reading',
              style: GoogleFonts.outfit(
                color: theme.subtext,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _importBook(state),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(
                'Import Book',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: theme.isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, AppState state,
      List<Book> books, theme) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: books.length,
      itemBuilder: (_, i) {
        final book = books[i];
        return BookCard(
          book: book,
          theme: theme,
          onTap: () => _openBook(context, book),
          onLongPress: () => _showBookOptions(context, book, state),
        );
      },
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _HeaderIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 22),
      splashRadius: 22,
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final dynamic theme;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        label,
        style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
