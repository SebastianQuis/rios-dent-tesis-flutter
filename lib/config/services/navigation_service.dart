import 'package:flutter/material.dart';

class NavigationService extends ChangeNotifier {
  int _paginaActual = 0;
  int get paginaActual => _paginaActual;

  set paginaActual(int valor) {
    _paginaActual = valor;
    notifyListeners();
  }

}