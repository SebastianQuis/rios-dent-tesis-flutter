// To parse this JSON data, do
//
//     final citasMesResponse = citasMesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:clinica_dental_app/domain/entities/citas_mes.dart';

CitasMesResponse citasMesResponseFromJson(String str) => CitasMesResponse.fromJson(json.decode(str));

String citasMesResponseToJson(CitasMesResponse data) => json.encode(data.toJson());

class CitasMesResponse {
    final bool ok;
    final List<CitasMes> result;

    CitasMesResponse({
        required this.ok,
        required this.result,
    });

    factory CitasMesResponse.fromJson(Map<String, dynamic> json) => CitasMesResponse(
        ok: json["ok"],
        result: List<CitasMes>.from(json["result"].map((x) => CitasMes.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}