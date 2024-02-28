
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:clinica_dental_app/config/global/environment.dart';
import 'package:clinica_dental_app/domain/response/response.dart';
import 'package:clinica_dental_app/domain/entities/usuario.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';

class DropDownUsuariosProvider extends ChangeNotifier {
  List<Usuario> listaUsuario = [];
  Usuario? usuarioSeleccionado;

  DropDownUsuariosProvider() {
    getUsuarios();
  }

  Future<dynamic> getUsuarios() async {
    try {
      final url = Uri.parse( '${Environment.apiUrl}/login/usuarios' );
      final res = await http.get(url,  
        headers: { 'Content-Type': 'application/json', 'x-token': await AutenticacionProvider.getToken() }
      );
      final administracionResponse = administracionResponseFromJson( res.body );
      listaUsuario = administracionResponse.usuarios;
      notifyListeners();
    } catch (e) {
      return [];
    }
  }

  

}
