
import 'package:flutter/material.dart';

import 'package:clinica_dental_app/config/theme/app_theme.dart';

class ThemeService extends ChangeNotifier {

  ThemeData themeData;

  ThemeService({ required bool esModoOscuro }) : themeData = esModoOscuro
    ? AppTheme.darkTheme
    : AppTheme.lightTheme;

  setLightMode() {
    themeData = AppTheme.lightTheme;
    notifyListeners();
  }
  
  setDarkMode() {
    themeData = AppTheme.darkTheme;
    notifyListeners();
  }

}



