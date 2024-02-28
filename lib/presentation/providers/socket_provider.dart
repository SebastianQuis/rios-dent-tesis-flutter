// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:clinica_dental_app/config/global/environment.dart';
import 'package:clinica_dental_app/presentation/providers/autenticacion_provider.dart';

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketProvider with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() async {
    final token = await AutenticacionProvider.getToken();
    
    // Dart client
    _socket = IO.io(Environment.socketUrl, {
      'transports' : ['websocket'],
      'autoConnect': true,
      'forceNew'   : true,
      'extraHeaders' : {
        'x-token' : token // enviando token al back
      }
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }

}

