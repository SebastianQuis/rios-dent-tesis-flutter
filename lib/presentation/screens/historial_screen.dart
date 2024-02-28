import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clinica_dental_app/config/preferences/preferences.dart';
import 'package:clinica_dental_app/config/theme/app_theme.dart';
import 'package:clinica_dental_app/domain/entities/entities.dart';
import 'package:clinica_dental_app/presentation/helpers/helpers.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/widgets/widgets.dart';
 
class HistorialScreen extends StatefulWidget {
  static String nombre = 'Historial';
  const HistorialScreen({super.key});  

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  Paciente? pacienteSeleccionado;
  
  @override
  Widget build(BuildContext context) {
    final historialProvider = Provider.of<HistorialProvider>(context);

    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text('Historial ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),

              GestureDetector(
                onTap: () async {
                  final paciente = await showSearch(context: context, delegate: PacienteSearchDelegate('Buscar..'));
                  setState(() {
                    pacienteSeleccionado = paciente;
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      title: Text('Busca al paciente', style: TextStyle(color: Preferences.esModoOscuro ? Colors.black87 : Colors.black87),),
                      leading: const Icon(Icons.search, color: AppTheme.color2,),
                    ),
                  )
                ),
              ),
          
              pacienteSeleccionado != null
                ? FutureBuilder(
                    future: historialProvider.buscarCitas('${pacienteSeleccionado!.nombres} ${pacienteSeleccionado!.apellidos}'),
                    builder: (context, snapshot) {
                      if ( snapshot.hasError) return const Center(child: Text('Hubo un error!')); 
                      if ( !snapshot.hasData ) return const Center(child: Text('No hay data!'));
                      return _CardCitas(citas: snapshot.data!);
                    },
                  )
                : _NoPaciente()
          
            ],
          ),
        ),
      ),
    );
  }
}

class _NoPaciente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      alignment: Alignment.center,
      child: const Text('No hay paciente seleccionado'));
  }
}

class _CardCitas extends StatelessWidget {
  final List<Cita> citas;

  const _CardCitas({required this.citas});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: citas.map((cita) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          height: 160,
          decoration: BoxDecoration(
            color:  Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(offset: Offset(1.0, 2.0)),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                child: Container(
                  height: double.infinity,
                  width: 10,
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                  color: AppTheme.color2,
                ),
              ),
              
              const SizedBox(width: 10,),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.date_range_rounded, color: Colors.indigo,),
                      TitleText( title: fomatMonthName(cita.fecha!), weight: FontWeight.w500, fontSize: 18,),
                    ],
                  ),

                  Row(
                    children: [
                      const TitleText(title: 'Horario', weight: FontWeight.bold, paddingHorizontal: 0,),
                      TitleText(
                        title: '${cita.horaInicial} - ${cita.horaFinal}',
                      ),
                    ],
                  ),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleText(title: 'Nota', weight: FontWeight.bold, paddingHorizontal: 0, paddingVertical: 0,),
                      // TitleText( title: cita.nota!, weight: FontWeight.w500, fontSize: 16),
                      Container(
                        width: size.width * 0.7,
                        padding: const EdgeInsets.only(left: 30),
                        child: Text( '${cita.nota}', 
                          overflow: TextOverflow.ellipsis, 
                          maxLines: 2, 
                          textAlign: TextAlign.justify, 
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const TitleText(title: 'Estado', weight: FontWeight.bold, paddingHorizontal: 0,),
                      const SizedBox(width: 15,),
                      Text(cita.atendida! ? 'Atendida' : 'No atendida', style: TextStyle(color: cita.atendida! ? Colors.green : Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 16),)
                    ],
                  ),

                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}