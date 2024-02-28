import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clinica_dental_app/config/theme/app_theme.dart';
import 'package:clinica_dental_app/domain/entities/usuario.dart';
import 'package:clinica_dental_app/presentation/dialog/mostrar_alerta.dart';
import 'package:clinica_dental_app/presentation/helpers/helpers.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/screens/screens.dart';
import 'package:clinica_dental_app/presentation/widgets/widgets.dart';
 
class UsuarioNuevoScreen extends StatelessWidget {
  static String nombre = 'usuarioNuevo';

  const UsuarioNuevoScreen({super.key});  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _Form()
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final nombreController   = TextEditingController();
  final apellidoController = TextEditingController();
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final dniController      = TextEditingController();
  String _rol              = 'Odontologo';

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    dniController.dispose();
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    final autenticacionProvider = Provider.of<AutenticacionProvider>(context);
    final dropDownUsuariosProvider = Provider.of<DropDownUsuariosProvider>(context);

    final underlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    );

    return Container(
      padding: const EdgeInsetsDirectional.all( 10 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const TitleText(title: 'Crear usuario', fontSize: 22, weight: FontWeight.w600,),

          Container(
            padding: const EdgeInsetsDirectional.symmetric( horizontal: 10, vertical: 5),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.radio_button_checked_outlined, color: AppTheme.color4,),
                focusedBorder: underlineInputBorder,
                enabledBorder: underlineInputBorder,
                fillColor: Colors.grey[300],
                filled: true,
              ),
              value: _rol,
              items: const [
                DropdownMenuItem(value: 'Odontologo', child: Text('Odontologo')),
                DropdownMenuItem(value: 'Administrador', child: Text('Administrador')),
              ],
              onChanged: (value) {
                setState(() {
                  _rol = value!;
                });
              },
            ),
          ),

          InputForm(
            vertical: 5,
            hintText: 'Nombre',
            textController: nombreController,
            icon: const Icon(Icons.person_4_rounded, color: AppTheme.color4),
          ),
          
          InputForm(
            vertical: 5,
            hintText: 'Apellidos',
            textController: apellidoController,
            icon: const Icon(Icons.person_pin_rounded, color: AppTheme.color4),
          ),
          
          InputForm(
            vertical: 5,
            hintText: 'DNI',
            textController: dniController,
            keyboardType: TextInputType.number,
            icon: const Icon(Icons.edit_document, color: AppTheme.color4),
          ),
          
          InputForm(
            vertical: 5,
            hintText: 'Correo electrónico',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
            icon: const Icon(Icons.email_rounded, color: AppTheme.color4),
          ),
          
          InputForm(
            vertical: 5,
            hintText: 'Contraseña',
            textController: passwordController,
            isPassword: true,
            icon: const Icon(Icons.lock_rounded, color: AppTheme.color4),
          ),

          ButtonPersonal(
            key: UniqueKey(),
            onPressed: autenticacionProvider.autenticando
              ? null
              : () async {
                final usuario = Usuario(
                  rol: _rol, 
                  nombre: capitalizarPalabra(nombreController.text), 
                  apellido: capitalizarPalabra(apellidoController.text),
                  dni: dniController.text, 
                  email: emailController.text, 
                  password: passwordController.text
                );

                FocusScope.of(context).unfocus();
                await dropDownUsuariosProvider.getUsuarios();
                final resp = await autenticacionProvider.registrarUsuario(usuario);
                if (resp == true) {
                  mostrarAlerta(context, 'Se agregó correctamente al ${_rol}');
                  nombreController.clear();
                  apellidoController.clear();
                  emailController.clear();
                  passwordController.clear();
                  dniController.clear();
                  // await dropDownUsuarioProvider.getUsuarios();
                } else if ( resp == false ) {
                  mostrarAlerta(context, 'Registro incorrecto');
                } else {
                  mostrarAlerta(context, '${resp}');
                }
            }, 
            text: 'Agregar'
          ),
          
          ButtonPersonal(
            key: UniqueKey(),
            onPressed: () => Navigator.pushReplacementNamed(context, TabsScreen.nombre), 
            text: 'Cancelar',
            color: Colors.grey,
          ),

        ],
      ),
    );
  }
}