import 'package:flutter/material.dart';

class StellarTheme {
  final String id;
  final String name;
  final String emoji;
  final Color background;
  final Color surface;
  final Color primary;
  final Color accent;
  final Color text;
  final Color subtext;
  final Color cardColor;
  final bool isDark;
  final List<Color> gradientColors;

  const StellarTheme({
    required this.id,
    required this.name,
    required this.emoji,
    required this.background,
    required this.surface,
    required this.primary,
    required this.accent,
    required this.text,
    required this.subtext,
    required this.cardColor,
    required this.isDark,
    required this.gradientColors,
  });

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: accent,
        onSecondary: isDark ? Colors.black : Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        background: background,
        onBackground: text,
        surface: surface,
        onSurface: text,
      ),
      cardColor: cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: text,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: text, fontFamily: 'serif'),
        bodyLarge: TextStyle(color: text),
        bodyMedium: TextStyle(color: text),
        bodySmall: TextStyle(color: subtext),
      ),
      iconTheme: IconThemeData(color: primary),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: isDark ? Colors.black : Colors.white,
      ),
    );
  }
}

class AppThemes {
  static const List<StellarTheme> all = [
    // 1. Deep Space (Dark)
    StellarTheme(
      id: 'deep_space',
      name: 'Deep Space',
      emoji: '🌌',
      background: Color(0xFF0A0E1A),
      surface: Color(0xFF141928),
      primary: Color(0xFF7B8FFF),
      accent: Color(0xFF00D4FF),
      text: Color(0xFFE8EEFF),
      subtext: Color(0xFF8891B0),
      cardColor: Color(0xFF1A2035),
      isDark: true,
      gradientColors: [Color(0xFF0A0E1A), Color(0xFF1A1040)],
    ),
    // 2. Nebula (Dark purple-pink)
    StellarTheme(
      id: 'nebula',
      name: 'Nebula',
      emoji: '🔮',
      background: Color(0xFF0D0820),
      surface: Color(0xFF1A1030),
      primary: Color(0xFFD66EFF),
      accent: Color(0xFFFF6EC7),
      text: Color(0xFFF0E8FF),
      subtext: Color(0xFF9A88C0),
      cardColor: Color(0xFF1E1438),
      isDark: true,
      gradientColors: [Color(0xFF0D0820), Color(0xFF2D1050)],
    ),
    // 3. Aurora (Dark teal-green)
    StellarTheme(
      id: 'aurora',
      name: 'Aurora',
      emoji: '🌈',
      background: Color(0xFF061510),
      surface: Color(0xFF0C2018),
      primary: Color(0xFF00FFB3),
      accent: Color(0xFF00D4FF),
      text: Color(0xFFD8FFF5),
      subtext: Color(0xFF6BA898),
      cardColor: Color(0xFF102820),
      isDark: true,
      gradientColors: [Color(0xFF061510), Color(0xFF082510)],
    ),
    // 4. Starlight (Dark golden)
    StellarTheme(
      id: 'starlight',
      name: 'Starlight',
      emoji: '⭐',
      background: Color(0xFF0F0C00),
      surface: Color(0xFF1A1600),
      primary: Color(0xFFFFD700),
      accent: Color(0xFFFFAA00),
      text: Color(0xFFFFFAE0),
      subtext: Color(0xFFB8A860),
      cardColor: Color(0xFF201A00),
      isDark: true,
      gradientColors: [Color(0xFF0F0C00), Color(0xFF201500)],
    ),
    // 5. Cosmic Dust (Dark blue-grey)
    StellarTheme(
      id: 'cosmic_dust',
      name: 'Cosmic Dust',
      emoji: '💫',
      background: Color(0xFF0E1520),
      surface: Color(0xFF182030),
      primary: Color(0xFF98B4FF),
      accent: Color(0xFFCCDDFF),
      text: Color(0xFFDDE8FF),
      subtext: Color(0xFF7A8EAA),
      cardColor: Color(0xFF1C2840),
      isDark: true,
      gradientColors: [Color(0xFF0E1520), Color(0xFF182030)],
    ),
    // 6. Sunrise Planet (Light - Day mode)
    StellarTheme(
      id: 'sunrise',
      name: 'Sunrise Planet',
      emoji: '🌅',
      background: Color(0xFFF8F4EE),
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFF4A6CF7),
      accent: Color(0xFFFF6B35),
      text: Color(0xFF1A1A2E),
      subtext: Color(0xFF6B7390),
      cardColor: Color(0xFFFFFFFF),
      isDark: false,
      gradientColors: [Color(0xFFF8F4EE), Color(0xFFEEF2FF)],
    ),
    // 7. Old Galaxy (Sepia)
    StellarTheme(
      id: 'old_galaxy',
      name: 'Old Galaxy',
      emoji: '📜',
      background: Color(0xFFF5ECD7),
      surface: Color(0xFFFAF3E3),
      primary: Color(0xFF8B6914),
      accent: Color(0xFFC8860A),
      text: Color(0xFF2C1810),
      subtext: Color(0xFF8B7355),
      cardColor: Color(0xFFFDF6E3),
      isDark: false,
      gradientColors: [Color(0xFFF5ECD7), Color(0xFFEDE0C4)],
    ),
    // 8. Mars (Dark red)
    StellarTheme(
      id: 'mars',
      name: 'Mars',
      emoji: '🔴',
      background: Color(0xFF150800),
      surface: Color(0xFF200E00),
      primary: Color(0xFFFF5533),
      accent: Color(0xFFFF8844),
      text: Color(0xFFFFE8E0),
      subtext: Color(0xFFAA7060),
      cardColor: Color(0xFF2A1200),
      isDark: true,
      gradientColors: [Color(0xFF150800), Color(0xFF2A1000)],
    ),
    // 9. Black Hole (Pure dark)
    StellarTheme(
      id: 'black_hole',
      name: 'Black Hole',
      emoji: '⚫',
      background: Color(0xFF000000),
      surface: Color(0xFF0A0A0A),
      primary: Color(0xFFFFFFFF),
      accent: Color(0xFFCCCCCC),
      text: Color(0xFFFFFFFF),
      subtext: Color(0xFF888888),
      cardColor: Color(0xFF111111),
      isDark: true,
      gradientColors: [Color(0xFF000000), Color(0xFF0A0A0F)],
    ),
    // 10. Galaxy Mint (Dark mint)
    StellarTheme(
      id: 'galaxy_mint',
      name: 'Galaxy Mint',
      emoji: '🌿',
      background: Color(0xFF071218),
      surface: Color(0xFF0E1F28),
      primary: Color(0xFF6EFFC0),
      accent: Color(0xFF44BBFF),
      text: Color(0xFFD8FFF5),
      subtext: Color(0xFF60A898),
      cardColor: Color(0xFF122030),
      isDark: true,
      gradientColors: [Color(0xFF071218), Color(0xFF0A1C28)],
    ),
  ];

  static StellarTheme getById(String id) {
    return all.firstWhere((t) => t.id == id, orElse: () => all[0]);
  }
}
