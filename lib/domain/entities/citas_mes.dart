// To parse this JSON data, do
//
//     final citasMes = citasMesFromJson(jsonString);

import 'dart:convert';

CitasMes citasMesFromJson(String str) => CitasMes.fromJson(json.decode(str));

String citasMesToJson(CitasMes data) => json.encode(data.toJson());

class CitasMes {
    final String fecha;
    final int cantidad;
    final String odontologo;

    CitasMes({
        required this.fecha,
        required this.cantidad,
        required this.odontologo,
    });

    factory CitasMes.fromJson(Map<String, dynamic> json) => CitasMes(
        fecha: json["fecha"],
        cantidad: json["cantidad"],
        odontologo: json["odontologo"],
    );

    Map<String, dynamic> toJson() => {
        "fecha": fecha,
        "cantidad": cantidad,
        "odontologo": odontologo,
    };
}
