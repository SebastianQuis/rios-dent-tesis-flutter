
String fomatMonthName(String month) {
  List<String> partes = month.split('-');

  String? nombreMes;
  switch (partes[1]) {
    case '01':
      nombreMes = 'enero';
      break;
    case '02':
      nombreMes = 'febrero';
      break;
    case '03':
      nombreMes = 'marzo';
      break;
    case '04':
      nombreMes = 'abril';
      break;
    case '05':
      nombreMes = 'mayo';
      break;
    case '06':
      nombreMes = 'junio';
      break;
    case '07':
      nombreMes = 'julio';
      break;
    case '08':
      nombreMes = 'agosto';
      break;
    case '09':
      nombreMes = 'septiembre';
      break;
    case '10':
      nombreMes = 'octubre';
      break;
    case '11':
      nombreMes = 'noviembre';
      break;
    case '12':
      nombreMes = 'diciembre';
      break;
  }

  return '${partes[0]} de $nombreMes del ${partes[2]}';
}
