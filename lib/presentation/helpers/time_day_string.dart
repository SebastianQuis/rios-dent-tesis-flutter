
import 'package:flutter/material.dart';

String timeDayString(TimeOfDay time) {
  int horas = time.hour;
  int minutos = time.minute;

  String minutosString = (minutos < 10) ? '0$minutos' : '$minutos';

  String salida = '$horas:$minutosString';

  return salida;
}
