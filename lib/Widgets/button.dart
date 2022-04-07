import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final bool small;
  final bool disabled;

  const ButtonWidget({
    Key? key,
    this.small = false,
    required this.onPressed,
    this.text = '',
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        minimumSize: small ? null : const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
