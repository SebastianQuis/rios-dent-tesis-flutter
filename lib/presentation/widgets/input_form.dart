import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final String? hintText;
  final Widget? icon;
  final TextEditingController? textController;
  final bool? enabled;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final String? Function(String?)? onPressed;
  final void Function(String)? onChanged;
  final Widget? labelText;
  final bool isTextForm; 
  final String? title;
  final String? initialValue;
  final double? vertical;

  const InputForm({
    super.key,  
    this.hintText, 
    this.title,  
    this.isTextForm = true, 
    required this.icon, 
    this.textController,
    this.keyboardType = TextInputType.text, 
    this.isPassword = false, 
    this.onPressed, 
    this.labelText,
    this.enabled = true, 
    this.vertical = 0, 
    this.initialValue, 
    this.onChanged,
  });


  @override
  Widget build(BuildContext context) {
    final outlineBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10),
    );

    return Container(
      margin: EdgeInsets.symmetric( horizontal: 10, vertical: vertical!),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ( isTextForm )
        ? TextFormField(
            controller: textController,
            initialValue: initialValue,
            autocorrect: false,
            keyboardType: keyboardType,
            obscureText: isPassword!,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: icon,
              border: InputBorder.none,
              focusedBorder: outlineBorder,
              enabledBorder: outlineBorder,
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black45),
              labelStyle: const TextStyle(color: Colors.black45),
              label: labelText,
            ),
            style: const TextStyle(color: Colors.black87),
            validator: onPressed,
            enabled: enabled,
          )
        : SizedBox(
          height: 50,
          child: Row(
            children: [
              icon!,
              Text(title!, style: const TextStyle( color: Colors.black87),),
            ],
          ),
        )
    );
  }
}