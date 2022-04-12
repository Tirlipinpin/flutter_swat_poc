import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:developer' as developer;

class Cell extends HookWidget {
  final String value;
  final bool enabled;
  final bool ellipsis;
  final void Function(int hours)? onEdit;

  const Cell(
      {Key? key,
      required this.value,
      this.enabled = false,
      this.ellipsis = false,
      this.onEdit})
      : super(key: key);

  void handleEditingComplete(String value) {
    developer.log('handleEditingComplete, $value');
    if (onEdit != null) {
      onEdit!(int.parse(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueController = useTextEditingController(text: value);

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: SizedBox(
            height: 15,
            child: !enabled
                ? Text(
                    value,
                    overflow:
                        ellipsis ? TextOverflow.ellipsis : TextOverflow.clip,
                  )
                : TextField(
                    autocorrect: false,
                    enabled: enabled,
                    keyboardType: TextInputType.number,
                    onEditingComplete: () =>
                        handleEditingComplete(valueController.text.trim()),
                    controller: valueController,
                  )),
      ),
    );
  }
}
