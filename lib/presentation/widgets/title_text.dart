import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final FontWeight weight;
  final double paddingVertical;
  final double paddingHorizontal;
  
  const TitleText({
    super.key, 
    required this.title, 
    this.fontSize = 16, 
    this.color = Colors.black87, 
    this.weight = FontWeight.normal, 
    this.paddingVertical = 10, 
    this.paddingHorizontal = 10,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
    child: Text(title, style: TextStyle(fontSize: fontSize, color: color, fontWeight:weight) ),
  );
}

