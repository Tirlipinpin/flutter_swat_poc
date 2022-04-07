import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  const TextFormFieldWidget(
      {Key? key,
      this.hintText = '',
      this.obscureText = false,
      this.enableSuggestions = true,
      this.autocorrect = true,
      this.validator,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(30)),
        height: 55,
        margin: const EdgeInsets.only(bottom: 15),
        child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 4, right: 25),
            child: TextFormField(
              autocorrect: autocorrect,
              obscureText: obscureText,
              enableSuggestions: enableSuggestions,
              decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
                  border: InputBorder.none),
              style: const TextStyle(fontSize: 18),
              validator: validator,
              controller: controller,
            )));
  }
}
