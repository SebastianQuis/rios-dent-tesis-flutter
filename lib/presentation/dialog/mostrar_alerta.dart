import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


mostrarAlerta( BuildContext context, String descripcion){

  if( Platform.isAndroid ) {
    return showDialog(
      context: context, 
      builder: (context) => 
        AlertDialog(
          title: const Text('Mensaje'),
          content: Text(descripcion),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              elevation: 5,
              textColor: Colors.blue,
              child: const Text('Ok'),
            )
          ],
        )
    );
  } 
    
  showCupertinoDialog(
    context: context, 
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Mensaje')),
        content: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric( vertical: 8 ),
            child: Text(descripcion, style: const TextStyle( fontSize: 14),),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            textStyle: const TextStyle(color: Colors.lightBlue),
            onPressed: () => Navigator.pop(context),
            isDefaultAction: true,
            child: const Text('Ok'),
          )
        ],
      );
    },
  );
  

}