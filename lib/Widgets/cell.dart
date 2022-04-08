import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  final String value;
  final bool editable;
  final bool ellipsis;

  const Cell(
      {Key? key,
      required this.value,
      this.editable = false,
      this.ellipsis = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: SizedBox(
          height: 15,
          child: Text(
            value,
            overflow: ellipsis ? TextOverflow.ellipsis : TextOverflow.clip,
          ),
        ),
      ),
    );
  }
}
