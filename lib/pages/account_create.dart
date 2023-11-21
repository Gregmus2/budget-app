import 'package:fb/db/account.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/ui/card_button.dart';
import 'package:fb/ui/color_picker.dart';
import 'package:fb/ui/currency_picker.dart';
import 'package:fb/ui/icon_picker.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

class AccountCreatePage extends StatefulWidget {
  final Account? account;

  const AccountCreatePage({super.key, this.account});

  @override
  State<AccountCreatePage> createState() => _AccountCreatePageState();
}

class _AccountCreatePageState extends State<AccountCreatePage> {
  late IconData icon;
  late Color color;
  late Currency currency;
  late AccountType type;
  late double balance;
  late final TextEditingController _nameInput;

  @override
  void initState() {
    super.initState();

    icon = widget.account?.icon ?? Icons.hourglass_empty;
    color = widget.account?.color ?? Colors.blue;
    currency = widget.account?.currency ?? CommonCurrencies().euro;
    type = widget.account?.type ?? AccountType.regular;
    balance = widget.account?.balance ?? 0;
    _nameInput = TextEditingController(text: widget.account?.name);
  }

  @override
  Widget build(BuildContext context) {
    final AccountProvider provider = Provider.of<AccountProvider>(context);

    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color,
          foregroundColor: Colors.white,
          toolbarHeight: 100,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("New account"),
              TextFormField(
                controller: _nameInput,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                style: const TextStyle(color: Colors.white),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (widget.account == null) {
                    provider.add(_nameInput.text, icon, color, currency, type, balance);
                  } else {
                    widget.account!
                      ..name = _nameInput.text
                      ..icon = icon
                      ..color = color
                      ..type = type
                      ..balance = balance
                      ..currency = currency;
                    provider.update(widget.account!);
                  }

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check, color: Colors.white)),
            // create delete button
            if (widget.account != null)
              IconButton(
                  onPressed: () {
                    provider.remove(widget.account!);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete, color: Colors.white)),
          ],
        ),
        body: ListView(
          children: <Widget>[
            CustomButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Type", style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text(type.name, style: TextStyle(color: color))
                  ],
                ),
              ),
              onPressed: () {
                _showTypeDialog();
              },
            ),
            CustomButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Balance", style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text("${balance.toString()} ${currency.symbol}", style: TextStyle(color: color)),
                  ],
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SimpleNumPad(
                    number: balance,
                    currency: currency,
                    onDone: (value) {
                      setState(() {
                        balance = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            CustomButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Currency", style: TextStyle(color: Colors.white, fontSize: 15)),
                        Text(currency.name, style: TextStyle(color: color))
                      ],
                    ),
                    Text(currency.code, style: TextStyle(color: color))
                  ],
                ),
              ),
              onPressed: () {
                showCurrencyDialog(context, (currency) {
                  setState(() {
                    this.currency = currency;
                  });
                });
              },
            ),
            CustomButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Icon", style: TextStyle(color: Colors.white, fontSize: 15)),
                    Icon(icon, color: color)
                  ],
                ),
              ),
              onPressed: () {
                showIconDialog(context, color, icon, (icon) {
                  setState(() {
                    this.icon = icon;
                  });
                });
              },
            ),
            CustomButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Color", style: TextStyle(color: Colors.white, fontSize: 15)),
                    Icon(Icons.circle, color: color)
                  ],
                ),
              ),
              onPressed: () {
                showColorDialog(context, color, (color) {
                  setState(() {
                    this.color = color;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTypeDialog() async {
    const TextStyle textStyle = TextStyle(color: Colors.white);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  type = AccountType.regular;
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Regular',
                style: textStyle,
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  type = AccountType.debt;
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Debt',
                style: textStyle,
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  type = AccountType.savings;
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Savings',
                style: textStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameInput.dispose();
    super.dispose();
  }
}
