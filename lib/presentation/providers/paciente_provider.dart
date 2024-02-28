
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:clinica_dental_app/config/global/environment.dart';
import 'package:clinica_dental_app/domain/response/paciente_response.dart';
import 'package:clinica_dental_app/domain/entities/paciente.dart';
import 'package:clinica_dental_app/presentation/providers/autenticacion_provider.dart';

class PacienteProvider extends ChangeNotifier {

  List<Paciente> pacientes = [];
  Paciente? pacienteSeleccionado;

  bool _autenticando = false;
  bool get autenticando => _autenticando;
  set autenticando( bool valor ) {
    _autenticando = valor;
    notifyListeners();
  }

  bool _actualizando = false;
  bool get actualizando => _actualizando;
  set actualizando(bool value ) {
    _actualizando = value;
    notifyListeners();
  }

  DateTime _dateTime = DateTime.now();
  DateTime get dateTime => _dateTime;
  set dateTime( DateTime date ) {
    _dateTime = date;
    notifyListeners();
  }

  Future<dynamic> registrarPaciente( Paciente paciente ) async {
    try {
      autenticando = true;

      final url = Uri.parse( '${Environment.apiUrl}/paciente/new' );
      final resp = await http.post( url,
        body: jsonEncode(paciente.toJson()),
        headers: {
          'Content-Type': 'application/json'
        }
      );
      autenticando = false;

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

  Future<List<Paciente>> obtenerPacientes() async {
    try {
      final url = Uri.parse( '${Environment.apiUrl}/paciente/pacientes' );
      final res = await http.get(url,  
        headers: { 'Content-Type': 'application/json', 'x-token': await AutenticacionProvider.getToken() }
      );
      final pacienteResponse = pacienteResponseFromJson( res.body );
      pacientes = pacienteResponse.pacientes;
      return pacientes;
    } catch (e) {
      return [];
    }
  }

  Future<bool> actualizarEstado({ required String uid, required bool active}) async {
    try {
      actualizando = true;

      final data = {
        "activo": active
      };

      final url = Uri.parse('${Environment.apiUrl}/paciente/actualiza/$uid');
      final resp = await http.put(url, body: jsonEncode(data), headers: {'Content-Type': 'application/json', 'x-token': await AutenticacionProvider.getToken()});

      actualizando = false;

      return (resp.statusCode == 200) ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarPaciente( Paciente paciente ) async {
    try {
      actualizando = true;
      
      final url = Uri.parse('${Environment.apiUrl}/paciente/actualiza/${paciente.uid}');
      final resp = await http.put(url, body: jsonEncode(paciente.toJson()), headers: {'Content-Type': 'application/json', 'x-token': await AutenticacionProvider.getToken()});
      
      actualizando = false;
      
      return (resp.statusCode == 200) ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Paciente>> buscarPaciente( String query ) async {
    try {
      final url = Uri.parse( '${Environment.apiUrl}/paciente/search/$query' );
      final resp = await http.get(url);
      final searchRespuesta = pacienteResponseFromJson(resp.body);
      return searchRespuesta.pacientes;
    } catch (e) {
      return [];
    }    
  }

}

