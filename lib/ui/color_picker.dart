import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  static const List<ColorSwatch<Object>> primaryColors = <ColorSwatch<Object>>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
    Colors.grey,
  ];
  late ColorSwatch color;
  Function(Color) onChange;

  ColorPicker({super.key, required color, required this.onChange}) {
    this.color = color as ColorSwatch;
  }

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: ColorPicker.primaryColors.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, crossAxisSpacing: 10, mainAxisExtent: 100),
      itemBuilder: (context, index) => ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(ColorPicker.primaryColors[index]),
            shape: MaterialStateProperty.all(CircleBorder(
                side: (widget.color == ColorPicker.primaryColors[index])
                    ? const BorderSide(width: 2, color: Colors.white)
                    : BorderSide.none))),
        onPressed: () {
          setState(() {
            widget.color = ColorPicker.primaryColors[index];
          });
          widget.onChange(ColorPicker.primaryColors[index]);
        },
        child: null,
      ),
    );
  }
}
