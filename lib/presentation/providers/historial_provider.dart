import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:clinica_dental_app/config/global/environment.dart';
import 'package:clinica_dental_app/domain/entities/cita.dart';
import 'package:clinica_dental_app/domain/response/cita_response.dart';

class HistorialProvider extends ChangeNotifier {

  Future<List<Cita>> buscarCitas( String query ) async {
    try {
      final url = Uri.parse( '${Environment.apiUrl}/citas/search/$query' );
      final resp = await http.get(url);
      final searchRespuesta = citaResponseFromJson(resp.body);
      return searchRespuesta.cita;
    } catch (e) {
      return [];
    }    
  }
}