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
    return GridView.count(
      padding: const EdgeInsets.symmetric(vertical: 10),
      crossAxisCount: 5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 16,
      children: List.generate(
        ColorPicker.primaryColors.length,
        (index) {
          return ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ColorPicker.primaryColors[index]),
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
          );
        },
      ),
    );
  }
}

Future<void> showColorDialog(BuildContext context, Color color, Function(Color) onChange) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.69,
          child: ColorPicker(
            color: color,
            onChange: (color) {
              onChange(color);
              Navigator.pop(context);
            },
          ),
        ),
      );
    },
  );
}
