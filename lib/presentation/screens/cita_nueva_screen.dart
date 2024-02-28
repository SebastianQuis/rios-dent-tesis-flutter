
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:clinica_dental_app/config/preferences/preferences.dart';
import 'package:clinica_dental_app/config/theme/app_theme.dart';
import 'package:clinica_dental_app/domain/entities/entities.dart';
import 'package:clinica_dental_app/presentation/helpers/helpers.dart';
import 'package:clinica_dental_app/presentation/dialog/mostrar_alerta.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/screens/screens.dart';
import 'package:clinica_dental_app/presentation/widgets/widgets.dart';
 
class CitaNuevaScreen extends StatelessWidget {
  static String nombre = 'citaNueva';
  const CitaNuevaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final citaProvider = Provider.of<CitaProvider>(context);

    return ChangeNotifierProvider(
      create: (context) => CitaFormProvider(citaProvider.citaSeleccionada!),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
            child: _FormPaciente(),
          ),
        )
      ),
    );
  }
}



class _FormPaciente extends StatefulWidget {
  @override
  State<_FormPaciente> createState() => _FormPacienteState();
}

class _FormPacienteState extends State<_FormPaciente> {
  TimeOfDay _horaInicial = const TimeOfDay(hour: 10, minute: 00);
  TimeOfDay _horaFinal   = const TimeOfDay(hour: 11, minute: 00);
  Paciente? pacienteSeleccionado;

  Future<TimeOfDay?> pickTime() => showTimePicker( 
    context: context, 
    initialTime: TimeOfDay(hour: _horaInicial.hour, minute: _horaInicial.minute),
    anchorPoint: const Offset(0.5, 0.5)
  );
  

  @override
  Widget build(BuildContext context) {
    final citaFormProvider = Provider.of<CitaFormProvider>(context);
    final citaProvider = Provider.of<CitaProvider>(context);
    final pacienteProvider = Provider.of<PacienteProvider>(context);
    final usuarioSeleccionado = Provider.of<DropDownUsuariosProvider>(context).usuarioSeleccionado;
    final authProvider = Provider.of<AutenticacionProvider>(context);
    
    final cita = citaFormProvider.cita;
    final odontologo = authProvider.usuario.rol == 'Administrador' ? '${usuarioSeleccionado!.nombre} ${usuarioSeleccionado.apellido}' : '${authProvider.usuario.nombre} ${authProvider.usuario.apellido}';
    
    Future<DateTime?> pickDate() => showDatePicker( context: context,
      initialDate: parseStringDate(cita.fecha!),
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [

          Row(
            children: [
              TitleText(title: 'Registrar cita', weight: FontWeight.w700, fontSize: 22, color: Preferences.esModoOscuro ? Colors.white : Colors.black87,),
              const Spacer(),
              IconButton( 
                icon: const Icon(Icons.search), 
                onPressed: () async {
                  final paciente = await showSearch(
                    context: context, 
                    delegate: PacienteSearchDelegate('Buscar..')
                  );
                  setState(() {
                    pacienteSeleccionado = paciente;
                    cita.paciente = '${pacienteSeleccionado!.nombres} ${pacienteSeleccionado!.apellidos}';
                    cita.telefono = pacienteSeleccionado!.telefono;
                  });
                }, 
                splashColor: Colors.transparent
              ),
            ],
          ),
          
          InputForm(
            icon: const Icon(Icons.person_outline, color: AppTheme.color4,),
            labelText:  Text( (cita.paciente == null) ? 'Busca al paciente..' : cita.paciente! ),
            enabled: false,
            vertical: 5,
          ),
          
          InputForm(
            isTextForm: false,
            icon: IconButton(
              onPressed: () async {
                TimeOfDay? time = await pickTime();
                if (time == null) return;
                  final newTime = TimeOfDay(hour: time.hour, minute: time.minute);
                  setState(() {
                    _horaInicial = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
                    cita.horaInicial = timeDayString(_horaInicial);
                  }
                );
              }, 
              icon: const Icon(Icons.timer_outlined,color: AppTheme.color4),
            ),
            title: cita.horaInicial ?? timeDayString(_horaInicial),
            vertical: 5,
          ),
    
          InputForm(
            isTextForm: false,
            icon: IconButton(
              onPressed: () async {
                TimeOfDay? time = await pickTime();
                if (time == null) return;
                  final newTime = TimeOfDay(hour: time.hour, minute: time.minute);
                  setState(() {
                    _horaFinal = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
                    cita.horaFinal = timeDayString(_horaFinal);
                  }
                );
              }, 
              icon: const Icon(Icons.av_timer_outlined,color: AppTheme.color4),
            ),
            title: cita.horaFinal ?? timeDayString(_horaFinal),
            vertical: 5,
          ), 
    
          InputForm(
            icon: const Icon(Icons.note_add_outlined,color: AppTheme.color4),
            hintText: 'Nota',
            initialValue: cita.nota,
            vertical: 5,
            onChanged: (value) => cita.nota = value,
          ),
          
          InputForm(
            vertical: 5,
            isTextForm: false,
            title: cita.fecha,
            icon: IconButton(
              onPressed: () async {
                DateTime? date = await pickDate();
                if (date == null) return;
                final newDate = DateTime(date.year, date.month, date.day);
                final dateParse = parseDateTimeString(newDate);
                citaFormProvider.actualizarFecha(dateParse);
                // setState(() {});
              }, 
              icon: const Icon(Icons.calendar_month, color: AppTheme.color4,),
            ),
          ),
          
          SwitchListTile.adaptive(
            activeColor: AppTheme.color4,
            title: const Text('Atendida'),
            value: cita.atendida!,
            onChanged: (value) async {
              citaFormProvider.actualizarAtencion(value);
            },
          ),

          (cita.id != null) ? 
            Container(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Text('Teléfono', style: TextStyle(fontSize: 16),),
                  const Spacer(),
                  IconButton(
                  splashColor: Colors.transparent,
                  icon: const Icon(Icons.call, color: Colors.blue,), 
                  onPressed: () async {
                    final telefono = 'tel:${cita.telefono}';
                    if ( await canLaunchUrl(Uri.parse(telefono)) ) {
                      await launchUrl(Uri.parse(telefono));
                    } else {
                      throw 'No se pudo redirigir a la llamada telefónica';
                    }
                  },
                ),
                ],
              ),
            )
            : Container(),
    
          ButtonPersonal(
            key: UniqueKey(),
            onPressed: citaProvider.registrando 
              ? null
              : () async {
                if (citaFormProvider.esValidoFormulario()) return;
                                
                if (cita.paciente == null ) {
                  mostrarAlerta(context, 'Encuentre un paciente');
                }

                final newCita = Cita(
                  paciente: cita.paciente, 
                  odontologo: odontologo,
                  horaInicial: cita.horaInicial ?? timeDayString(_horaInicial),
                  horaFinal: cita.horaFinal ?? timeDayString(_horaFinal),
                  nota: cita.nota, 
                  fecha: cita.fecha,
                  telefono: cita.telefono,
                  atendida: cita.atendida,
                );

                if (cita.id == null) {
                  final isRegistered = await citaProvider.registrarCita(newCita);
                  if (isRegistered == true ) {
                    await citaProvider.initCitas(odontologo);
                    // ignore: use_build_context_synchronously
                    mostrarAlerta(context, 'Se agregó correctamente la cita');
                    pacienteSeleccionado = null;
                  } else if ( isRegistered == false) {
                    // ignore: use_build_context_synchronously
                    mostrarAlerta(context, 'Registro inválido');
                  } else {
                    mostrarAlerta(context, '$isRegistered');
                  }
                } else {
                  newCita.id = cita.id;

                  final isUpdated = await citaProvider.actualizarCita(newCita);
                  if ( isUpdated == true ) {
                    await citaProvider.initCitas(odontologo);
                    // ignore: use_build_context_synchronously
                    mostrarAlerta(context, 'Se actualizó correctamente');
                  } else {
                    // ignore: use_build_context_synchronously
                    mostrarAlerta(context, 'No se actualizó');
                  }
                }
              },
            text: (cita.id == null) ? 'Guardar' : 'Actualizar',
            color: (cita.id == null) ? AppTheme.color2 : AppTheme.color3,
          ),
          
          if (cita.id == null) 
            ButtonPersonal(
              key: UniqueKey(),
              onPressed: () {
                pacienteProvider.pacienteSeleccionado = Paciente(
                  nombres: '', 
                  apellidos: '', 
                  telefono: '', 
                  genero: 'Masculino', 
                  dni: '', 
                  nacimiento: DateTime.now(), 
                  tratamiento: '',
                  odontologo: '${authProvider.usuario.nombre} ${authProvider.usuario.apellido}'
                );
                Navigator.pushNamed(context, PacienteNuevoScreen.nombre);
              },          
              color: AppTheme.color4, 
              text: 'Nuevo paciente'
            ),

          if (cita.id != null)
            ButtonPersonal(
              color: Colors.red,
              onPressed: () async {
                await citaProvider.eliminarCita(cita);
                await citaProvider.initCitas(odontologo);
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, CitaScreen.nombre);
              }, 
              text: 'Eliminar'
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
