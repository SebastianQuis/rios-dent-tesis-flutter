
// To parse this JSON data, do
//
//     final paciente = pacienteFromJson(jsonString);

import 'dart:convert';

Paciente pacienteFromJson(String str) => Paciente.fromJson(json.decode(str));

String pacienteToJson(Paciente data) => json.encode(data.toJson());

class Paciente {
    String nombres;
    String apellidos;
    String telefono;
    String? genero;
    String dni;
    DateTime? nacimiento;
    String? edad;
    String tratamiento;
    String odontologo;
    bool? activo;
    String? uid;

    Paciente({
        required this.nombres,
        required this.apellidos,
        required this.telefono,
        this.genero,
        required this.dni,
        this.nacimiento,
        this.edad,
        required this.tratamiento,
        required this.odontologo,
        this.activo = true,
        this.uid,
    });

    factory Paciente.fromJson(Map<String, dynamic> json) => Paciente(
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        telefono: json["telefono"],
        genero: json["genero"],
        dni: json["dni"],
        nacimiento: DateTime.parse(json["nacimiento"]),
        edad: json["edad"],
        tratamiento: json["tratamiento"],
        odontologo: json["odontologo"],
        activo: json["activo"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "nombres": nombres,
        "apellidos": apellidos,
        "telefono": telefono,
        "genero": genero,
        "dni": dni,
        "nacimiento": nacimiento!.toIso8601String(),
        "edad": edad,
        "tratamiento": tratamiento,
        "odontologo": odontologo,
        "activo": activo,
        "uid": uid,
    };
}


