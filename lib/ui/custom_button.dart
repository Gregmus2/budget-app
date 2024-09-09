import 'package:flutter/material.dart';

class EntitySettingBool extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onPressed;
  final Color? color;
  final String? subtitle;

  const EntitySettingBool({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
    this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return EntitySetting(
        label: label,
        value: Switch(value: value, onChanged: onPressed, activeColor: color),
        color: color,
        onPressed: () {},
        subtitle: subtitle);
  }
}

class EntitySettingString extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onPressed;
  final Color? color;
  final String? subtitle;

  const EntitySettingString({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
    this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return EntitySetting(
        label: label,
        value: Text(value, style: TextStyle(color: color), overflow: TextOverflow.ellipsis),
        color: color,
        onPressed: onPressed,
        subtitle: subtitle);
  }
}

class EntitySetting extends StatelessWidget {
  final String label;
  final Widget value;
  final VoidCallback onPressed;
  final Color? color;
  final String? subtitle;

  const EntitySetting({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
    this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
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
                      Text(subtitle!, style: TextStyle(color: color), overflow: TextOverflow.ellipsis)
                    ],
                  )
                : labelWidget,
            value
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
              onPressed: onPressed,
              style: const ButtonStyle(
                  shape: WidgetStatePropertyAll(BeveledRectangleBorder()),
                  alignment: AlignmentDirectional.centerStart,
                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10, horizontal: 10))),
              child: child),
        ),
      ],
    );
  }
}
