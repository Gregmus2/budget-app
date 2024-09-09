import 'package:flutter/material.dart';

class SubCategory extends StatelessWidget {
  const SubCategory({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    this.onPressed,
    this.inverse = false,
  });

  final String label;
  final Color color;
  final IconData icon;
  final Function()? onPressed;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)), side: BorderSide(color: color))),
          alignment: AlignmentDirectional.center,
          backgroundColor:
              inverse ? WidgetStatePropertyAll(color) : const WidgetStatePropertyAll(Colors.transparent),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
        icon: Icon(
          icon,
          color: inverse ? Colors.white : color,
          size: 18,
        ),
        label: Text(label,
            style: TextStyle(color: inverse ? Colors.white : color),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
