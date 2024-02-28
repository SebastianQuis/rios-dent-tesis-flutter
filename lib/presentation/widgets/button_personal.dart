import 'package:flutter/material.dart';

import 'package:clinica_dental_app/config/theme/app_theme.dart';

class ButtonPersonal extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color color;

  const ButtonPersonal({
    super.key, 
    required this.onPressed, 
    required this.text,
    this.color = AppTheme.color2
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
          backgroundColor: color,
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white),),
      ),
    );
  }
}