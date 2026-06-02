import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../themes/app_themes.dart';
import '../widgets/starfield_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      final theme = state.currentTheme;
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
                          'Settings',
                          style: GoogleFonts.outfit(
                            color: theme.text,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      children: [
                        // ── Appearance ──────────────────────────
                        _SectionLabel(label: 'Appearance', theme: theme),
                        _Card(
                          theme: theme,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                                child: Text(
                                  'Theme',
                                  style: GoogleFonts.outfit(
                                    color: theme.subtext,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              _ThemeScroller(state: state, theme: theme),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Reading ─────────────────────────────
                        _SectionLabel(label: 'Reading', theme: theme),
                        _Card(
                          theme: theme,
                          child: Column(
                            children: [
                              _SliderTile(
                                icon: Icons.format_size_rounded,
                                label: 'Font Size',
                                value: state.fontSize,
                                min: 12,
                                max: 28,
                                displayValue: '${state.fontSize.round()}',
                                color: theme.primary,
                                theme: theme,
                                onChanged: state.setFontSize,
                              ),
                              _Divider(theme: theme),
                              _SliderTile(
                                icon: Icons.format_line_spacing_rounded,
                                label: 'Line Height',
                                value: state.lineHeight,
                                min: 1.2,
                                max: 2.5,
                                displayValue:
                                    state.lineHeight.toStringAsFixed(1),
                                color: theme.primary,
                                theme: theme,
                                onChanged: state.setLineHeight,
                              ),
                              _Divider(theme: theme),
                              _FontFamilyTile(state: state, theme: theme),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Cloud ────────────────────────────────
                        _SectionLabel(label: 'Cloud Sync', theme: theme),
                        _Card(
                          theme: theme,
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                _ActionTile(
                                  icon: Icons.cloud_upload_outlined,
                                  label: 'Backup to Cloud',
                                  subtitle: 'Save books & highlights',
                                  color: const Color(0xFF4285F4),
                                  theme: theme,
                                  onTap: () =>
                                      _showCloudInfo(context, theme),
                                ),
                                _Divider(theme: theme),
                                _ActionTile(
                                  icon: Icons.cloud_download_outlined,
                                  label: 'Restore from Cloud',
                                  subtitle: 'Sync to this device',
                                  color: const Color(0xFF34A853),
                                  theme: theme,
                                  onTap: () =>
                                      _showCloudInfo(context, theme),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── About ────────────────────────────────
                        _SectionLabel(label: 'About', theme: theme),
                        _Card(
                          theme: theme,
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                _InfoTile(
                                    label: 'Version',
                                    value: '1.0.0',
                                    theme: theme),
                                _Divider(theme: theme),
                                _InfoTile(
                                    label: 'Build',
                                    value: 'StellarPages',
                                    theme: theme),
                                _Divider(theme: theme),
                                _ActionTile(
                                  icon: Icons.star_outline_rounded,
                                  label: 'Rate the App',
                                  subtitle: 'Your feedback means a lot',
                                  color: theme.accent,
                                  theme: theme,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
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

  void _showCloudInfo(BuildContext context, theme) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cloud Sync',
            style: GoogleFonts.outfit(
                color: theme.text, fontWeight: FontWeight.w700)),
        content: Text(
          'Cloud sync is coming in v2.0.\n\nConnect Google Drive to sync your library and highlights across all your devices.',
          style: GoogleFonts.outfit(color: theme.subtext, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it',
                style: TextStyle(color: theme.primary)),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final dynamic theme;
  const _SectionLabel({required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(
          color: theme.subtext,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final dynamic theme;
  const _Card({required this.child, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ThemeScroller extends StatelessWidget {
  final AppState state;
  final dynamic theme;
  const _ThemeScroller({required this.state, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: AppThemes.all.length,
        itemBuilder: (_, i) {
          final t = AppThemes.all[i];
          final selected = t.id == state.currentTheme.id;
          return GestureDetector(
            onTap: () => state.setTheme(t.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              width: 68,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: t.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: selected
                    ? Border.all(color: t.primary, width: 2.5)
                    : Border.all(
                        color: Colors.white.withOpacity(0.08), width: 1),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: t.primary.withOpacity(0.35),
                          blurRadius: 12,
                        )
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                    t.name.split(' ').first,
                    style: GoogleFonts.outfit(
                      color: t.text,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(Icons.check_rounded,
                          color: t.primary, size: 10),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final double min;
  final double max;
  final String displayValue;
  final Color color;
  final dynamic theme;
  final ValueChanged<double> onChanged;

  const _SliderTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.displayValue,
    required this.color,
    required this.theme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: theme.subtext, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.outfit(
                    color: theme.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  displayValue,
                  style: GoogleFonts.outfit(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              activeColor: color,
              inactiveColor: color.withOpacity(0.15),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _FontFamilyTile extends StatelessWidget {
  final AppState state;
  final dynamic theme;
  const _FontFamilyTile({required this.state, required this.theme});

  @override
  Widget build(BuildContext context) {
    const fonts = ['Georgia', 'Serif', 'Monospace', 'Sans-serif'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_fields_rounded, color: theme.subtext, size: 18),
              const SizedBox(width: 10),
              Text(
                'Font',
                style: GoogleFonts.outfit(
                    color: theme.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: fonts
                .map((f) => GestureDetector(
                      onTap: () => state.setFontFamily(f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: state.fontFamily == f
                              ? theme.primary
                              : theme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: state.fontFamily == f
                                ? theme.primary
                                : theme.subtext.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontFamily: f,
                            color: state.fontFamily == f
                                ? (theme.isDark ? Colors.black : Colors.white)
                                : theme.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final dynamic theme;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        label,
        style: GoogleFonts.outfit(
            color: theme.text, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.outfit(color: theme.subtext, fontSize: 12),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: theme.subtext.withOpacity(0.5), size: 18),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final dynamic theme;

  const _InfoTile(
      {required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
                color: theme.text, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.outfit(color: theme.subtext, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final dynamic theme;
  const _Divider({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: theme.subtext.withOpacity(0.1),
      indent: 16,
      endIndent: 16,
    );
  }
}
