import 'package:fb/ui/card_button.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class CurrencyPicker extends StatefulWidget {
  final Function(Currency?) onChanged;
  final Color color;
  final Currency currency;

  const CurrencyPicker(
      {super.key,
      required this.onChanged,
      required this.color,
      required this.currency});

  @override
  State<CurrencyPicker> createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  late Currency currency;

  @override
  void initState() {
    super.initState();
    currency = widget.currency;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: buildCurrencies(),
    );
  }

  buildCurrencies() {
    var tiles = <CustomButton>[];
    List<Currency> currencies = Currencies().getRegistered().toList();
    currencies.sort((a, b) => (a.name.compareTo(b.name)));

    for (var element in currencies) {
      tiles.add(CustomButton(
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                element.symbol,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: (widget.currency == element)
                        ? widget.color
                        : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              element.name,
              style: TextStyle(
                color:
                    (widget.currency == element) ? widget.color : Colors.white,
              ),
            ),
          ],
        ),
        onPressed: () {
          setState(() {
            currency = element;
          });
          widget.onChanged(element);
        },
      ));
    }

    return tiles;
  }
}
