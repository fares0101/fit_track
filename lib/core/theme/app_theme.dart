import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primary,
        brightness: Brightness.light,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppConstants.lightSurface,
      textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        displayMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        displaySmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.75),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark().copyWith(
        primary: AppConstants.primary,
        secondary: AppConstants.secondary,
        surface: AppConstants.darkCard,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppConstants.darkSurface,
      textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        displayMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        displaySmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppConstants.darkCard.withValues(alpha: 0.72),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.darkCardAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        backgroundColor: const Color(0xFF0E151B),
        indicatorColor: AppConstants.primary.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppConstants.primary);
          }
          return const IconThemeData(color: Color(0xFF8AA0AE));
        }),
      ),
    );
  }
}
