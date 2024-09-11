import 'package:fb/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:spannable_grid/spannable_grid.dart';

class SimpleNumPad extends StatefulWidget {
  final double number;
  final Currency currency;
  final List<NumPadButtonModel>? additionalButtons;
  final Widget? underBalance;
  final Widget? leftGuy;
  final Widget? rightGuy;
  final Widget? middle;
  final Function(String char, BuildContext context)? handler;
  final Function(double number) onDone;

  const SimpleNumPad(
      {super.key,
        this.number = 0,
        required this.currency,
        this.additionalButtons,
        this.underBalance,
        this.leftGuy,
        this.rightGuy,
        this.handler,
        this.middle,
        required this.onDone});

  @override
  State<SimpleNumPad> createState() => _SimpleNumPadState();
}

class _SimpleNumPadState extends State<SimpleNumPad> {
  late String arg1;
  String arg2 = '';
  String operator = '';
  List<NumPadButtonModel> buttons = [
    NumPadButtonModel(1, 1, "Divider", "÷"),
    NumPadButtonModel(1, 2, "Multiply", "×"),
    NumPadButtonModel(1, 3, "Minus", "-"),
    NumPadButtonModel(1, 4, "Plus", "+"),
    NumPadButtonModel(2, 1, "7", "7"),
    NumPadButtonModel(2, 2, "4", "4"),
    NumPadButtonModel(2, 3, "1", "1"),
    NumPadButtonModel(2, 4, "=", "="),
    NumPadButtonModel(3, 1, "8", "8"),
    NumPadButtonModel(3, 2, "5", "5"),
    NumPadButtonModel(3, 3, "2", "2"),
    NumPadButtonModel(3, 4, "0", "0"),
    NumPadButtonModel(4, 1, "9", "9"),
    NumPadButtonModel(4, 2, "6", "6"),
    NumPadButtonModel(4, 3, "3", "3"),
    NumPadButtonModel(4, 4, "Dot", "."),
    NumPadButtonModel(5, 1, "Backspace", "⌫"),
    NumPadButtonModel(5, 2, "Done", "✔", rowSpan: 3),
  ];

  @override
  void initState() {
    super.initState();
    arg1 = widget.number == 0 ? '0' : widget.number.toString();

    if (widget.additionalButtons != null) {
      assert(widget.additionalButtons!.length < 3);

      buttons.last.rowSpan = 3 - widget.additionalButtons!.length;
      buttons.last.row = 2 + widget.additionalButtons!.length;
      for (var element in widget.additionalButtons!) {
        buttons.insert(buttons.length - 1, element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: widget.leftGuy ?? Container(),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const Text("Balance",
                          style: TextStyle(fontSize: 14)),
                      Text(
                          "$arg1${operator != '' ? ' $operator $arg2' : ''} ${widget.currency.symbol}",
                          style: const TextStyle(
                              fontSize: 24),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: widget.rightGuy ?? Container(),
                )
              ],
            ),
          ),
          widget.underBalance ?? Container(),
          widget.middle ?? Container(),
          const Divider(height: 1),
          SpannableGrid(
            columns: 5,
            rows: 4,
            cells: _getCells(context),
            showGrid: true,
            style: SpannableGridStyle(
              backgroundColor: Theme.of(context).colorScheme.surface,
              spacing: 0.5,
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  _handler(String char, BuildContext context) {
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

    if (widget.handler != null) {
      widget.handler!(char, context);
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
    if (number.contains('.') && number.split('.')[1].length == 2) {
      return number;
    }
    if (number == '0') {
      return digit;
    }

    return '$number$digit';
  }

  List<SpannableGridCellData> _getCells(BuildContext context) {
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
            onPressed: () => _handler(buttons[index].char, context),
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
        backgroundColor: WidgetStatePropertyAll(
            backgroundColor ?? Theme.of(context).colorScheme.surface),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          char,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class NumPadButtonModel {
  int column;
  int row;
  int? columnSpan;
  int? rowSpan;
  String label;
  String char;

  NumPadButtonModel(this.column, this.row, this.label, this.char,
      {this.rowSpan});
}
