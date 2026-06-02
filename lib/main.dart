import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'utils/app_state.dart';
import 'screens/bookshelf_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final appState = AppState();
  await appState.init();

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const StellarPagesApp(),
    ),
  );
}

class StellarPagesApp extends StatelessWidget {
  const StellarPagesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final base = state.currentTheme.toThemeData();
        // Apply Outfit font globally
        final theme = base.copyWith(
          textTheme: GoogleFonts.outfitTextTheme(base.textTheme),
        );
        return MaterialApp(
          title: 'StellarPages',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: const BookshelfScreen(),
        );
      },
    );
  }
}
