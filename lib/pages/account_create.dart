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
                    provider.add(_nameInput.text, icon, color, currency, type);
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
                icon: const Icon(Icons.check)),
            // create delete button
            if (widget.account != null)
              IconButton(
                  onPressed: () {
                    provider.remove(widget.account!);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete)),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "GENERAL",
              ),
              Tab(
                text: "CURRENCY",
              ),
              Tab(
                text: "ICON",
              ),
              Tab(
                text: "COLOR",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              children: [
                const SizedBox(height: 10),
                CustomButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Type",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        Text(type.name)
                      ],
                    ),
                  ),
                  onPressed: () {
                    _showTypeDialog();
                  },
                ),
                const Divider(height: 0),
                CustomButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Balance",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        Text("${balance.toString()} ${currency.symbol}"),
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
              ],
            ),
            CurrencyPicker(
              currency: currency,
              onChanged: (currency) {
                setState(() {
                  this.currency = currency!;
                });
              },
              color: color,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconPicker(
                color: color,
                icon: icon,
                onChange: (icon) {
                  setState(() {
                    this.icon = icon;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ColorPicker(
                color: color,
                onChange: (color) {
                  setState(() {
                    this.color = color;
                  });
                },
              ),
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
