import 'package:flutter/material.dart';

import 'package:clinica_dental_app/presentation/screens/screens.dart';

class AppRoutes {

  static String initialRoute = CargandoScreen.nombre;

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {

    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes.addAll( { CargandoScreen.nombre         : ( _ ) => const CargandoScreen()} );
    appRoutes.addAll( { LoginScreen.nombre            : ( _ ) => const LoginScreen()} ); 
    appRoutes.addAll( { SeleccionarDoctorScreen.nombre: ( _ ) => const SeleccionarDoctorScreen()} ); 
    appRoutes.addAll( { TabsScreen.nombre             : ( _ ) => const TabsScreen()} );
    appRoutes.addAll( { CitaScreen.nombre             : ( _ ) => const CitaScreen()} );
    appRoutes.addAll( { CitaNuevaScreen.nombre        : ( _ ) => const CitaNuevaScreen()} );
    appRoutes.addAll( { PacienteScreen.nombre         : ( _ ) => const PacienteScreen()} );
    appRoutes.addAll( { PacienteNuevoScreen.nombre    : ( _ ) => const PacienteNuevoScreen()} );
    appRoutes.addAll( { AdministracionScreen.nombre   : ( _ ) => const AdministracionScreen()} );
    appRoutes.addAll( { UsuarioNuevoScreen.nombre     : ( _ ) => const UsuarioNuevoScreen()} );
    appRoutes.addAll( { HistorialScreen.nombre        : ( _ ) => const HistorialScreen()} );
    appRoutes.addAll( { AjustesScreen.nombre          : ( _ ) => const AjustesScreen()} );

    return appRoutes;
  }
}