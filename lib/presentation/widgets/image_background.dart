import 'package:flutter/material.dart';

import 'package:clinica_dental_app/presentation/widgets/title_text.dart';

class ImageBackground extends StatelessWidget {
  const ImageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        
        Container(
          margin: const EdgeInsets.only( bottom: 10),
          width: double.infinity,
          height: size.height * 0.35,
          child: const Image(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/logo.jpg'),
            filterQuality: FilterQuality.high,
          ),
        ),

        Positioned(
          bottom: 0,
          left: size.width * 0.37,
          child: const TitleText(color: Colors.grey, fontSize: 20, title: 'Ríos Dent',)
        ),

      ],
    );
  }
} 