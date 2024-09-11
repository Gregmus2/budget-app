import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: const ButtonStyle(
            shape: WidgetStatePropertyAll(BeveledRectangleBorder()),
            alignment: AlignmentDirectional.center,
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10, horizontal: 10))),
        child: Text(text));
  }
}
