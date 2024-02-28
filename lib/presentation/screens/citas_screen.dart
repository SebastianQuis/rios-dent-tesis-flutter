import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:clinica_dental_app/config/theme/app_theme.dart';
import 'package:clinica_dental_app/domain/entities/entities.dart';
import 'package:clinica_dental_app/presentation/helpers/helpers.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/screens/screens.dart';
 
class CitaScreen extends StatelessWidget {
  static String nombre = 'Citas';
  const CitaScreen({super.key});  

  @override
  Widget build(BuildContext context) {
    final citaProvider = Provider.of<CitaProvider>(context);
    final authProvider = Provider.of<AutenticacionProvider>(context);
    final usuarioSeleccionado = Provider.of<DropDownUsuariosProvider>(context).usuarioSeleccionado;
    final odontologo = authProvider.usuario.rol == 'Administrador' ? '${usuarioSeleccionado!.nombre} ${usuarioSeleccionado.apellido}' : '${authProvider.usuario.nombre} ${authProvider.usuario.apellido}';
    
    return Scaffold(    
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      const CircleAvatar(backgroundColor: AppTheme.color2, foregroundColor: AppTheme.color1, child: Icon(Icons.person),),
                      const SizedBox(width: 10,),
                      const Text('Hola ', style: TextStyle(fontSize: 20)),
                      Text('${authProvider.usuario.nombre} ${authProvider.usuario.apellido.split(' ')[0]}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                    ],
                  )),
                
                _Calendario(),
                  
                _ListaCitas(),
          
                const SizedBox(height: 70)
                
              ],
            ),
          ),
        ),
      ),
    
      floatingActionButton: FloatingActionButton.extended(
        heroTag: UniqueKey(),
        onPressed: () {
          final DateTime day = citaProvider.selectedDay;
          citaProvider.citaSeleccionada = Cita(
            odontologo: odontologo,
            nota: '',
            fecha: parseDateTimeString(day),
            telefono: '',
            atendida: false,
          );
          Navigator.pushNamed(context, CitaNuevaScreen.nombre);
        }, 
        label: const Text('Nueva cita', style: TextStyle(color: Colors.white),),
      ),
    
    );
  }
}

class _Calendario extends StatefulWidget {
  @override
  State<_Calendario> createState() => __CalendarioState();
}

class __CalendarioState extends State<_Calendario> {
  @override
  Widget build(BuildContext context) {
    final citaProvider = Provider.of<CitaProvider>(context);
    final usuario = Provider.of<AutenticacionProvider>(context).usuario;
    final usuarioSeleccionado = Provider.of<DropDownUsuariosProvider>(context).usuarioSeleccionado;


    return TableCalendar(
      locale: 'es',
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      focusedDay: citaProvider.focusedDay, 
      firstDay: DateTime.utc(2023, 01, 01),
      lastDay: DateTime.utc(2043, 01, 01),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          citaProvider.selectedDay = selectedDay;
          citaProvider.focusedDay = focusedDay;
        });
        citaProvider.getCitasDay(selectedDay, 
          usuario.rol == 'Odontologo'
            ? '${usuario.nombre} ${usuario.apellido}'
            : '${usuarioSeleccionado!.nombre} ${usuarioSeleccionado.apellido}'
        );
      },
      calendarStyle: CalendarStyle(
        selectedDecoration: const BoxDecoration(
          color: AppTheme.color2,
          shape: BoxShape.circle
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600
        ),
        todayDecoration: const BoxDecoration(
          color: AppTheme.color2,
          shape: BoxShape.circle
        ),
        markerDecoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(5)
        ),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(citaProvider.selectedDay, day); 
      },
      eventLoader: citaProvider.getCitasCalendar,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (_, day, events) {
          return events.isNotEmpty 
            ? Align(
              alignment: Alignment.bottomRight,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration( color: AppTheme.color3, shape: BoxShape.rectangle ),
                width: 14,
                height: 14,
                child: Text('${events.length}', style: const TextStyle(fontSize: 10),)
              ))
            : null;
        },
      ),
    );
  }
}

class _ListaCitas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final citaProvider = Provider.of<CitaProvider>(context);

    return citaProvider.cargandoCitaDia
      ? const Center(child: CircularProgressIndicator.adaptive())
      : citaProvider.citasDia.isEmpty
        ? const Center(child: Text('No hay citas en este día'))
        : Column(
          children: citaProvider.citasDia.map((Cita cita) => _CitaItem(cita)).toList()
        );
  }
}

class _CitaItem extends StatelessWidget {
  final Cita cita;
  const _CitaItem(this.cita);

  @override
  Widget build(BuildContext context) {
    final citaProvider = Provider.of<CitaProvider>(context);
    List<String> nombreFull = cita.paciente!.split(' ');

    return Container(
      height: 75,
      alignment: Alignment.center,
      margin: const EdgeInsetsDirectional.symmetric( horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [ Text(cita.horaInicial!, style: styleSize()), Text(cita.horaFinal!, style: styleSize())],
        ),
        title: Row(
          children: [
            Text('${nombreFull[0]} ${nombreFull[1]}', style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
            const SizedBox(width: 5),
            CircleAvatar(
              radius: 10,
              backgroundColor: cita.atendida! ? AppTheme.color2 : AppTheme.color3,
              child: Text( cita.atendida! ? 'A' : 'P', style: const TextStyle(fontSize: 12, color: Colors.white),),
            )
          ],
        ),
        subtitle: Text(cita.nota!, maxLines: 2, overflow: TextOverflow.ellipsis, ),
        trailing: IconButton(
          onPressed: () {
            citaProvider.citaSeleccionada = cita;
            Navigator.pushNamed(context, CitaNuevaScreen.nombre);
          }, 
          icon: const Icon(Icons.edit_calendar, color: AppTheme.color3,)
        ),
      ),
    );
  }

  TextStyle styleSize() => const TextStyle( fontSize: 13, fontWeight: FontWeight.w500 );
}