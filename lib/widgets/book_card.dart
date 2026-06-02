import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/book_model.dart';
import '../themes/app_themes.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final StellarTheme theme;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const BookCard({
    super.key,
    required this.book,
    required this.theme,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cover
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14)),
                child: _buildCover(),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: GoogleFonts.outfit(
                      color: theme.text,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.author,
                    style: GoogleFonts.outfit(
                        color: theme.subtext, fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 7),
                  // Format badge + progress
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          book.fileType.toUpperCase(),
                          style: GoogleFonts.outfit(
                            color: theme.primary,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (book.totalPages > 0) ...[
                        const Spacer(),
                        Text(
                          book.progressPercent,
                          style: GoogleFonts.outfit(
                            color: theme.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (book.totalPages > 0) ...[
                    const SizedBox(height: 5),
                    LinearPercentIndicator(
                      lineHeight: 2.5,
                      percent: book.progress,
                      backgroundColor: theme.surface,
                      progressColor: theme.primary,
                      padding: EdgeInsets.zero,
                      barRadius: const Radius.circular(2),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    // Gradient placeholder cover
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _colorFromTitle(book.title),
            _colorFromTitle(book.title).withOpacity(0.55),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Subtle pattern overlay
          Positioned.fill(
            child: CustomPaint(painter: _DiagonalLinePainter()),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  book.fileType == 'pdf'
                      ? Icons.picture_as_pdf_rounded
                      : book.fileType == 'txt'
                          ? Icons.subject_rounded
                          : Icons.menu_book_rounded,
                  color: Colors.white.withOpacity(0.85),
                  size: 30,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    book.title,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFromTitle(String title) {
    final colors = [
      const Color(0xFF5B7BFE),
      const Color(0xFFBF5AF2),
      const Color(0xFF00C896),
      const Color(0xFFFFB800),
      const Color(0xFFFF453A),
      const Color(0xFF30B0C7),
      const Color(0xFFFF2D55),
      const Color(0xFF34C759),
    ];
    final index =
        title.codeUnits.fold(0, (a, b) => a + b) % colors.length;
    return colors[index];
  }
}

/// Subtle diagonal line pattern for book cover
class _DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1;
    const spacing = 12.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_DiagonalLinePainter old) => false;
}
