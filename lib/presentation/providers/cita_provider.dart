import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

import 'package:clinica_dental_app/config/global/environment.dart';
import 'package:clinica_dental_app/domain/response/response.dart';
import 'package:clinica_dental_app/domain/entities/entities.dart';
import 'package:clinica_dental_app/presentation/helpers/helpers.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';

class CitaProvider extends ChangeNotifier {
  
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Cita? citaSeleccionada;

  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay  => _focusedDay;

  set selectedDay( DateTime day ) {
    _selectedDay = day;
    notifyListeners();
  }
  
  set focusedDay( DateTime day ) {
    _focusedDay = day;
    notifyListeners();
  }

  bool _registrando = false;
  bool get registrando => _registrando;

  set registrando( bool value) {
    _registrando = value;
    notifyListeners();
  }

  List<CitasMes> _citasMes = [];
  List<Cita> citasDia = [];
  bool cargandoCitaDia = false;


  final kEvents = LinkedHashMap<DateTime, List<Cita>>(
    equals: isSameDay,
    hashCode: (key) => key.day * 1000000 + key.month * 10000 + key.year
  );

  Future<void> initCitas(String odontologo) async {
    _citasMes = await getCitasMonth(odontologo);
    notifyListeners();
  }

  Future<List<CitasMes>> getCitasMonth(String odontologo) async {
    try {
      final url = Uri.parse( '${Environment.apiUrl}/citas/cantidad/odontologo/$odontologo' );
      final resp = await http.get( url,
        headers: { 'Content-Type': 'application/json', 'x-token': await AutenticacionProvider.getToken() }
      );

      final citasMesRespuesta = citasMesResponseFromJson(resp.body);
      _citasMes = citasMesRespuesta.result;
      notifyListeners();
      return citasMesRespuesta.result;      
    } catch (e) {
      return [];
    }
  }  
  
  Future<List<Cita>> getCitasByDay(String odontologo, String fecha) async {
    try {
      final url = Uri.parse( '${Environment.apiUrl}/citas/odontologo/$odontologo/fecha/$fecha' );
      final resp = await http.get( url,
        headers: { 'Content-Type': 'application/json', 'x-token': await AutenticacionProvider.getToken() }
      );

      final citasDia = citaResponseFromJson(resp.body);
      return citasDia.cita;      
    } catch (e) {
      return [];
    }
  }

  List<Cita> getCitasCalendar(DateTime day) {
    kEvents[day] = [];
    for(var cita in _citasMes) {
      DateTime citaFecha = parseStringDate(cita.fecha);
      kEvents.addAll({
        citaFecha: List.generate(cita.cantidad, (i) => Cita(
          paciente: '',
          odontologo: '',
          horaInicial: '',
          horaFinal: '',
          nota: '',
          fecha: DateTime.now().toString(),
          telefono: '',
        ))
      });
    }

    return kEvents[day] ?? [];
  }
    
  Future<void> getCitasDay(DateTime day, String odontologo) async {
    citasDia = [];
    notifyListeners();

    final fechasConCitas = _citasMes.map((citaMes) {
      DateTime citaFecha = parseStringDate(citaMes.fecha);
      return citaFecha;
    }).toList();

    final sinCitas = fechasConCitas.where((fecha) => (fecha.year == day.year && fecha.month == day.month && fecha.day == day.day)).isEmpty;

    if (sinCitas) { return; }
    
    cargandoCitaDia = false;
    notifyListeners();
    cargandoCitaDia = true;
    notifyListeners();

    final diaParseado = parseDateTimeString(day);

    citasDia = await getCitasByDay(odontologo, diaParseado);
    cargandoCitaDia = false;
    notifyListeners();
  }
 
  Future<bool> eliminarCita(Cita cita) async {
    try {
      final url = Uri.parse( '${Environment.apiUrl}/citas/delete/${cita.id}' );
      await http.delete(url);
      citasDia.remove(cita);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> registrarCita( Cita cita ) async {
    try {
      registrando = true;

      final url = Uri.parse( '${Environment.apiUrl}/citas/new' );
      final resp = await http.post( url,
        body: jsonEncode(cita.toJson()),
        headers: { 'Content-Type': 'application/json'}
      );
      registrando = false;

      if ( resp.statusCode == 200 ) {
        return true;
      } else {
        final respBody = jsonDecode(resp.body);
        return respBody['msg'] ?? respBody['ok'];
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarCita( Cita cita ) async {
    try {
      registrando = true;
      
      final url = Uri.parse('${Environment.apiUrl}/citas/actualiza/${cita.id}');
      final resp = await http.put(url, body: jsonEncode(cita.toJson()), headers: {'Content-Type': 'application/json', 'x-token': await AutenticacionProvider.getToken()});
      
      registrando = false;
      
      return (resp.statusCode == 200) ? true : false;
    } catch (e) {
      return false;
    }
  }
}
