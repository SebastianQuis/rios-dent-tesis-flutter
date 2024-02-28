// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:clinica_dental_app/config/theme/app_theme.dart';
import 'package:clinica_dental_app/domain/entities/entities.dart';
import 'package:clinica_dental_app/presentation/dialog/mostrar_alerta.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/screens/screens.dart';
import 'package:clinica_dental_app/presentation/widgets/widgets.dart';
 
class PacienteScreen extends StatefulWidget {
  static String nombre = 'Pacientes';
  const PacienteScreen({super.key});

  @override
  State<PacienteScreen> createState() => _PacienteScreenState();
}

class _PacienteScreenState extends State<PacienteScreen> {
  late PacienteProvider pacienteProvider;
  final _refreshController = RefreshController(initialRefresh: false);
  
  @override
  void initState() {
    pacienteProvider = Provider.of<PacienteProvider>(context, listen: false);
    _cargarPacientes();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final pacientes = pacienteProvider.pacientes;
    final odontologo = Provider.of<AutenticacionProvider>(context).usuario;

    return Scaffold(

      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          header: const WaterDropHeader(
            complete: Icon(Icons.check, color: AppTheme.color2,),
            waterDropColor: AppTheme.color2,
          ),
          onRefresh: _cargarPacientes,
          child: pacientes.isEmpty
            ? const Center(child: Text('No hay pacientes registrados'),)
            : ListView.builder(
              itemCount: pacientes.length,
              itemBuilder: (context, i) {

                return i == pacientes.length - 1
                ? Column(
                    children: [
                      _CardPaciente(paciente: pacientes[i]),
                      const SizedBox(height: 70.0), // Espacio adicional después del último paciente
                    ],
                  )
                : _CardPaciente(paciente: pacientes[i]);
              },
            ),
        )
      ),

      floatingActionButton: FloatingActionButton.extended(
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
            odontologo: '${odontologo.nombre} ${odontologo.apellido}'
          );
          Navigator.pushNamed(context, PacienteNuevoScreen.nombre);
        },
        label: const Text('Nuevo paciente', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  _cargarPacientes() async {
    pacienteProvider.pacientes = await pacienteProvider.obtenerPacientes();
    setState(() {
      _refreshController.refreshCompleted();
    });
  }
}

class _CardPaciente extends StatelessWidget {
  final Paciente paciente;
  const _CardPaciente({required this.paciente});
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pacienteProvider = Provider.of<PacienteProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 15, vertical: 10 ),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(offset: Offset(1.0, 2.0))
        ]
      ),
      child: Row(
        children: [
    
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
            child: Container(
              height: double.infinity,
              width: 10,
              color: paciente.activo! ? AppTheme.color2 : AppTheme.color3,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
          )),
    
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleText(title: '${paciente.nombres} ${paciente.apellidos.split(' ')[0]}', weight: FontWeight.w600, fontSize: 18),
              TitleText(title: 'Edad: ${paciente.edad}', paddingVertical: 5, fontSize: 14 ),
              TitleText(title: 'Tratamiento: ${paciente.tratamiento}', paddingVertical: 5, fontSize: 14 ),

              SizedBox(
                width: size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _IconCustomize(
                      icon: Icons.archive,
                      color: Colors.red,
                      onPressed: () async {
                        paciente.activo = !paciente.activo!;
                        final isUpdated = await pacienteProvider.actualizarEstado(uid: paciente.uid!, active: paciente.activo! );
                        ( isUpdated )
                          ? mostrarAlerta(context, 'Se actualizó correctamente el estado')
                          : mostrarAlerta(context, 'No se pudo actualizar el estado');
                      },
                    ),
                    _IconCustomize(
                      icon: Icons.edit,
                      color: AppTheme.color3, 
                      onPressed: () {
                        pacienteProvider.pacienteSeleccionado = paciente;
                        Navigator.pushNamed(context, PacienteNuevoScreen.nombre);
                      },
                    ),
                    _IconCustomize(
                      icon: Icons.message,
                      color: AppTheme.color2, 
                      onPressed: () async {
                        final phoneNumber = '51${paciente.telefono}'; 
                        final message = 'Buen día ${paciente.nombres}, te escribimos de la clinica dental Ríos Dent';
                        final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'No se pudo abrir WhatsApp.';
                        }
                      },
                    ),
                    _IconCustomize(
                      icon: Icons.call,
                      color: AppTheme.color4, 
                      onPressed: () async {
                        final telefono = 'tel:${paciente.telefono}';
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
    
            ],
          )
    
        ],
      ),
    );
  }
}

class _IconCustomize extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  const _IconCustomize({required this.onPressed, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      onPressed: onPressed, 
      icon: Icon(icon, color: color),
    );
  }
}