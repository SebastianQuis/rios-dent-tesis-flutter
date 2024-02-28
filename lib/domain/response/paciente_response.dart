// To parse this JSON data, do
//
//     final pacienteResponse = pacienteResponseFromJson(jsonString);

import 'dart:convert';

import 'package:clinica_dental_app/domain/entities/paciente.dart';

PacienteResponse pacienteResponseFromJson(String str) => PacienteResponse.fromJson(json.decode(str));

String pacienteResponseToJson(PacienteResponse data) => json.encode(data.toJson());

class PacienteResponse {
    final bool ok;
    final List<Paciente> pacientes;

    PacienteResponse({
        required this.ok,
        required this.pacientes,
    });

    factory PacienteResponse.fromJson(Map<String, dynamic> json) => PacienteResponse(
        ok: json["ok"],
        pacientes: List<Paciente>.from(json["pacientes"].map((x) => Paciente.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "pacientes": List<dynamic>.from(pacientes.map((x) => x.toJson())),
    };
}

