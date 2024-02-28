import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clinica_dental_app/presentation/providers/paciente_provider.dart';
import 'package:clinica_dental_app/domain/entities/paciente.dart';

class PacienteSearchDelegate extends SearchDelegate {

  @override
  final String searchFieldLabel;
  PacienteSearchDelegate(this.searchFieldLabel);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '', 
        icon: const Icon(Icons.clear_outlined)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    
    if ( query == '') return _ContainerVacio(); 

    final pacienteProvider = Provider.of<PacienteProvider>(context);

    return FutureBuilder(
      future: pacienteProvider.buscarPaciente(query),
      builder: (_, AsyncSnapshot<List<Paciente>> snapshot) {
        if (snapshot.hasError) return _ContainerVacio();
        if (!snapshot.hasData) return _ContainerVacio();
        return _mostrarPacientes(snapshot.data!);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _ContainerVacio();
  }

  Widget _mostrarPacientes(List<Paciente> pacientes) {
    return ListView.builder(
      itemCount: pacientes.length,
      itemBuilder: (BuildContext context, int i) {
        final paciente = pacientes[i];
        return ListTile(
          title: Text('${paciente.nombres} ${paciente.apellidos}'),
          subtitle: Text(paciente.dni),
          leading: const Icon(Icons.person_outline, size: 40,),
          onTap: () => close(context, paciente),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget _ContainerVacio() {
    return const Center(
      child: Text('Encuentra un paciente..')
    );
  }

}