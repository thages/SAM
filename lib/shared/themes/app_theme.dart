import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkGreen,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkGreen,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.white70,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        bodyLarge: TextStyle(fontSize: 18, color: AppColors.darkText),
        bodyMedium: TextStyle(fontSize: 16, color: AppColors.darkText),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class AppColors {
  static const Color primary = Color(0xFF388E3C); // 🌱 Main Green
  static const Color lightGreen = Color(0xFFC8E6C9); // 🟢 Light Green
  static const Color darkGreen = Color(0xFF1B5E20); // 🌿 Dark Green
  static const Color yellow = Color(0xFFFBC02D); // ☀️ Yellow-Gold (Highlights)
  static const Color brown = Color(0xFF8D6E63); // 🏜️ Brown (Soil)
  static const Color blue = Color(0xFF42A5F5); // 🔵 Sky Blue (Weather)
  static const Color background = Color(
    0xFFFFFFFF,
  ); // 🌤 Light Gray (Background)
  static const Color darkText = Color(0xFF37474F); // 🖋️ Dark Gray Text
  static const Color red = Color(0xFFD32F2F); // 🍎 Red (Costs
  static const Color purple = Color(
    0xFF7B1FA2,
  ); // 🟣 Purple (Machine Performance)
  static const Color orange = Color(0xFFFFA000); // 🟠 Orange (Revenue)
  static const Color blueGrey = Color(0xFF607D8B); // 🌌 Blue Grey (ROI)
}
