import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
              onPressed: onPressed,
              style: const ButtonStyle(
                  shape: MaterialStatePropertyAll(BeveledRectangleBorder()),
                  alignment: AlignmentDirectional.centerStart,
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10))),
              child: child),
        ),
      ],
    );
  }
}