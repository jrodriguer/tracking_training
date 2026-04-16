import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const seed = Color(0xFF176087);
  final colorScheme = ColorScheme.fromSeed(seedColor: seed);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(0xFFF8F7F3),
    appBarTheme: const AppBarTheme(centerTitle: false),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
