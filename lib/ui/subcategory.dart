import 'package:flutter/material.dart';

class SubCategory extends StatelessWidget {
  const SubCategory({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
    this.inverse = false,
  });

  final String label;
  final Color color;
  final IconData icon;
  final Function() onPressed;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)), side: BorderSide(color: color))),
          alignment: AlignmentDirectional.center,
          backgroundColor: inverse ? MaterialStatePropertyAll(color) : const MaterialStatePropertyAll(Colors.transparent),
          shadowColor: const MaterialStatePropertyAll(Colors.transparent),
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        ),
        icon: Icon(
          icon,
          color: inverse ? Colors.white : color,
          size: 18,
        ),
        label: Text(
          label,
          style: TextStyle(color: inverse ? Colors.white : color),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}