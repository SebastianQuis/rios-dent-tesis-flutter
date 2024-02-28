// To parse this JSON data, do
//
//     final cita = citaFromJson(jsonString);

import 'dart:convert';

Cita citaFromJson(String str) => Cita.fromJson(json.decode(str));

String citaToJson(Cita data) => json.encode(data.toJson());

class Cita {
    String? id;
    String? paciente;
    final String odontologo;
    String? horaInicial;
    String? horaFinal;
    String? nota;
    String? fecha;
    String? telefono;
    bool? atendida;

    Cita({
        this.id,
        this.paciente,
        required this.odontologo,
        this.horaInicial,
        this.horaFinal,
        this.nota,
        this.fecha,
        this.telefono,
        this.atendida = false
    });

    factory Cita.fromJson(Map<String, dynamic> json) => Cita(
        id: json["_id"],
        paciente: json["paciente"],
        odontologo: json["odontologo"],
        horaInicial: json["horaInicial"],
        horaFinal: json["horaFinal"],
        nota: json["nota"],
        fecha: json["fecha"],
        telefono: json["telefono"],
        atendida: json["atendida"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "paciente": paciente,
        "odontologo": odontologo,
        "horaInicial": horaInicial,
        "horaFinal": horaFinal,
        "nota": nota,
        "fecha": fecha,
        "telefono": telefono,
        "atendida": atendida,
    };
}
