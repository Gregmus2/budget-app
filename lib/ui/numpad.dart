import 'package:fb/db/account.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:spannable_grid/spannable_grid.dart';

class TransactionNumPad extends StatelessWidget {
  final Currency currency;
  final DateTime _selectedDate = DateTime.now();
  Account from;
  TransferTarget to;
  final Function(double value, DateTime date, Account from, TransferTarget to)
      onDoneFunc;

  TransactionNumPad(
      {super.key, required this.currency,
      required this.onDoneFunc,
      required this.from,
      required this.to});

  @override
  Widget build(BuildContext context) {
    return SimpleNumPad(
      currency: currency,
      additionalButtons: [
        _NumPadButton(5, 2, "Date", "D"),
      ],
      tabloItems: [
        Row(
          children: [
            FromToButton(entity: from),
            const Icon(Icons.arrow_right),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.arrow_right),
            FromToButton(entity: to),
          ],
        )
      ],
      footer: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Text(DateFormat().format(_selectedDate),
            style: const TextStyle(color: Colors.white)),
      ),
      onDone: (number) =>
          onDoneFunc(number, _selectedDate, from, to),
    );
  }
}

class FromToButton extends StatelessWidget {
  const FromToButton({
    super.key,
    required this.entity,
  });

  final TransferTarget entity;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(const BeveledRectangleBorder())),
      onPressed: () {
        // todo modal window to select account using the same widget as in account page
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Icon(
              entity.icon,
              color: entity.color,
            ),
            Text(entity.name,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class SimpleNumPad extends StatefulWidget {
  final double number;
  final Currency currency;
  final List<_NumPadButton>? additionalButtons;
  List<Widget>? tabloItems;
  Widget? footer;
  final Function(String char, BuildContext context)? handler;
  final Function(double number) onDone;

  SimpleNumPad(
      {super.key, this.number = 0,
      required this.currency,
      this.additionalButtons,
      this.tabloItems,
      this.footer,
      this.handler,
      required this.onDone});

  @override
  State<SimpleNumPad> createState() => _SimpleNumPadState();
}

class _SimpleNumPadState extends State<SimpleNumPad> {
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
    List<Widget> sheet = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.tabloItems != null ? widget.tabloItems![0] : Container(),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Text("Balance",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                Text(
                    "$arg1${operator != '' ? ' $operator $arg2' : ''} ${widget.currency.symbol}",
                    style: const TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ),
          widget.tabloItems != null ? widget.tabloItems![1] : Container(),
        ],
      ),
      const Divider(height: 1),
      SpannableGrid(
        columns: 5,
        rows: 4,
        cells: _getCells(context),
        showGrid: true,
        style: SpannableGridStyle(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          spacing: 0.5,
        ),
      ),
      const Divider(height: 1),
    ];
    if (widget.footer != null) {
      sheet.add(widget.footer!);
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: sheet,
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

  _NumPadButton(this.column, this.row, this.label, this.char, {this.rowSpan});
}
