import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clinica_dental_app/config/services/navigation_service.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/screens/screens.dart';

class TabsScreen extends StatelessWidget {
  static String nombre = 'tabs';
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    final navigationService = Provider.of<NavigationService>(context);
    final authProvider = Provider.of<AutenticacionProvider>(context);
    
    final screens = [
      const CitaScreen(), 
      const PacienteScreen(), 
      const HistorialScreen(), 
      if (authProvider.usuario.rol == 'Administrador') const AdministracionScreen(), 
      const AjustesScreen()
    ];

    return Scaffold(
      body: socketProvider.socket.connected
        ? IndexedStack(
            index: navigationService.paginaActual,
            children: screens)
        : const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hablar con Administrador'),
              SizedBox(height: 20,),
              CircularProgressIndicator.adaptive()
            ],
          )
        ),
    
      bottomNavigationBar: socketProvider.socket.connected 
        ? BottomNavigationBar(
          currentIndex: navigationService.paginaActual,
          onTap: (value) {
            navigationService.paginaActual = value;
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              activeIcon: const Icon(Icons.calendar_month_rounded),
              label: CitaScreen.nombre,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_2_outlined),
              activeIcon: const Icon(Icons.person_2_rounded),
              label: PacienteScreen.nombre,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_ind_outlined),
              activeIcon: const Icon(Icons.assignment_ind_rounded),
              label: HistorialScreen.nombre,
            ),
            if (authProvider.usuario.rol == 'Administrador') 
              BottomNavigationBarItem(
                icon: const Icon(Icons.admin_panel_settings_outlined),
                activeIcon: const Icon(Icons.admin_panel_settings_rounded),
                label: AdministracionScreen.nombre,
              ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings_rounded),
              label: AjustesScreen.nombre,
            ),
          ])
        : null,
    );
  }
}