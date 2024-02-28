import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:clinica_dental_app/domain/response/login_response.dart';
import 'package:clinica_dental_app/domain/entities/usuario.dart';
import 'package:clinica_dental_app/config/global/environment.dart';

class AutenticacionProvider with ChangeNotifier {
  
  final _storage = const FlutterSecureStorage();

  late Usuario usuario;  
  Usuario get getUsuario => usuario;

  bool _autenticando = false;
  bool get autenticando => _autenticando;
  set autenticando( bool valor ) {
    _autenticando = valor;
    notifyListeners();
  }
  
  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String rol, String email, String password) async {
    autenticando = true;
    
    final data = {
      'rol': rol,
      'email' : email,
      'password' : password
    };

    final url = Uri.parse('${Environment.apiUrl}/login');
    final resp = await http.post(url,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json'
        }
    );

    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> registrarUsuario( Usuario usuario ) async {
    try {
      autenticando = true;

      final url = Uri.parse( '${Environment.apiUrl}/login/new' );
      final resp = await http.post( url,
        body: jsonEncode(usuario.toJson()),
        headers: {
          'Content-Type': 'application/json'
        }
      );

      autenticando = false;

      if ( resp.statusCode == 200 ) {
        return true;
      } else {
        final respBody = jsonDecode(resp.body);
        return respBody['message'] ?? respBody['ok'];
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLogged() async {
    final token = await _storage.read(key: 'token');

    final url = Uri.parse('${Environment.apiUrl}/login/renew');
    final resp = await http.get(url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? 'no token'
      }
    );

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken( String token ) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }


}