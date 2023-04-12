import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:spannable_grid/spannable_grid.dart';

class NumPad extends StatefulWidget {
  final double number;
  final Currency currency;
  final Function(double) onDone;

  const NumPad(
      {super.key,
      this.number = 0,
      required this.currency,
      required this.onDone});

  @override
  State<NumPad> createState() => _NumPadState();
}

class _NumPadState extends State<NumPad> {
  late String arg1;
  String arg2 = '';
  String operator = '';
  List<_NumPadButton> buttons = [
    _NumPadButton(1, 1, "Divider", "÷"),
    _NumPadButton(1, 2, "Multiply", "×"),
    _NumPadButton(1, 3, "Minus", "-"),
    _NumPadButton(1, 4, "Plus", "+"),
    _NumPadButton(2, 1, "7", "7"),
    _NumPadButton(2, 2, "4", "4"),
    _NumPadButton(2, 3, "1", "1"),
    _NumPadButton(2, 4, "=", "="),
    _NumPadButton(3, 1, "8", "8"),
    _NumPadButton(3, 2, "5", "5"),
    _NumPadButton(3, 3, "2", "2"),
    _NumPadButton(3, 4, "0", "0"),
    _NumPadButton(4, 1, "9", "9"),
    _NumPadButton(4, 2, "6", "6"),
    _NumPadButton(4, 3, "3", "3"),
    _NumPadButton(4, 4, "Dot", "."),
    _NumPadButton(5, 1, "Backspace", "⌫"),
    _NumPadButton(5, 2, "Done", "✔", rowSpan: 3),
  ];

  @override
  void initState() {
    super.initState();
    arg1 = widget.number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      const Text("Balance",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text(
                          "$arg1${operator != '' ? ' $operator $arg2' : ''} ${widget.currency.symbol}",
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          SpannableGrid(
            columns: 5,
            rows: 4,
            cells: _getCells(),
            showGrid: true,
            style: SpannableGridStyle(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              spacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  _handler(String char) {
    switch (char) {
      case "7":
      case "4":
      case "1":
      case "0":
      case "8":
      case "5":
      case "2":
      case "9":
      case "6":
      case "3":
        setState(() {
          if (operator != '') {
            arg2 = _addDigit(arg2, char);
          } else {
            arg1 = _addDigit(arg1, char);
          }
        });
        break;
      case ".":
        setState(() {
          if (operator != '') {
            arg2 = _addDot(arg2);
          } else {
            arg1 = _addDot(arg1);
          }
        });
        break;
      case "⌫":
        setState(() {
          if (operator != '') {
            if (arg2 == '') {
              operator = '';
            } else {
              arg2 = arg2.substring(0, arg2.length - 1);
              if (arg2 == '-') {
                arg2 = '';
              }
            }
          } else {
            arg1 = arg1.substring(0, arg1.length - 1);
            if (arg1 == '' || arg1 == '-') {
              arg1 = '0';
            }
          }
        });
        break;
      case "÷":
      case "×":
      case "-":
      case "+":
        setState(() {
          if (operator != '' && arg2 != '') {
            arg1 = _doCalc(arg1, operator, arg2);
            arg2 = '';
          }
          operator = char;
        });
        break;
      case "=":
        setState(() {
          if (operator != '' && arg2 != '') {
            arg1 = _doCalc(arg1, operator, arg2);
            arg2 = '';
            operator = '';
          }
        });
        break;
      case "✔":
        widget.onDone(double.parse(_doCalc(arg1, operator, arg2)));
        break;
    }
  }

  String _doCalc(String number1, operator, number2) {
    if (operator == '') {
      return number1;
    }

    double result = 0;
    switch (operator) {
      case "÷":
        result = (double.parse(number1) / double.parse(number2));
        break;
      case "×":
        result = (double.parse(number1) * double.parse(number2));
        break;
      case "-":
        result = (double.parse(number1) - double.parse(number2));
        break;
      case "+":
        result = (double.parse(number1) + double.parse(number2));
    }

    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toString();
    }
  }

  String _addDot(String number) {
    if (!number.contains(".")) {
      if (number == '') {
        return '0.';
      }

      return '$number.';
    }

    return number;
  }

  String _addDigit(String number, String digit) {
    if (number == '0') {
      return digit;
    }

    return '$number$digit';
  }

  List<SpannableGridCellData> _getCells() {
    var result = List<SpannableGridCellData>.generate(
        buttons.length,
        (index) => SpannableGridCellData(
              column: buttons[index].column,
              row: buttons[index].row,
              id: buttons[index].label,
              rowSpan: buttons[index].rowSpan ?? 1,
              columnSpan: buttons[index].columnSpan ?? 1,
              child: NumPadButton(
                char: buttons[index].char,
                onPressed: () => _handler(buttons[index].char),
              ),
            ));

    return result;
  }
}

class NumPadButton extends StatelessWidget {
  final String char;
  final Color? backgroundColor;
  final Function() onPressed;

  const NumPadButton(
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
          style: TextStyle(fontSize: 24, color: Colors.white.withOpacity(0.6)),
        ),
      ),
    );
  }
}

class _NumPadButton {
  int column;
  int row;
  int? columnSpan;
  int? rowSpan;
  String label;
  String char;

  _NumPadButton(this.column, this.row, this.label, this.char,
      {this.rowSpan});
}
