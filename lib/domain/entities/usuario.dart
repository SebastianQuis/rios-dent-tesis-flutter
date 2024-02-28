
import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {

  final String rol;
  final String nombre;
  final String apellido;
  final String dni;
  final String email;
  String? password;
  bool? online;
  bool? disponible;
  String? uid;
  

  Usuario({
    required this.rol, 
    required this.nombre, 
    required this.apellido, 
    required this.dni, 
    required this.email,
    this.disponible = true,
    this.password,
    this.online = false,
    this.uid
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        rol: json["rol"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        dni: json["dni"], 
        email: json["email"],
        disponible: json["disponible"],
        password: json["password"],
        online: json["online"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "rol": rol,
        "nombre": nombre,
        "apellido": apellido,
        "dni": dni,
        "email": email,
        "disponible": disponible,
        "password": password,
        "online": online,
        "uid": uid,
    };


}