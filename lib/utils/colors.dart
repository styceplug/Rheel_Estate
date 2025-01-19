import 'package:flutter/material.dart';

class AppColors {
  static const mainGradient = LinearGradient(colors: [
    Color(0xFF0A2F1E),
    Color(0xFF118368),
    Color(0xFF0A2F1E),
  ],
      stops: [
    0.00,
    0.52,
    1.0
  ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static const whatsappGradient = LinearGradient(
    colors: [
      Color(0xFF25D366), // WhatsApp green
      Color(0xFF128C7E), // Darker WhatsApp green
      Color(0xFF075E54), // Even darker green
    ],
    stops: [
      0.0,
      0.5,
      1.0,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const blackGradient = LinearGradient(colors: [
    Color(0xFF000000),
    Color(0xFF000000),
    Color(0xFF000000),
  ],
      stops: [
        0.00,
        0.52,
        1.0
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static const accentColor = Color(0xFF016D54);
  static const blackColor = Color(0xFF000000);
  static const bgColor = Color(0xFFF6F6F6);
  static const white = Color(0xFFFFFFFF);
}
