// To parse this JSON data, do
//
//     final citaResponse = citaResponseFromJson(jsonString);

import 'dart:convert';

import 'package:clinica_dental_app/domain/entities/cita.dart';

CitaResponse citaResponseFromJson(String str) => CitaResponse.fromJson(json.decode(str));

String citaResponseToJson(CitaResponse data) => json.encode(data.toJson());

class CitaResponse {
    final bool ok;
    final List<Cita> cita;

    CitaResponse({
      required this.ok,
      required this.cita,
    });

    factory CitaResponse.fromJson(Map<String, dynamic> json) => CitaResponse(
      ok: json["ok"],
      cita: List<Cita>.from(json["cita"].map((x) => Cita.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
      "ok": ok,
      "cita": List<dynamic>.from(cita.map((x) => x.toJson())),
    };
}


