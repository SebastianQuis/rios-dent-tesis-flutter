// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clinica_dental_app/config/theme/app_theme.dart';
import 'package:clinica_dental_app/domain/entities/paciente.dart';
import 'package:clinica_dental_app/presentation/helpers/helpers.dart';
import 'package:clinica_dental_app/presentation/dialog/mostrar_alerta.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/screens/tabs_screen.dart';
import 'package:clinica_dental_app/presentation/widgets/widgets.dart';
 
class PacienteNuevoScreen extends StatelessWidget {
  static String nombre = 'pacienteNuevo';
  const PacienteNuevoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pacienteProvider = Provider.of<PacienteProvider>(context);

    return ChangeNotifierProvider(
      create: (context) => PacienteFormProvider(pacienteProvider.pacienteSeleccionado!),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                  child: const TitleText(title: 'Datos personales', weight: FontWeight.w700, fontSize: 22,)),
          
                _Formulario(),
          
              ],
            ),
          ),
        )
      ),
    );
  }
}

class _Formulario extends StatefulWidget {
  
  @override
  State<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<_Formulario> {
  @override
  Widget build(BuildContext context) {
    final pacienteProvider = Provider.of<PacienteProvider>(context);
    final autenticacionProvider = Provider.of<AutenticacionProvider>(context);
    final pacienteFormProvider = Provider.of<PacienteFormProvider>(context);
    final paciente = pacienteFormProvider.paciente;

    final underlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10),
    );

    Future<DateTime?> pickDate() => showDatePicker( context: context,
      initialDate: paciente.nacimiento!,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 10),
      child: Form(
        key: pacienteFormProvider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            InputForm(
              icon: const Icon(Icons.person_rounded, color: AppTheme.color4,), 
              hintText: 'Nombre',
              vertical: 5,
              initialValue: paciente.nombres,
              onChanged: (value) => paciente.nombres = value,
            ),
      
            InputForm(
              icon: const Icon(Icons.person_pin_circle_rounded, color: AppTheme.color4,), 
              hintText: 'Apellido', 
              vertical: 5,
              initialValue: paciente.apellidos,
              onChanged: (value) => paciente.apellidos = value,
            ),
      
            InputForm(
              icon: const Icon(Icons.phone_rounded, color: AppTheme.color4,), 
              hintText: 'Telefono', 
              keyboardType: TextInputType.number,
              vertical: 5,
              initialValue: paciente.telefono,
              onChanged: (value) => paciente.telefono = value,
            ),
      
            Container(
              padding: const EdgeInsetsDirectional.symmetric( horizontal: 10, vertical: 5),
              child: DropdownButtonFormField(
                decoration: _inputDecoration(underlineInputBorder),
                value: paciente.genero,
                items: const [
                  DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                ],
                onChanged: (value) {
                  setState(() {
                    paciente.genero = value;
                  });
                },
              ),
            ),
          
            InputForm(
              icon: const Icon(Icons.edit_document, color: AppTheme.color4,), 
              hintText: 'Número de documento', 
              vertical: 5,
              keyboardType: TextInputType.number,
              initialValue: paciente.dni,
              onChanged: (value) => paciente.dni = value,
            ),
            
            InputForm(
              vertical: 5,
              isTextForm: false,
              title: '${paciente.nacimiento!.day}/${paciente.nacimiento!.month}/${paciente.nacimiento!.year}',
              icon: IconButton(
                splashColor: Colors.transparent,
                onPressed: () async {
                  DateTime? date = await pickDate();
                  if ( date == null ) return;
                  final newDate = DateTime(date.year, date.month, date.day);

                  pacienteFormProvider.actualizarNacimiento(newDate);
                  setState(() {});
                }, 
                icon: const Icon(Icons.calendar_month, color: AppTheme.color4,),
              ), 
            ),
      
            const TitleText(title: 'Tratamiento', fontSize: 18 ),
      
            InputForm(
              icon: const Icon(Icons.note_add_rounded, color: AppTheme.color4,), 
              hintText: 'Tratamiento',
              vertical: 5,
              initialValue: paciente.tratamiento,
              onChanged: (value) => paciente.tratamiento = value,
            ),
      
            ButtonPersonal(
              key: UniqueKey(),
              onPressed: pacienteProvider.autenticando
                ? null
                : () async {
                  if( !pacienteFormProvider.esValidoFormulario()) return;

                  final odontologo = autenticacionProvider.usuario;
                  final newPaciente = Paciente(
                    nombres: capitalizarPalabra(paciente.nombres),
                    apellidos: capitalizarPalabra(paciente.apellidos),
                    telefono: paciente.telefono,
                    genero: paciente.genero,
                    dni: paciente.dni,
                    nacimiento: DateTime(paciente.nacimiento!.year, paciente.nacimiento!.month, paciente.nacimiento!.day),
                    tratamiento: capitalizarPalabra(paciente.tratamiento),
                    odontologo: '${odontologo.nombre} ${odontologo.apellido}'
                  );

                  final pacienteUpdated = Paciente(
                    uid: paciente.uid,
                    nombres: capitalizarPalabra(paciente.nombres),
                    apellidos: capitalizarPalabra(paciente.apellidos),
                    telefono: paciente.telefono,
                    genero: paciente.genero,
                    dni: paciente.dni,
                    nacimiento: paciente.nacimiento,
                    edad: hallarEdad(paciente.nacimiento!),
                    tratamiento: capitalizarPalabra(paciente.tratamiento),
                    odontologo: '${odontologo.nombre} ${odontologo.apellido}'
                  );
        
                  FocusScope.of(context).unfocus();
                  if (paciente.uid == null) {
                    final isRegistered = await pacienteProvider.registrarPaciente(newPaciente);  
                    ( isRegistered == true ) 
                      ? mostrarAlerta(context, 'Se agregó correctamente a ${paciente.nombres}') 
                      : mostrarAlerta(context, 'Vuelva a ingresar los datos correctamente');
                  } else {
                    final isUpdated = await pacienteProvider.actualizarPaciente(pacienteUpdated);
                    ( isUpdated == true )
                      ? mostrarAlerta(context, 'Se actualizó correctamente') 
                      : mostrarAlerta(context, 'No se actualizó');
                  }
                },
              text: (paciente.uid == null) ? 'Agregar' : 'Actualizar',
              color: (paciente.uid == null) ? AppTheme.color2 : AppTheme.color3,
            ),
      
            ButtonPersonal(
              key: UniqueKey(),
              onPressed: () => Navigator.pushReplacementNamed(context, TabsScreen.nombre), 
              text: 'Regresar',
              color: Colors.grey,
            ),
      
            const SizedBox(height: 10,)
      
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(UnderlineInputBorder underlineInputBorder) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.radio_button_checked_outlined, color: AppTheme.color4,),
      focusedBorder: underlineInputBorder,
      enabledBorder: underlineInputBorder,
      fillColor: Colors.grey[300],
      filled: true,
    );
  }
}

