import 'package:flutter/material.dart';
 
import 'package:provider/provider.dart';

import 'package:clinica_dental_app/config/preferences/preferences.dart';
import 'package:clinica_dental_app/config/theme/app_theme.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/dialog/mostrar_alerta.dart';
import 'package:clinica_dental_app/presentation/screens/screens.dart';
import 'package:clinica_dental_app/presentation/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static String nombre = 'login';
  const LoginScreen({super.key});  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              const ImageBackground(),
        
              TitleText(fontSize: 22, title: 'Inicia sesión', color: Preferences.esModoOscuro ? Colors.white : Colors.black87, weight: FontWeight.bold, paddingVertical: 0,),
        
              _Form(),

              const SizedBox(height: 20,)
        
            ],
          ),
        ),
      )
    
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emaiController     = TextEditingController();
  final passwordController = TextEditingController();
  String _rol              = 'Administrador';

  @override
  void dispose() {
    emaiController.dispose();
    passwordController.dispose();
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    final autenticacionProvider = Provider.of<AutenticacionProvider>(context);
    final dropDownUsuariosProvider = Provider.of<DropDownUsuariosProvider>(context);
    final citaProvider = Provider.of<CitaProvider>(context);
    final socketProvider = Provider.of<SocketProvider>(context);

    final underlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        TitleText(title: 'Usuario', color: Preferences.esModoOscuro ? Colors.white : AppTheme.color2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.admin_panel_settings_outlined, color: AppTheme.color4,),
              focusedBorder: underlineInputBorder,
              enabledBorder: underlineInputBorder,
              fillColor: Colors.grey[300],
              filled: true,
            ),
            style: const TextStyle(color: Colors.black87),
            dropdownColor: Colors.white,
            value: _rol,
            items: const [
              DropdownMenuItem(value: 'Administrador', child: Text('Administrador')),
              DropdownMenuItem(value: 'Odontologo', child: Text('Odontologo')),
            ],
            onChanged: (value) {
              setState(() {
                _rol = value!;
              });
            },
          ),
        ),
        
        TitleText(title: 'Correo electrónico',  color: Preferences.esModoOscuro ? Colors.white : AppTheme.color2),
        InputForm(
          icon: const Icon(Icons.email_outlined, color: AppTheme.color4,),
          keyboardType: TextInputType.emailAddress,
          textController: emaiController,
          hintText: 'example@gmail.com',
        ),

        TitleText(title: 'Contraseña',  color: Preferences.esModoOscuro ? Colors.white : AppTheme.color2),
        InputForm(
          icon: const Icon(Icons.security_outlined, color: AppTheme.color4,),
          isPassword: true,
          textController: passwordController,
          hintText: '*********',
        ),

        const SizedBox(height: 20,),
        Center(
          child: ButtonPersonal(
            key: UniqueKey(),
            onPressed: autenticacionProvider.autenticando 
                ? null
                : () async {
                  FocusScope.of(context).unfocus();
                  final loginStatus = await autenticacionProvider.login( _rol, emaiController.text, passwordController.text );
                  if (loginStatus == true) {
                    if (_rol == 'Administrador') {
                      await dropDownUsuariosProvider.getUsuarios();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, SeleccionarDoctorScreen.nombre);
                    } else {
                      await citaProvider.initCitas('${autenticacionProvider.usuario.nombre} ${autenticacionProvider.usuario.apellido}');
                      socketProvider.connect();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, TabsScreen.nombre);
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    mostrarAlerta(context, 'Verificar sus credenciales de ingreso.'); 
                  }
                
                },
            text: 'Ingresar',
          ),
        )

      ],
    );
  }
}

