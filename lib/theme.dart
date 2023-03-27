import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  //textTheme: GoogleFonts.openSansTextTheme(),
  dialogBackgroundColor: const Color.fromARGB(220, 50, 50, 50),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 13, 66, 110),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 64, 134, 169),
    onSecondary: Colors.white,
    tertiary: Color.fromARGB(255, 82, 82, 82),
    onTertiary: Colors.white,
    surface: Color.fromARGB(255, 50, 50, 50), //appbar
    onSurface: Colors.white,
    background: Color.fromARGB(160, 50, 50, 50),
    onBackground: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      disabledBackgroundColor: const Color.fromARGB(190, 90, 90, 90),
      disabledForegroundColor: const Color.fromARGB(200, 215, 215, 215),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      disabledBackgroundColor: const Color.fromARGB(190, 90, 90, 90),
      disabledForegroundColor: const Color.fromARGB(200, 215, 215, 215),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      disabledForegroundColor: const Color.fromARGB(200, 215, 215, 215),
    ),
  ),

  cardTheme: const CardTheme(
    color: Color.fromARGB(180, 50, 50, 50),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    floatingLabelStyle: TextStyle(color: Color.fromARGB(200, 215, 215, 215)),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(200, 215, 215, 215)),
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color.fromARGB(200, 215, 215, 215),
  ),
);
