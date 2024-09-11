import 'package:flutter/material.dart';

class StringDrawerCard extends StatelessWidget {
  final String name;
  final String? value;
  final IconData icon;
  final Color color;
  final Function() onPressed;

  const StringDrawerCard(
      {super.key, required this.name, this.value, required this.icon, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [Text(name, style: const TextStyle(fontSize: 18))];
    if (value != null) {
      content.add(Text(value!, style: TextStyle(color: color, fontSize: 16)));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: TextButton(
                onPressed: onPressed,
                style: const ButtonStyle(
                    alignment: AlignmentDirectional.centerStart,
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
                    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10, horizontal: 10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(icon, size: 30),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: content,
                    ),
                  ],
                ))),
      ],
    );
  }
}
