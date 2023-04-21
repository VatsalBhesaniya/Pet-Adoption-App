import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light(
    useMaterial3: true,
  );
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
  );
}

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark(
    useMaterial3: true,
  );
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
  );
}

TextTheme _buildTextTheme(TextTheme baseTheme) {
  return GoogleFonts.poppinsTextTheme(baseTheme).copyWith();
}
