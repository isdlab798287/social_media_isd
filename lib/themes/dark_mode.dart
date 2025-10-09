import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    // App bar, drawer, and card backgrounds
    surface: Color(0xFF2E2E2E), // dark gray
    // Scaffold / main background
    primary: Color.fromARGB(255, 165, 165, 165),// medium-dark gray
    // Secondary elements (panels, buttons, containers)
    secondary: Color(0xFF535353),
    // Slightly lighter backgrounds (cards, overlays)
    tertiary: Color(0xFF616161),
    // Highlight text/icons
    inversePrimary: Color(0xFFE0E0E0),
  ),

  scaffoldBackgroundColor: const Color(0xFF424242),

);
