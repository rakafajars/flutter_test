import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF9C27B0);
  static const Color primaryDark = Color(0xFF7B1FA2);
  static const Color primaryLight = Color(0xFFE1BEE7);

  // Accent Colors
  static const Color accent = Color(0xFFFF9800);
  static const Color accentOrange = Color(0xFFFF5722);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;

  // Status Colors
  static const Color error = Colors.red;
  static const Color success = Colors.green;

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary],
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, primaryDark],
  );
}
