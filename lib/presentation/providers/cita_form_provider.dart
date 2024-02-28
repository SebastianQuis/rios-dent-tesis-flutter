
import 'package:flutter/material.dart';

import 'package:clinica_dental_app/domain/entities/cita.dart';


class CitaFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Cita cita;
  CitaFormProvider(this.cita);

  actualizarFecha( String date ) {
    cita.fecha = date;
    notifyListeners();
  }

  actualizarAtencion( bool value ) {
    cita.atendida = value;
    notifyListeners();
  }

  bool esValidoFormulario() {
    return formKey.currentState?.validate() ?? false;
  }

}
