import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  static const List<Color> primaryColors = <Color>[
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
  // colors variation through ColorSwatch
  final Color color;
  final Function(Color) onChange;

  const ColorPicker({super.key, required this.color, required this.onChange});

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

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
                side: (color.value == ColorPicker.primaryColors[index].value)
                    ? const BorderSide(width: 2, color: Colors.white)
                    : BorderSide.none))),
        onPressed: () {
          setState(() {
            color = ColorPicker.primaryColors[index];
          });
          widget.onChange(ColorPicker.primaryColors[index]);
        },
        child: null,
      ),
    );
  }
}
