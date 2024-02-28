import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:clinica_dental_app/config/theme/app_theme.dart';
import 'package:clinica_dental_app/domain/entities/entities.dart';
import 'package:clinica_dental_app/presentation/dialog/mostrar_alerta.dart';
import 'package:clinica_dental_app/presentation/providers/providers.dart';
import 'package:clinica_dental_app/presentation/widgets/title_text.dart';
import 'package:clinica_dental_app/presentation/screens/screens.dart';
 
class AdministracionScreen extends StatefulWidget {
  static String nombre = 'Admin';
  const AdministracionScreen({super.key});  

  @override
  State<AdministracionScreen> createState() => _AdministracionScreenState();
}

class _AdministracionScreenState extends State<AdministracionScreen> {
  late AdministracionProvider administracionProvider;
  final _refreshController = RefreshController(initialRefresh: false);
  
  @override
  void initState() {
    administracionProvider = Provider.of<AdministracionProvider>(context,listen: false);
    _cargarUsuarios();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final usuarios = administracionProvider.usuarios;

    return Scaffold(
      
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          header: const WaterDropHeader(
            complete: Icon( Icons.check, color: AppTheme.color2),
            waterDropColor: AppTheme.color2,
          ),
          onRefresh: _cargarUsuarios,
          child: usuarios.isEmpty
            ? const Center(child: Text('No hay usuarios registrados'),)
            : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, i) {

                return i == usuarios.length - 1
                ? Column(
                    children: [
                      _CardUsuario(usuario: usuarios[i]),
                      const SizedBox(height: 70.0),
                    ],
                  )
                : _CardUsuario(usuario: usuarios[i]);
              } 
            ),
        )
      ),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: UniqueKey(),
        onPressed: () {
          Navigator.pushNamed(context, UsuarioNuevoScreen.nombre);
        }, 
        label: const Text('Nuevo usuario', style: TextStyle(color:Colors.white),),
      ),
    );
  }

  _cargarUsuarios() async {
    administracionProvider.usuarios = await administracionProvider.getUsuarios();
    setState(() {
      _refreshController.refreshCompleted();
    });
  }
}

class _CardUsuario extends StatelessWidget {
  final Usuario usuario;
  const _CardUsuario({ required this.usuario });

  @override
  Widget build(BuildContext context) {
    final administracionProvider = Provider.of<AdministracionProvider>(context);
    
    return Dismissible(
      key: Key(usuario.uid!),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          usuario.disponible = false;
          usuario.password = usuario.password;

          await administracionProvider.actualizarPaciente(usuario);
          // ignore: use_build_context_synchronously
          mostrarAlerta(context, 'Se eliminó correctamente');
          return true;
        }
        return false;
      },
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 15, vertical: 10 ),
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(offset: Offset(1.0, 2.0))
          ]
        ),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 10,
              decoration: const BoxDecoration(
                color: AppTheme.color2,
                borderRadius: BorderRadius.only( bottomLeft: Radius.circular(10), topLeft: Radius.circular(10))
              ),
            ),
    
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleText(title: '${usuario.nombre} ${usuario.apellido}', fontSize: 18, weight: FontWeight.w600,),
                TitleText(title: 'Rol: ${usuario.rol}'),
                TitleText(title: 'Correo: ${usuario.email}'),
              ],
            ),
    
            const Spacer(),
    
            const Icon(Icons.keyboard_backspace, color: Colors.red, size: 40),

            const SizedBox(width: 10,)
          ],
        ),
      ),
    );
  }
}