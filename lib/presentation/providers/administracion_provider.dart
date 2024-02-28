import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:clinica_dental_app/config/global/environment.dart';
import 'package:clinica_dental_app/domain/response/administracion_response.dart';
import 'package:clinica_dental_app/domain/entities/usuario.dart';
import 'package:clinica_dental_app/presentation/providers/autenticacion_provider.dart';

class AdministracionProvider with ChangeNotifier{
  List<Usuario> usuarios = [];

  bool _actualizando = false;

  bool get actualizando => _actualizando;
  set actualizando( bool value ){ 
    _actualizando = value;
    notifyListeners();
  }

  Future<List<Usuario>> getUsuarios() async {
    try {
      final url = Uri.parse( '${Environment.apiUrl}/login/usuarios' );
      final res = await http.get(url,  
        headers: { 'Content-Type': 'application/json', 'x-token': await AutenticacionProvider.getToken() }
      );
      final administracionResponse = administracionResponseFromJson( res.body );
      usuarios = administracionResponse.usuarios;
      return usuarios;
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteUsuario(Usuario usuario) async {
    try {
      final url = Uri.parse( '${Environment.apiUrl}/login/delete/${usuario.uid}' );
      await http.delete(url);
      usuarios.remove(usuario);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarPaciente( Usuario usuario ) async {
    try {
      actualizando = true;
      
      final url = Uri.parse('${Environment.apiUrl}/login/usuario/actualiza/${usuario.uid}');
      final resp = await http.put(url, body: jsonEncode(usuario.toJson()), headers: {'Content-Type': 'application/json', 'x-token': await AutenticacionProvider.getToken()});
      
      actualizando = false;
      
      return (resp.statusCode == 200) ? true : false;
    } catch (e) {
      return false;
    }
  }
}