import 'package:flutter/material.dart';

import 'package:clinica_dental_app/domain/entities/paciente.dart';

class PacienteFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Paciente paciente;
  PacienteFormProvider(this.paciente);

  actualizarNacimiento( DateTime date ) {
    paciente.nacimiento = date;
    notifyListeners();
  }

  bool esValidoFormulario() {
    return formKey.currentState?.validate() ?? false;
  }
}
