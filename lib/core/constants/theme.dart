import "package:catppuccin_flutter/catppuccin_flutter.dart";
import "package:flutter/material.dart";

ThemeData catppuccinTheme({bool isDark = false}) {
  Flavor themeFlavor = isDark ? catppuccin.mocha : catppuccin.latte;

  Color primaryColor = themeFlavor.mauve;
  Color secondaryColor = themeFlavor.yellow;
  Color buttonTextColor = themeFlavor.crust;

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
      iconTheme: IconThemeData(color: themeFlavor.text),
    ),
    colorScheme: ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      error: themeFlavor.surface2,
      onError: themeFlavor.red,
      onPrimary: buttonTextColor,
      onSecondary: secondaryColor,
      onSurface: themeFlavor.text,
      primary: primaryColor,
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
        backgroundColor: primaryColor,
        foregroundColor: buttonTextColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryColor),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 1,
      backgroundColor: primaryColor,
      foregroundColor: buttonTextColor,
    ),
  );
}
