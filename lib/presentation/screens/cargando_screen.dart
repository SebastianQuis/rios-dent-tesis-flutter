import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clinica_dental_app/presentation/providers/cita_provider.dart';
import 'package:clinica_dental_app/presentation/screens/screens.dart';
import 'package:clinica_dental_app/presentation/providers/autenticacion_provider.dart';
import 'package:clinica_dental_app/presentation/providers/socket_provider.dart';
 
class CargandoScreen extends StatelessWidget {
  static String nombre = 'cargando';
  const CargandoScreen({super.key});  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          return const Center(
            child: CircularProgressIndicator.adaptive()
          );
        },
        future: checkLoginState(context),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authProvider = Provider.of<AutenticacionProvider>(context,listen: false);
    final citaProvider = Provider.of<CitaProvider>(context,listen: false);
    final autenticado = await authProvider.isLogged();

    // ignore: use_build_context_synchronously
    final socketProvider = Provider.of<SocketProvider>(context,listen: false);

    if (autenticado) {
      socketProvider.connect();

      if (authProvider.usuario.rol == 'Administrador') {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, 
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const SeleccionarDoctorScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 1000)
            )
          );
      } else {
        await citaProvider.initCitas('${authProvider.usuario.nombre} ${authProvider.usuario.apellido}');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, 
            PageRouteBuilder(
              pageBuilder: (BuildContext context, __, ___)  {
                return const TabsScreen();
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);

                return FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 1000)
            )
          );
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
            return FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000)
        )
      );
    }
  }
}