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
                  padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 10, horizontal: 10))),
              child: child),
        ),
      ],
    );
  }
}

CustomButton keyStringValueCustomButton(String label, String value, Color? color, VoidCallback onPressed,
    {String? subtitle}) {
  return keyValueCustomButton(
      label, Text(value, style: TextStyle(color: color), overflow: TextOverflow.ellipsis), color, onPressed,
      subtitle: subtitle);
}

CustomButton keyBoolValueCustomButton(String label, bool value, Color? color, Function(bool) onPressed,
    {String? subtitle}) {
  return keyValueCustomButton(
      label, Switch(value: value, onChanged: onPressed, activeColor: color), color, (){},
      subtitle: subtitle);
}

CustomButton keyValueCustomButton(String label, Widget value, Color? color, VoidCallback onPressed,
    {String? subtitle}) {
  Widget labelWidget = Text(label, style: const TextStyle(color: Colors.white, fontSize: 15));

  return CustomButton(
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          subtitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelWidget,
                    Text(subtitle, style: TextStyle(color: color), overflow: TextOverflow.ellipsis)
                  ],
                )
              : labelWidget,
          value
        ],
      ),
    ),
  );
}


