import 'package:fb/ext/string.dart';
import 'package:fb/models/account.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/ui/color_picker.dart';
import 'package:fb/ui/currency_picker.dart';
import 'package:fb/ui/custom_button.dart';
import 'package:fb/ui/icon_picker.dart';
import 'package:fb/ui/numpad.dart';
import 'package:fb/ui/text_input.dart';
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
    final AccountProvider provider = Provider.of<AccountProvider>(context, listen: false);

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
            children: [const Text("New account"), EntityNameTextInput(nameInput: _nameInput, items: provider.items)],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  provider.upsert(widget.account, _nameInput.text, icon, color, currency, type, balance);

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check, color: Colors.white)),
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
            keyStringValueCustomButton("Type", type.name, color, () => _showTypeDialog()),
            keyStringValueCustomButton("Balance", "${balance.toString()} ${currency.symbol}", color, () {
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
            }),
            keyStringValueCustomButton("Currency", currency.code, color, () {
              showCurrencyDialog(
                context,
                (currency) {
                  setState(() {
                    this.currency = currency;
                  });
                },
              );
            }, subtitle: currency.name),
            keyValueCustomButton("Icon", Icon(icon, color: color), color, () {
              showIconDialog(context, color, icon, (icon) {
                setState(() {
                  this.icon = icon;
                });
              });
            }),
            keyValueCustomButton("Color", Icon(Icons.circle, color: color), color, () {
              showColorDialog(context, color, (color) {
                setState(() {
                  this.color = color;
                });
              });
            }),
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
            children: List<Widget>.generate(
                AccountType.values.length,
                (index) => SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          type = AccountType.values[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        AccountType.values[index].name.capitalize(),
                        style: textStyle,
                      ),
                    )));
      },
    );
  }

  @override
  void dispose() {
    _nameInput.dispose();
    super.dispose();
  }
}
