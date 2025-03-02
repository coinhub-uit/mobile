import "package:catppuccin_flutter/catppuccin_flutter.dart";
import "package:flutter/material.dart";

ThemeData catppuccinTheme({bool isDark = false}) {
  Flavor themeFlavor = isDark ? catppuccin.mocha : catppuccin.latte;

  Color primaryColor = themeFlavor.mauve;
  Color secondaryColor = themeFlavor.yellow;
  Color buttonTextColor = themeFlavor.crust; // Dark color for button text

  return ThemeData(
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,
    appBarTheme: AppBarTheme(
      elevation: 0,
      titleTextStyle: TextStyle(
        color: themeFlavor.text,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: themeFlavor.crust,
      foregroundColor: themeFlavor.mantle,
    ),
    colorScheme: ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      error: themeFlavor.surface2,
      onError: themeFlavor.red,
      onPrimary: buttonTextColor, // Dark text color on primary buttons
      onSecondary: secondaryColor,
      onSurface: themeFlavor.text,
      primary: primaryColor, // Mauve for primary buttons
      secondary: themeFlavor.mantle,
      surface: themeFlavor.base,
    ),
    textTheme: const TextTheme().apply(
      bodyColor: themeFlavor.text,
      displayColor: primaryColor,
    ),
    // Add explicit button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, // Mauve background
        foregroundColor: buttonTextColor, // Dark text
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor, // Mauve text for text buttons
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor, // Mauve text for outlined buttons
        side: BorderSide(color: primaryColor), // Mauve border
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 1,
      backgroundColor: primaryColor, // Mauve FABs
      foregroundColor: buttonTextColor, // Dark icon/text color for FABs
    ),
  );
}
