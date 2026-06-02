import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../themes/app_themes.dart';
import '../widgets/starfield_background.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      final theme = state.currentTheme;
      final books = state.books;
      final finishedBooks = books.where((b) => b.isFinished).toList();
      final inProgress =
          books.where((b) => !b.isFinished && b.currentPage > 0).toList();

      return Theme(
        data: theme.toThemeData(),
        child: Scaffold(
          body: StarfieldBackground(
            gradientColors: theme.gradientColors,
            showStars: theme.isDark,
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              color: theme.text, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'Reading Stats',
                          style: GoogleFonts.outfit(
                            color: theme.text,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      children: [
                        // Stat cards row 1
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.collections_bookmark_outlined,
                                value: '${books.length}',
                                label: 'Total Books',
                                color: theme.primary,
                                theme: theme,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.check_circle_outline_rounded,
                                value: '${finishedBooks.length}',
                                label: 'Finished',
                                color: theme.accent,
                                theme: theme,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Stat cards row 2
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.schedule_rounded,
                                value: state.totalReadingTimeFormatted,
                                label: 'Reading Time',
                                color: const Color(0xFF00FFB3),
                                theme: theme,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.import_contacts_rounded,
                                value: '${inProgress.length}',
                                label: 'In Progress',
                                color: const Color(0xFFFFD700),
                                theme: theme,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        if (inProgress.isNotEmpty) ...[
                          _SectionHeader(
                            icon: Icons.import_contacts_rounded,
                            label: 'Currently Reading',
                            theme: theme,
                          ),
                          const SizedBox(height: 10),
                          ...inProgress
                              .map((b) => _BookStatTile(book: b, theme: theme)),
                          const SizedBox(height: 24),
                        ],

                        if (finishedBooks.isNotEmpty) ...[
                          _SectionHeader(
                            icon: Icons.check_circle_outline_rounded,
                            label: 'Finished',
                            theme: theme,
                          ),
                          const SizedBox(height: 10),
                          ...finishedBooks
                              .map((b) => _BookStatTile(book: b, theme: theme)),
                        ],

                        if (books.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 60),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.auto_stories_outlined,
                                    size: 56,
                                    color: theme.subtext.withOpacity(0.4),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No stats yet',
                                    style: GoogleFonts.outfit(
                                      color: theme.text,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Import and read a book\nto see your progress',
                                    style: GoogleFonts.outfit(
                                      color: theme.subtext,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic theme;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: theme.primary, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: theme.primary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final dynamic theme;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: theme.subtext,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookStatTile extends StatelessWidget {
  final dynamic book;
  final dynamic theme;

  const _BookStatTile({required this.book, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.primary.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              book.isFinished
                  ? Icons.check_circle_outline_rounded
                  : Icons.import_contacts_rounded,
              color: book.isFinished ? theme.accent : theme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: GoogleFonts.outfit(
                    color: theme.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${book.progressPercent} · ${book.readingTimeFormatted}',
                  style: GoogleFonts.outfit(
                      color: theme.subtext, fontSize: 11),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: book.progress,
                    backgroundColor: theme.surface,
                    valueColor: AlwaysStoppedAnimation(theme.primary),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
