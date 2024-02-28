import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clinica_dental_app/config/preferences/preferences.dart';
import 'package:clinica_dental_app/config/theme/app_theme.dart';
import 'package:clinica_dental_app/domain/entities/usuario.dart';
import 'package:clinica_dental_app/presentation/dialog/mostrar_alerta.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/screens/tabs_screen.dart';
import 'package:clinica_dental_app/presentation/widgets/widgets.dart';
 
class SeleccionarDoctorScreen extends StatelessWidget {
  static String nombre = 'seleccionarDoctor';
  const SeleccionarDoctorScreen({super.key});  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    
            const ImageBackground(),
            
            TitleText(title: 'Elija al odontológo', fontSize: 22, weight: FontWeight.bold, color: Preferences.esModoOscuro ? Colors.white : Colors.black87,),
    
            TitleText(title: 'Para visualizar la gestión de un médico, seleccione a uno', color: Preferences.esModoOscuro ? Colors.white : Colors.black87,),
    
            TitleText(title: 'Odontologos', color: Preferences.esModoOscuro? Colors.white : AppTheme.color2),
    
            const DropDownOdontologos(),
    
          ],
        ),
      ),
    );
  }
}

class DropDownOdontologos extends StatefulWidget {
  const DropDownOdontologos({super.key});

  @override
  State<DropDownOdontologos> createState() => _DropDownOdontologosState();
}

class _DropDownOdontologosState extends State<DropDownOdontologos> {

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropDownUsuariosProvider>(context);
    final citaProvider = Provider.of<CitaProvider>(context);
    final socketProvider = Provider.of<SocketProvider>(context);
    final listUsers = dropdownProvider.listaUsuario;
    Usuario? _usuario;

    final underlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10 ),
      child: Column(
        children: [

          DropdownButtonFormField(
            decoration: _dropDownDecoration(underlineInputBorder),
            items: listUsers.map((usuario) => DropdownMenuItem<Usuario>(
              value: usuario, 
              child: Text('${usuario.nombre} ${usuario.apellido}'))
            ).toList(),
            onChanged: (value) {
              _usuario = value;
              setState(() {
                dropdownProvider.usuarioSeleccionado = _usuario!;
              });
            },
          ),
          
          const SizedBox(height: 30,),

          ButtonPersonal(
            key: UniqueKey(),
            onPressed: () async {
              // print(dropdownProvider.usuarioSeleccionado);
              if (dropdownProvider.usuarioSeleccionado == null) {
                mostrarAlerta(context, 'Debe elegir obligatoriamente a un odontologo');
              } else {
                socketProvider.connect();
                await citaProvider.initCitas('${dropdownProvider.usuarioSeleccionado!.nombre} ${dropdownProvider.usuarioSeleccionado!.apellido}');
                Navigator.pushReplacementNamed(context, TabsScreen.nombre);
              }

              // (dropdownProvider.usuarioSeleccionado == null)
              //   ? mostrarAlerta(context, 'Debe elegir obligatoriamente a un odontologo')
              //   : Navigator.pushReplacementNamed(context, TabsScreen.nombre);
            },
            text: 'Ingresar'
          ),
        ],
      ),
    );
  }

  InputDecoration _dropDownDecoration(UnderlineInputBorder underlineInputBorder) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.person_pin_circle_outlined, color: AppTheme.color4,),
      focusedBorder: underlineInputBorder,
      enabledBorder: underlineInputBorder,
      fillColor: Preferences.esModoOscuro ? Colors.black38 : Colors.grey[300],
      filled: true,
    );
  }
}