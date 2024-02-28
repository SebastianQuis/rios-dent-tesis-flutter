
import 'package:flutter/material.dart';

class AppTheme {
  static const Color color1 = Color(0xffffecd1);
  static const Color color2 = Color(0xff15616d);
  static const Color color3 = Color(0xffff7d00);
  static const Color color4 = Color(0xff78290f);
  static const Color color5 = Color(0xff001524);


  static final lightTheme = ThemeData.light().copyWith(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showUnselectedLabels: true,
      backgroundColor: color1,
      selectedItemColor: color2,
      unselectedItemColor: color5,
      elevation: 0
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: color2,
      elevation: 0
    )
  );

  static final darkTheme = ThemeData.dark().copyWith(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showUnselectedLabels: true,
      selectedItemColor: color1,
      unselectedItemColor: Colors.grey,
      elevation: 0
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: color2,
      elevation: 0
    )

  );


}

