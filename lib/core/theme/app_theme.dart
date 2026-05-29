import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── App-wide color tokens ───────────────────────────────────────────────────
class AppColors {
  // Primary gradient
  static const primary = Color(0xFF6C63FF);
  static const primaryDark = Color(0xFF3D35C4);

  // Accent palette
  static const pink = Color(0xFFFA709A);
  static const orange = Color(0xFFFF9A3C);
  static const mint = Color(0xFF43E97B);
  static const cyan = Color(0xFF4FACFE);
  static const yellow = Color(0xFFFEE140);
  static const coral = Color(0xFFFF6B6B);
  static const teal = Color(0xFF38F9D7);

  // Backgrounds
  static const background = Color(0xFFF0F2FF);
  static const cardBg = Colors.white;
  static const darkBg = Color(0xFF1A1433);

  // Category chip colors (cycles through for each category)
  static const List<List<Color>> categoryGradients = [
    [Color(0xFF6C63FF), Color(0xFF9B59FF)],
    [Color(0xFFFA709A), Color(0xFFFEE140)],
    [Color(0xFF43E97B), Color(0xFF38F9D7)],
    [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    [Color(0xFFFF9A3C), Color(0xFFFFD166)],
    [Color(0xFFB721FF), Color(0xFF21D4FD)],
    [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
  ];

  // Named gradient pairs
  static const heroGradient = [Color(0xFF1A1433), Color(0xFF6C63FF), Color(0xFF9B59FF)];
  static const successGradient = [Color(0xFF43E97B), Color(0xFF38F9D7)];
  static const dangerGradient = [Color(0xFFFF6B6B), Color(0xFFFA709A)];
  static const warmGradient = [Color(0xFFFA709A), Color(0xFFFEE140)];
  static const coolGradient = [Color(0xFF4FACFE), Color(0xFF00F2FE)];
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.pink,
        tertiary: AppColors.mint,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.outfitTextTheme(),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkBg,
        titleTextStyle: GoogleFonts.outfit(
          color: AppColors.darkBg,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return GoogleFonts.outfit(
            color: Colors.grey.shade500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return IconThemeData(color: Colors.grey.shade400, size: 22);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: const Color(0xFFB0AAFF),
        secondary: AppColors.pink,
        surface: const Color(0xFF1A1A2E),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1A1A2E),
        indicatorColor: AppColors.primary.withValues(alpha: 0.25),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}
