import 'package:flutter/material.dart';
import 'app_colors.dart';

final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.accentPrimary,
  onPrimary: Colors.white,
  secondary: AppColors.accentSecondary,
  onSecondary: Colors.white,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
  error: AppColors.error,
  onError: Colors.white,
  primaryContainer: AppColors.accentPrimary.withValues(alpha: 0.12),
  onPrimaryContainer: AppColors.accentPrimary,
  secondaryContainer: AppColors.accentSecondary.withValues(alpha: 0.12),
  onSecondaryContainer: AppColors.accentSecondary,
  surfaceContainerHighest: Colors.white.withValues(alpha: 0.7),
  outline: AppColors.divider,
);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: AppColors.background,

  textTheme: Typography.blackCupertino.apply(
    bodyColor: AppColors.onSurface,
    displayColor: AppColors.onSurface,
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.accentPrimary,
      foregroundColor: Colors.white,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const StadiumBorder(),
      side: const BorderSide(color: AppColors.accentPrimary, width: 1.5),
      foregroundColor: AppColors.onSurface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),

  chipTheme: ChipThemeData(
    backgroundColor: AppColors.chipBackground,
    selectedColor: AppColors.accentPrimary.withValues(alpha: 0.25),
    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),

  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    shadowColor: Colors.black.withValues(alpha: 0.05),
    surfaceTintColor: Colors.transparent,
  ),
);
