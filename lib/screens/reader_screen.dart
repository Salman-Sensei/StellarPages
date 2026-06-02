import 'dart:async';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universal_file/universal_file.dart';
import 'package:uuid/uuid.dart';

import '../models/book_model.dart';
import '../themes/app_themes.dart';
import '../utils/app_state.dart';
import '../widgets/starfield_background.dart';

class ReaderScreen extends StatefulWidget {
  final Book book;
  const ReaderScreen({super.key, required this.book});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  // EPUB
  EpubController? _epubController;

  // UI State
  bool _showControls = true;
  bool _showBookmarks = false;
  Timer? _controlsTimer;
  Timer? _autoScrollTimer;
  Timer? _readingTimer;

  // Auto-scroll
  final ScrollController _textScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initReader();
    _startReadingTimer();
  }

  void _initReader() {
    if (widget.book.fileType == 'epub') {
      _epubController = EpubController(
        // universal_file's File is compatible with EpubDocument.openFile
        document: EpubDocument.openFile(File(widget.book.filePath)),
      );
    }
  }

  void _startReadingTimer() {
    _readingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      Provider.of<AppState>(context, listen: false).addReadingTime(widget.book.id, 10);
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _resetControlsTimer();
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _startAutoScroll(int speed) {
    _autoScrollTimer?.cancel();
    if (speed == 0) return;

    // px per tick — speed 1 = 1px, speed 5 = 5px
    final interval = Duration(milliseconds: 50);
    final pixels = speed.toDouble();

    _autoScrollTimer = Timer.periodic(interval, (_) {
      if (_textScrollController.hasClients) {
        final current = _textScrollController.offset;
        final max = _textScrollController.position.maxScrollExtent;
        if (current < max) {
          _textScrollController.jumpTo(current + pixels);
        } else {
          _autoScrollTimer?.cancel();
        }
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  Future<void> _toggleTts() async {
    // TTS stub — wire up flutter_tts on mobile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TTS available on Android/iOS')),
    );
  }

  void _addBookmark() {
    final state = Provider.of<AppState>(context, listen: false);
    final page = widget.book.currentPage;

    showDialog(
      context: context,
      builder: (_) {
        final ctrl = TextEditingController();
        final theme = state.currentTheme;
        return AlertDialog(
          backgroundColor: theme.surface,
          title: Text('Add Bookmark',
              style: TextStyle(color: theme.text)),
          content: TextField(
            controller: ctrl,
            style: TextStyle(color: theme.text),
            decoration: InputDecoration(
              hintText: 'Note (optional)',
              hintStyle: TextStyle(color: theme.subtext),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.primary)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.primary)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  Text('Cancel', style: TextStyle(color: theme.subtext)),
            ),
            TextButton(
              onPressed: () {
                state.addBookmark(Bookmark(
                  id: const Uuid().v4(),
                  bookId: widget.book.id,
                  page: page,
                  note: ctrl.text.isEmpty ? 'Page $page' : ctrl.text,
                ));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Bookmark saved',
                      style: GoogleFonts.outfit(),
                    ),
                    backgroundColor: theme.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Text('Save', style: TextStyle(color: theme.primary)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _readingTimer?.cancel();
    _autoScrollTimer?.cancel();
    _controlsTimer?.cancel();
    _epubController?.dispose();
    _textScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      final theme = state.currentTheme;
      return Theme(
        data: theme.toThemeData(),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: theme.isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: KeyboardListener(
              focusNode: FocusNode()..requestFocus(),
              onKeyEvent: (event) {
                // Volume key paging — supported on Android hardware keys
              },
              child: GestureDetector(
                onTap: _toggleControls,
                child: StarfieldBackground(
                  gradientColors: theme.gradientColors,
                  showStars: false, // Off while reading for focus
                  child: Stack(
                    children: [
                      _buildContent(state),
                      if (_showControls) ...[
                        _buildTopBar(context, state),
                        _buildBottomBar(context, state),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildContent(AppState state) {
    final theme = state.currentTheme;

    if (widget.book.fileType == 'epub' && _epubController != null) {
      return EpubView(
        controller: _epubController!,
        onChapterChanged: (chapter) {
          if (chapter != null && mounted) {
            final page = chapter.paragraphNumber;
            Provider.of<AppState>(context, listen: false).updateBookProgress(
                widget.book.id, page, 100);
          }
        },
      );
    }

    if (widget.book.fileType == 'pdf') {
      // PDF viewer — show a placeholder for now (syncfusion requires Android/iOS)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, size: 80, color: theme.primary.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text('PDF file: ${widget.book.title}',
                style: TextStyle(color: theme.text, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('PDF rendering available on Android/iOS',
                style: TextStyle(color: theme.subtext, fontSize: 14)),
          ],
        ),
      );
    }

    // TXT fallback
    return FutureBuilder<String>(
      future: File(widget.book.filePath).readAsString(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return Center(
              child: CircularProgressIndicator(color: theme.primary));
        }
        return SingleChildScrollView(
          controller: _textScrollController,
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 100),
          child: Text(
            snap.data!,
            style: TextStyle(
              color: theme.text,
              fontSize: state.fontSize,
              fontFamily: state.fontFamily,
              height: state.lineHeight,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, AppState state) {
    final theme = state.currentTheme;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.background,
              theme.background.withOpacity(0),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: theme.text),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    widget.book.title,
                    style: TextStyle(
                      color: theme.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_add_outlined, color: theme.text),
                  onPressed: _addBookmark,
                  tooltip: 'Bookmark',
                ),
                IconButton(
                  icon: Icon(Icons.bookmarks_outlined, color: theme.text),
                  onPressed: () =>
                      setState(() => _showBookmarks = !_showBookmarks),
                  tooltip: 'Bookmarks',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, AppState state) {
    final theme = state.currentTheme;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              theme.background,
              theme.background.withOpacity(0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress indicator
              if (widget.book.totalPages > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        'Page ${widget.book.currentPage}',
                        style: TextStyle(color: theme.subtext, fontSize: 11),
                      ),
                      Expanded(
                        child: Slider(
                          value: widget.book.progress,
                          onChanged: (_) {},
                          activeColor: theme.primary,
                          inactiveColor: theme.primary.withOpacity(0.2),
                        ),
                      ),
                      Text(
                        widget.book.progressPercent,
                        style: TextStyle(color: theme.subtext, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              // Action row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _BarButton(
                      icon: Icons.record_voice_over_outlined,
                      label: 'TTS',
                      color: theme.text,
                      onTap: _toggleTts,
                    ),
                    _BarButton(
                      icon: Icons.font_download_outlined,
                      label: 'Font',
                      color: theme.text,
                      onTap: () => _showFontPanel(context, state),
                    ),
                    _BarButton(
                      icon: Icons.speed,
                      label: state.autoScrollSpeed == 0
                          ? 'Scroll'
                          : 'Speed ${state.autoScrollSpeed}',
                      color: state.autoScrollSpeed > 0
                          ? theme.primary
                          : theme.text,
                      onTap: () => _showAutoScrollPanel(context, state),
                    ),
                    _BarButton(
                      icon: Icons.palette_outlined,
                      label: 'Theme',
                      color: theme.text,
                      onTap: () => _showThemePicker(context, state),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFontPanel(BuildContext context, AppState state) {
    final theme = state.currentTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Font Size',
                  style: TextStyle(
                      color: theme.text, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Icon(Icons.text_fields, color: theme.subtext, size: 16),
                  Expanded(
                    child: Slider(
                      value: state.fontSize,
                      min: 12,
                      max: 28,
                      divisions: 16,
                      activeColor: theme.primary,
                      inactiveColor: theme.primary.withOpacity(0.2),
                      onChanged: (v) {
                        state.setFontSize(v);
                        setModal(() {});
                      },
                    ),
                  ),
                  Icon(Icons.text_fields, color: theme.subtext, size: 22),
                ],
              ),
              Text('Line Height',
                  style: TextStyle(
                      color: theme.text, fontWeight: FontWeight.bold)),
              Slider(
                value: state.lineHeight,
                min: 1.2,
                max: 2.5,
                divisions: 13,
                activeColor: theme.primary,
                inactiveColor: theme.primary.withOpacity(0.2),
                onChanged: (v) {
                  state.setLineHeight(v);
                  setModal(() {});
                },
              ),
              Text('Font Family',
                  style: TextStyle(
                      color: theme.text, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Georgia', 'Serif', 'Monospace', 'Sans-serif']
                    .map((f) => ChoiceChip(
                          label: Text(f),
                          selected: state.fontFamily == f,
                          selectedColor: theme.primary,
                          labelStyle: TextStyle(
                            color: state.fontFamily == f
                                ? Colors.white
                                : theme.text,
                          ),
                          backgroundColor: theme.cardColor,
                          onSelected: (_) => state.setFontFamily(f),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showAutoScrollPanel(BuildContext context, AppState state) {
    final theme = state.currentTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Auto-Scroll Speed',
                style: TextStyle(
                    color: theme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _SpeedChip(label: 'Off', value: 0, state: state, theme: theme,
                    onTap: () {
                  state.setAutoScrollSpeed(0);
                  _stopAutoScroll();
                }),
                ...List.generate(
                    5,
                    (i) => _SpeedChip(
                          label: '${i + 1}x',
                          value: i + 1,
                          state: state,
                          theme: theme,
                          onTap: () {
                            state.setAutoScrollSpeed(i + 1);
                            _startAutoScroll(i + 1);
                          },
                        )),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, AppState state) {
    final theme = state.currentTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reading Theme',
                style: TextStyle(
                    color: theme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppThemes.all.length,
                itemBuilder: (_, i) {
                  final t = AppThemes.all[i];
                  final selected = t.id == state.currentTheme.id;
                  return GestureDetector(
                    onTap: () => state.setTheme(t.id),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: t.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: selected
                            ? Border.all(color: t.primary, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(t.emoji, style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 4),
                          Text(
                            t.name.split(' ').first,
                            style: TextStyle(
                                color: t.text,
                                fontSize: 8,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BarButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final String label;
  final int value;
  final AppState state;
  final dynamic theme;
  final VoidCallback onTap;

  const _SpeedChip({
    required this.label,
    required this.value,
    required this.state,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = state.autoScrollSpeed == value;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? theme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : theme.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
