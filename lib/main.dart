import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:clinica_dental_app/config/preferences/preferences.dart';
import 'package:clinica_dental_app/config/routes/app_routes.dart';
import 'package:clinica_dental_app/config/services/services.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';

void main() async {
  initializeDateFormatting().then( (_) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Preferences.init();
    return runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeService(esModoOscuro: Preferences.esModoOscuro)),
          ChangeNotifierProvider(create: (context) => SocketProvider()),
          ChangeNotifierProvider(create: (context) => AutenticacionProvider()),
          ChangeNotifierProvider(create: (context) => NavigationService()),
          ChangeNotifierProvider(create: (context) => PacienteProvider()),
          ChangeNotifierProvider(create: (context) => AdministracionProvider()),
          ChangeNotifierProvider(create: (context) => HistorialProvider()),
          ChangeNotifierProvider(create: (context) => DropDownUsuariosProvider()),
          ChangeNotifierProvider(create: (context) => CitaProvider()),
        ],
        child: const MyApp()
      )
    );
  });
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clínica Dental Tesis App',
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.getAppRoutes(),
      initialRoute: AppRoutes.initialRoute,
      theme: Provider.of<ThemeService>(context).themeData
    );
  }
}