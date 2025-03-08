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
        fontSize: 24,
        fontWeight: FontWeight.normal,
      ),
      toolbarTextStyle: TextStyle(
        color: themeFlavor.text,
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
      backgroundColor: themeFlavor.crust,
      foregroundColor: themeFlavor.mantle,
      iconTheme: IconThemeData(color: themeFlavor.text, size: 36),
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
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(
        fontSize: 36,
        height: 1.0,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      displayLarge: TextStyle(
        height: 1.2,
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: themeFlavor.mantle,
      ),
      // for the text inside the cards
    ).apply(
      bodyColor: themeFlavor.text,
      //displayColor: primaryColor,
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
    iconTheme: IconThemeData(color: themeFlavor.mantle, size: 60),
  );
}
