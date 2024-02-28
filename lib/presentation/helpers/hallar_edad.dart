
String hallarEdad( DateTime nacimiento) {
  DateTime ahora = DateTime.now();
  int edad = ahora.year - nacimiento.year;

  if (ahora.month < nacimiento.month ||
      (ahora.month == nacimiento.month && ahora.day < nacimiento.day)) {
    edad--;
  }

  return '$edad';
}

