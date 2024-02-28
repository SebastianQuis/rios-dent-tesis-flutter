// To parse this JSON data, do
//
//     final administracionResponse = administracionResponseFromJson(jsonString);

import 'dart:convert';

import 'package:clinica_dental_app/domain/entities/usuario.dart';

AdministracionResponse administracionResponseFromJson(String str) => AdministracionResponse.fromJson(json.decode(str));

String administracionResponseToJson(AdministracionResponse data) => json.encode(data.toJson());

class AdministracionResponse {
    final bool ok;
    final List<Usuario> usuarios;

    AdministracionResponse({
        required this.ok,
        required this.usuarios,
    });

    factory AdministracionResponse.fromJson(Map<String, dynamic> json) => AdministracionResponse(
        ok: json["ok"],
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}
