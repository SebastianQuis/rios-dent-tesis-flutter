import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clinica_dental_app/config/theme/app_theme.dart';
import 'package:clinica_dental_app/config/preferences/preferences.dart';
import 'package:clinica_dental_app/config/services/services.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/widgets/widgets.dart';
import 'package:clinica_dental_app/presentation/screens/screens.dart';
 
class AjustesScreen extends StatefulWidget {
  static String nombre = 'Ajustes';
  const AjustesScreen({super.key});  

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    final dropdownProvider = Provider.of<DropDownUsuariosProvider>(context);

    return Scaffold(
      
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: 'Ajustes', weight: FontWeight.bold, fontSize: 20, paddingVertical: 10, color: Preferences.esModoOscuro ? Colors.white : Colors.black87,),
        
            SwitchListTile(
              value: Preferences.esModoOscuro,
              onChanged: (value) {
                Preferences.esModoOscuro = value;
                final themeService = Provider.of<ThemeService>(context, listen: false);
                setState(() {
                  ( value == true ) ? themeService.setDarkMode() : themeService.setLightMode();
                });
              },
              activeColor: AppTheme.color2,
              title: const Text('Modo oscuro'),
            ),
        
            ButtonPersonal(
              key: UniqueKey(),
              onPressed: (){
                socketProvider.disconnect();
                Navigator.pushReplacementNamed(context, LoginScreen.nombre);
                dropdownProvider.usuarioSeleccionado = null;
                AutenticacionProvider.deleteToken();
              },
              text: 'Cerrar sesión'
            ),
        
          ],
        )
      )
    );
  }
}