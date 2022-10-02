import 'package:flutter/material.dart';

OutlineInputBorder border(Color color, [double width = 2]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: width),
  );
}

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.onFocusChange,
    required this.onChanged,
    required this.onFieldSubmitted,
    required this.controller,
    required this.focusNode,
    required this.errorText,
    required this.text,
  });

  final String text;
  final Function(bool)? onFocusChange;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Focus(
        onFocusChange: onFocusChange,
        child: TextFormField(
          textInputAction: TextInputAction.next,
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: border(Colors.white70),
            enabledBorder: border(Colors.white60),
            focusedBorder: border(Colors.white, 3),
            errorBorder: border(Colors.redAccent),
            label: Text(text),
            errorText: errorText,
            errorMaxLines: 2,
          ),
          onFieldSubmitted: onFieldSubmitted,
        ),
      ),
    );
  }
}
