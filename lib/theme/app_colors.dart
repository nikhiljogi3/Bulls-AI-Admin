import 'package:flutter/material.dart';

/// Bulls Assets Admin Panel Color Scheme
/// Based on the corporate fintech green theme
class AppColors {
  // Light Mode Colors
  static const Color primaryGreen = Color(0xFF199955); // Bullsassets Green
  static const Color primaryGreenLight = Color(0xFFE8F5E9); // Light green tint

  // Background and Foreground
  static const Color lightBackground = Color(
    0xFFFAFAFA,
  ); // Soft white background
  static const Color lightForeground = Color(0xFF1A1F2E); // Dark grey text

  // Card colors
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightCardForeground = Color(0xFF1A1F2E);

  // Sidebar colors
  static const Color sidebarBackground = Color(0xFF1E293B); // Dark professional
  static const Color sidebarForeground = Color(0xFFE2E8F0);
  static const Color sidebarPrimary = Color(0xFF199955);
  static const Color sidebarAccent = Color(0xFF293450);

  // Border and input
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightInput = Color(0xFFE5E7EB);

  // Muted colors
  static const Color lightMuted = Color(0xFFF3F4F6);
  static const Color lightMutedForeground = Color(0xFF6B7280);

  // Status colors
  static const Color statusSuccess = Color(
    0xFF10B981,
  ); // Emerald for Active/Success
  static const Color statusError = Color(0xFFF87171); // Red for errors
  static const Color statusWarning = Color(
    0xFFFCD34D,
  ); // Yellow/Gold for warnings
  static const Color statusInfo = Color(0xFF3B82F6); // Blue for info

  // Dark Mode Colors (optional, for future use)
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkForeground = Color(0xFFF8FAFC);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkCardForeground = Color(0xFFF8FAFC);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkInput = Color(0xFF334155);

  // Chart colors
  static const List<Color> chartColors = [
    primaryGreen, // Chart 1
    Color(0xFF475569), // Chart 2
    Color(0xFF6EE7B7), // Chart 3 - lighter green
    Color(0xFFFCD34D), // Chart 4 - Gold/Yellow
    Color(0xFFF87171), // Chart 5 - Red
  ];
}

/// App Text Styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}
