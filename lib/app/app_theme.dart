import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const background = Color(0xFFF5F2EB);
  static const ink = Color(0xFF292C25);
  static const muted = Color(0xFF686C60);
  static const accent = Color(0xFF55633E);
  static const border = Color(0xFFDEDED2);

  static const pagePadding = 24.0;
  static const sectionGap = 32.0;
  static const cornerRadius = 20.0;

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: accent, surface: background)
        .copyWith(
          onSurface: ink,
          onSurfaceVariant: muted,
          primary: accent,
          onPrimary: Colors.white,
          secondary: const Color(0xFF666B50),
          tertiary: const Color(0xFF806047),
          outlineVariant: border,
        );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final roundedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
    );

    return base.copyWith(
      scaffoldBackgroundColor: background,
      textTheme: base.textTheme.copyWith(
        headlineLarge: const TextStyle(
          fontSize: 34,
          height: 1.15,
          letterSpacing: -1.2,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        headlineSmall: const TextStyle(
          fontSize: 24,
          height: 1.25,
          letterSpacing: -0.6,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          height: 1.35,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        bodyLarge: const TextStyle(fontSize: 16, height: 1.6, color: muted),
        bodyMedium: const TextStyle(fontSize: 14, height: 1.5, color: muted),
        labelSmall: const TextStyle(
          fontSize: 11,
          height: 1.4,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w700,
          color: muted,
        ),
      ),
      appBarTheme: const AppBarThemeData(
        backgroundColor: background,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: roundedShape.copyWith(side: const BorderSide(color: border)),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: muted, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: accent),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        shape: roundedShape,
      ),
    );
  }
}
