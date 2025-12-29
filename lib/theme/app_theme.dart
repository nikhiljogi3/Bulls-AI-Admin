import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryGreen,
      secondary: AppColors.primaryGreenLight,
      surface: AppColors.lightCardBackground,
      background: AppColors.lightBackground,
      error: AppColors.statusError,
      onPrimary: Colors.white,
      onSecondary: AppColors.primaryGreen,
      onSurface: AppColors.lightForeground,
      onBackground: AppColors.lightForeground,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightCardBackground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.lightForeground,
      ),
      iconTheme: IconThemeData(color: AppColors.lightForeground),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightCardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.lightBorder, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightInput,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: AppColors.lightMutedForeground, fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        side: BorderSide(color: AppColors.lightBorder),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    textTheme: GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: AppTextStyles.heading1.copyWith(
          color: AppColors.lightForeground,
        ),
        displayMedium: AppTextStyles.heading2.copyWith(
          color: AppColors.lightForeground,
        ),
        displaySmall: AppTextStyles.heading3.copyWith(
          color: AppColors.lightForeground,
        ),
        headlineMedium: AppTextStyles.heading2.copyWith(
          color: AppColors.lightForeground,
        ),
        headlineSmall: AppTextStyles.heading3.copyWith(
          color: AppColors.lightForeground,
        ),
        titleLarge: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.lightForeground,
        ),
        titleMedium: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.lightForeground,
        ),
        titleSmall: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.lightForeground,
        ),
        bodyLarge: AppTextStyles.body.copyWith(
          color: AppColors.lightForeground,
        ),
        bodyMedium: AppTextStyles.body.copyWith(
          color: AppColors.lightForeground,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.lightMutedForeground,
        ),
        labelLarge: AppTextStyles.label.copyWith(
          color: AppColors.lightForeground,
        ),
        labelMedium: AppTextStyles.label.copyWith(
          color: AppColors.lightForeground,
        ),
        labelSmall: AppTextStyles.label.copyWith(
          color: AppColors.lightMutedForeground,
        ),
      ),
    ),
    badgeTheme: BadgeThemeData(
      backgroundColor: AppColors.primaryGreenLight,
      textColor: AppColors.primaryGreen,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightBorder,
      thickness: 1,
      space: 16,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF6EE7B7), // Lighter green for dark mode
      secondary: Color(0xFF334155),
      surface: AppColors.darkCardBackground,
      background: AppColors.darkBackground,
      error: Color(0xFFFCA5A5),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: AppColors.darkCardForeground,
      onBackground: AppColors.darkForeground,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
  );
}

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
