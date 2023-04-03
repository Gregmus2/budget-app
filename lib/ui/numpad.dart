import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:spannable_grid/spannable_grid.dart';

class NumPad extends StatefulWidget {
  double number;
  Currency currency;
  Function(double) onDone;

  NumPad(
      {super.key,
      this.number = 0,
      required this.currency,
      required this.onDone});

  @override
  State<NumPad> createState() => _NumPadState(number);
}

class _NumPadState extends State<NumPad> {
  late String text;

  _NumPadState(double number) {
    text = number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            const Text("Balance"),
            Text("$text ${widget.currency.symbol}"),
          ],
        ),
        SpannableGrid(
          columns: 5,
          rows: 4,
          cells: _getCells(() => widget.onDone(double.parse(text))),
          showGrid: true,
          style: SpannableGridStyle(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            spacing: 0.5,
          ),
        ),
      ],
    );
  }

  List<SpannableGridCellData> _getCells(Function() onDone) {
    var result = <SpannableGridCellData>[
      SpannableGridCellData(
        column: 1,
        row: 1,
        id: "Divider",
        child: NumPadButton(
          char: "÷",
          onPressed: () {},
        ),
      ),
      SpannableGridCellData(
        column: 1,
        row: 2,
        id: "Multiplier",
        child: NumPadButton(char: "×", onPressed: () {}),
      ),
      SpannableGridCellData(
        column: 1,
        row: 3,
        id: "Minus",
        child: NumPadButton(char: "-", onPressed: () {}),
      ),
      SpannableGridCellData(
        column: 1,
        row: 4,
        id: "Plus",
        child: NumPadButton(char: "+", onPressed: () {}),
      ),
      SpannableGridCellData(
        column: 2,
        row: 1,
        id: "7",
        child: NumPadButton(
          char: "7",
          onPressed: () {
            setState(() {
              text += '7';
            });
          },
        ),
      ),
      SpannableGridCellData(
        column: 2,
        row: 2,
        id: "4",
        child: NumPadButton(
          char: "4",
          onPressed: () {
            setState(() {
              text += '4';
            });
          },
        ),
      ),
      SpannableGridCellData(
        column: 2,
        row: 3,
        id: "1",
        child: NumPadButton(
          char: "1",
          onPressed: () {
            setState(() {
              text += '1';
            });
          },
        ),
      ),
      SpannableGridCellData(
        column: 2,
        row: 4,
        columnSpan: 2,
        id: "0",
        child: NumPadButton(
          char: "0",
          onPressed: () {
            setState(() {
              text += '0';
            });
          },
        ),
      ),
      SpannableGridCellData(
        column: 3,
        row: 1,
        id: "8",
        child: NumPadButton(
          char: "8",
          onPressed: () {
            setState(() {
              text += '8';
            });
          },
        ),
      ),
      SpannableGridCellData(
        column: 3,
        row: 2,
        id: "5",
        child: NumPadButton(
          char: "5",
          onPressed: () {
            setState(() {
              text += '5';
            });
          },
        ),
      ),
      SpannableGridCellData(
        column: 3,
        row: 3,
        id: "2",
        child: NumPadButton(
          char: "2",
          onPressed: () {
            setState(() {
              text += '2';
            });
          },
        ),
      ),
      SpannableGridCellData(
        column: 4,
        row: 1,
        id: "9",
        child: NumPadButton(
            char: "9",
            onPressed: () {
              setState(() {
                text += '9';
              });
            }),
      ),
      SpannableGridCellData(
        column: 4,
        row: 2,
        id: "6",
        child: NumPadButton(
            char: "6",
            onPressed: () {
              setState(() {
                text += '6';
              });
            }),
      ),
      SpannableGridCellData(
        column: 4,
        row: 3,
        id: "3",
        child: NumPadButton(
            char: "3",
            onPressed: () {
              setState(() {
                text += '3';
              });
            }),
      ),
      SpannableGridCellData(
        column: 4,
        row: 4,
        id: "Dot",
        child: NumPadButton(char: ".", onPressed: () {
          setState(() {
            text += '.';
          });
        }),
      ),
      SpannableGridCellData(
        column: 5,
        row: 1,
        id: "Backspace",
        child: NumPadButton(
          char: "<",
          onPressed: () {
            setState(() {
              text = text.substring(0, text.length - 1);
            });
          },
        ),
      ),
      SpannableGridCellData(
        column: 5,
        row: 2,
        rowSpan: 3,
        id: "Done",
        child: NumPadButton(char: "+", onPressed: onDone),
      ),
    ];

    return result;
  }
}

class NumPadButton extends StatelessWidget {
  String char;
  Color? backgroundColor;
  Function() onPressed;

  NumPadButton(
      {super.key,
      required this.char,
      this.backgroundColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          char,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
