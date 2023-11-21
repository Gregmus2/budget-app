import 'package:fb/db/account.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/pages/accounts.dart';
import 'package:fb/pages/category_create.dart';
import 'package:fb/ui/category_card.dart';
import 'package:fb/ui/subcategory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:spannable_grid/spannable_grid.dart';

class TransactionNumPad extends StatefulWidget {
  final Currency currency;
  final Account from;
  final TransferTarget to;
  final Function(double value, DateTime date, Account from, TransferTarget to, String note) onDoneFunc;

  const TransactionNumPad(
      {super.key, required this.currency, required this.onDoneFunc, required this.from, required this.to});

  @override
  State<TransactionNumPad> createState() => _TransactionNumPadState();
}

class _TransactionNumPadState extends State<TransactionNumPad> {
  DateTime selectedDate = DateTime.now();
  late Account from;
  late TransferTarget to;
  TransferTarget? toSubCategory;
  final TextEditingController _nameInput = TextEditingController();

  @override
  void initState() {
    from = widget.from;
    to = widget.to;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SimpleNumPad(
          currency: widget.currency,
          additionalButtons: [
            NumPadButtonModel(5, 2, "Date", "D"),
          ],
          handler: (char, context) {
            if (char == 'D') {
              showDatePicker(
                      context: context, initialDate: selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2100))
                  .then((value) {
                if (value != null) {
                  setState(() {
                    selectedDate = value;
                  });
                }
              });
            }
          },
          tabloItem: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FromToButton(
                      isLeft: true,
                      entity: from,
                      onSelected: (account) {
                        setState(() {
                          from = account as Account;
                        });
                      }),
                  const Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  ),
                  FromToButton(
                      isLeft: false,
                      entity: to,
                      onSelected: (target) {
                        setState(() {
                          to = target;
                        });
                      }),
                ],
              ),
              (to is Category && (to as Category).subCategories.isNotEmpty)
                  ? SizedBox(
                      height: 25,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: (to as Category).subCategories.length,
                        itemBuilder: (BuildContext context, int index) {
                          Category subcategory = (to as Category).subCategories[index];

                          return SubCategory(
                              label: subcategory.name,
                              color: subcategory.color,
                              icon: subcategory.icon,
                              inverse: (toSubCategory == subcategory),
                              onPressed: () {
                                setState(() {
                                  toSubCategory = subcategory;
                                });
                              });
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
          middle: Column(
            children: [
              const Divider(
                height: 1,
              ),
              TextField(
                style: const TextStyle(color: Colors.white, fontSize: 14),
                controller: _nameInput,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: 'Notes...', contentPadding: EdgeInsets.all(0), border: InputBorder.none),
              ),
            ],
          ),
          onDone: (number) => widget.onDoneFunc(number, selectedDate, from, toSubCategory ?? to, _nameInput.text),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Text(DateFormat().format(selectedDate), style: const TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}

class FromToButton extends StatelessWidget {
  final TransferTarget entity;
  final Function(TransferTarget) onSelected;
  final bool isLeft;

  const FromToButton({
    super.key,
    required this.entity,
    required this.onSelected,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> box = [
      Icon(
        entity.icon,
        color: entity.color,
      ),
      const SizedBox(
        width: 10,
      ),
      Text(entity.name, style: const TextStyle(color: Colors.white)),
    ];

    return TextButton(
      style: ButtonStyle(shape: MaterialStateProperty.all(const BeveledRectangleBorder())),
      onPressed: () {
        showGeneralDialog(
          context: context,
          barrierLabel: "Barrier",
          barrierDismissible: true,
          pageBuilder: (context, animation, secondaryAnimation) {
            return Center(
                child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: entity is Account
                  ? ListView(
                      children: buildAccountCards(context, (account) {
                      onSelected(account);

                      Navigator.pop(context);
                    }))
                  : GridView.count(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      crossAxisCount: 4,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 16,
                      children: buildCategoryCards(context, (category) {
                        onSelected(category);

                        Navigator.pop(context);
                      }),
                    ),
            ));
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: isLeft ? box : box.reversed.toList(),
        ),
      ),
    );
  }
}

class SimpleNumPad extends StatefulWidget {
  final double number;
  final Currency currency;
  final List<NumPadButtonModel>? additionalButtons;
  final Widget? tabloItem;
  final Widget? middle;
  final Function(String char, BuildContext context)? handler;
  final Function(double number) onDone;

  const SimpleNumPad(
      {super.key,
      this.number = 0,
      required this.currency,
      this.additionalButtons,
      this.tabloItem,
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
    List<Widget> sheet = [];
    if (widget.tabloItem != null) {
      sheet.add(widget.tabloItem!);
    }

    sheet.addAll([
      Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Text("Balance", style: TextStyle(color: Colors.white, fontSize: 14)),
            Text("$arg1${operator != '' ? ' $operator $arg2' : ''} ${widget.currency.symbol}",
                style: const TextStyle(fontSize: 24, color: Colors.white)),
          ],
        ),
      ),
      widget.middle ?? Container(),
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
    ]);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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

  const NumPadButton({super.key, required this.char, this.backgroundColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? Theme.of(context).scaffoldBackgroundColor),
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

class NumPadButtonModel {
  int column;
  int row;
  int? columnSpan;
  int? rowSpan;
  String label;
  String char;

  NumPadButtonModel(this.column, this.row, this.label, this.char, {this.rowSpan});
}
