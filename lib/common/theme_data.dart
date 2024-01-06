import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getThemeData(BuildContext context) {
  return ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color.fromRGBO(42, 45, 66, 1.0),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.blue, foregroundColor: Colors.blue),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
    ),
    textTheme: GoogleFonts.notoSansTextTheme(
      Theme.of(context).textTheme,
    ),
  );
}
