import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:shared_preferences/shared_preferences.dart";

// Theme constants
class AppTheme {
  // Primary color from your requirement
  static const Color primaryColor = Color(0xFF493D9E);

  // Light theme colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF2D3142);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Dark theme colors - vintage inspired
  static const Color darkBackground = Color(0xFF1A1625);
  static const Color darkSurface = Color(0xFF2A2438);
  static const Color darkText = Color(0xFFF1F0F5);
  static const Color darkTextSecondary = Color(0xFFB4B0C5);
  static const Color darkBorder = Color(0xFF3D3A50);

  // Accent colors for both themes
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentCopper = Color(0xFFB87333);
  static const Color accentTeal = Color(0xFF40E0D0);

  // Error, warning, success colors
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color success = Color(0xFF43A047);

  // Theme mode key for shared preferences
  static const String themeModeKey = "theme_mode";

  // Get ThemeMode from shared preferences
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeModeString = prefs.getString(themeModeKey);

    if (themeModeString == "dark") {
      return ThemeMode.dark;
    } else if (themeModeString == "light") {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  // Save ThemeMode to shared preferences
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String themeModeString;

    switch (mode) {
      case ThemeMode.dark:
        themeModeString = "dark";
        break;
      case ThemeMode.light:
        themeModeString = "light";
        break;
      default:
        themeModeString = "system";
    }

    await prefs.setString(themeModeKey, themeModeString);
  }

  // Create light theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentTeal,
        surface: lightSurface, // Changed from lightBackground
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightText, // Keep for backward compatibility
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          color: lightText,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: lightText,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          color: lightText,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: GoogleFonts.inter(
          color: lightText,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.inter(
          color: lightText,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: GoogleFonts.inter(
          color: lightText,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.inter(
          color: lightText,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.inter(
          color: lightText,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.inter(
          color: lightText,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(color: lightText),
        bodyMedium: GoogleFonts.inter(color: lightText),
        bodySmall: GoogleFonts.inter(color: lightTextSecondary),
        labelLarge: GoogleFonts.inter(
          color: lightText,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.inter(
          color: lightText,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.inter(
          color: lightTextSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: lightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: lightText),
      ),
      cardTheme: CardTheme(
        color: lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        hintStyle: GoogleFonts.inter(color: lightTextSecondary),
        labelStyle: GoogleFonts.inter(color: primaryColor),
        prefixIconColor: primaryColor,
        suffixIconColor: lightTextSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightTextSecondary,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(
        color: lightBorder,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightText,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(
          color: lightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: GoogleFonts.inter(color: lightText, fontSize: 16),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        side: BorderSide(color: lightTextSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return lightTextSecondary;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withAlpha(128);
          }
          return lightTextSecondary.withAlpha(77);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        circularTrackColor: lightBorder,
        linearTrackColor: lightBorder,
      ),
    );
  }

  // Create dark theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentGold,
        surface: darkSurface, // Changed from darkBackground
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: darkText, // Keep for backward compatibility
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          color: darkText,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: darkText,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          color: darkText,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: GoogleFonts.inter(
          color: darkText,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.inter(
          color: darkText,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: GoogleFonts.inter(
          color: darkText,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.inter(
          color: darkText,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.inter(
          color: darkText,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.inter(
          color: darkText,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(color: darkText),
        bodyMedium: GoogleFonts.inter(color: darkText),
        bodySmall: GoogleFonts.inter(color: darkTextSecondary),
        labelLarge: GoogleFonts.inter(
          color: darkText,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.inter(
          color: darkText,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.inter(
          color: darkTextSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: darkText),
      ),
      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        hintStyle: GoogleFonts.inter(color: darkTextSecondary),
        labelStyle: GoogleFonts.inter(color: primaryColor),
        prefixIconColor: primaryColor,
        suffixIconColor: darkTextSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkTextSecondary,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(color: darkBorder, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurface,
        contentTextStyle: GoogleFonts.inter(color: darkText),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: GoogleFonts.inter(color: darkText, fontSize: 16),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        side: BorderSide(color: darkTextSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return darkTextSecondary;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withAlpha(128);
          }
          return darkTextSecondary.withAlpha(77);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        circularTrackColor: darkBorder,
        linearTrackColor: darkBorder,
      ),
    );
  }
}
