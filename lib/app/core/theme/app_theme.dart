import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Centralized theme for the Ema application.
///
/// Use [AppTheme.light] in [MaterialApp.theme].
abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryDark),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
    );
  }
}
