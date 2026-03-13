import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF1565C0);       // Blue 800
  static const Color primaryLight = Color(0xFF5E92F3);  // Blue 300
  static const Color primaryDark = Color(0xFF003C8F);   // Blue 900

  // Accent
  static const Color accent = Color(0xFF00ACC1);        // Cyan 600

  // Semantic
  static const Color success = Color(0xFF2E7D32);       // Green 800
  static const Color warning = Color(0xFFF57F17);       // Amber 900
  static const Color error = Color(0xFFC62828);         // Red 800
  static const Color info = Color(0xFF0277BD);          // Light Blue 800

  // Mood colors (1–5 scale)
  static const List<Color> moodColors = [
    Color(0xFFEF5350), // 1 – Very bad (red)
    Color(0xFFFF7043), // 2 – Bad (deep orange)
    Color(0xFFFFCA28), // 3 – Neutral (amber)
    Color(0xFF66BB6A), // 4 – Good (green)
    Color(0xFF42A5F5), // 5 – Great (blue)
  ];

  // Neutral
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
}
