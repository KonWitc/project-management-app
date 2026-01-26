import 'package:flutter/material.dart';

/// App color constants
class AppColors {
  // Cerulean Blue - Primary accent
  static const ceruleanBlue = Color(0xFF0077BE);
  static const ceruleanBlueLight = Color(0xFF4DA6DD);
  static const ceruleanBlueDark = Color(0xFF005A8F);

  // Racing Red - Secondary accent
  static const racingRed = Color(0xFFD40000);
  static const racingRedLight = Color(0xFFFF4444);
  static const racingRedDark = Color(0xFF9F0000);
}

/// Custom color extensions for accessing both accent colors
extension AppColorScheme on ColorScheme {
  /// Cerulean blue accent (primary theme color)
  Color get ceruleanBlue => brightness == Brightness.light
      ? AppColors.ceruleanBlue
      : AppColors.ceruleanBlueLight;

  /// Racing red accent (secondary/emphasis color)
  Color get racingRed => brightness == Brightness.light
      ? AppColors.racingRed
      : AppColors.racingRedLight;

  /// Lighter cerulean variant
  Color get ceruleanBlueContainer => brightness == Brightness.light
      ? AppColors.ceruleanBlueLight
      : AppColors.ceruleanBlueDark;

  /// Lighter racing red variant
  Color get racingRedContainer => brightness == Brightness.light
      ? AppColors.racingRedLight
      : AppColors.racingRedDark;
}

/// Application theme configuration
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration with Material 3
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.ceruleanBlue,
      brightness: Brightness.light,
      primary: AppColors.ceruleanBlue,
      secondary: AppColors.racingRed,
      error: AppColors.racingRed,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,

      // Enhanced visual density for better touch targets
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Card theme
      cardTheme: CardThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
      ),
    );
  }

  /// Dark theme configuration with Material 3
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.ceruleanBlue,
      brightness: Brightness.dark,
      primary: AppColors.ceruleanBlueLight,
      secondary: AppColors.racingRedLight,
      error: AppColors.racingRedLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,

      // Enhanced visual density for better touch targets
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Card theme
      cardTheme: CardThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
      ),
    );
  }
}
