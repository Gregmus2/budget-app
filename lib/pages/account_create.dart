import 'package:fb/ext/string.dart';
import 'package:fb/models/account.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/ui/color_picker.dart';
import 'package:fb/ui/currency_picker.dart';
import 'package:fb/ui/custom_button.dart';
import 'package:fb/ui/icon_picker.dart';
import 'package:fb/ui/numpad.dart';
import 'package:fb/ui/text_input.dart';
import 'package:fb/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountCreatePage extends StatefulWidget {
  final Account? account;

  const AccountCreatePage({super.key, this.account});

  @override
  State<AccountCreatePage> createState() => _AccountCreatePageState();
}

class _AccountCreatePageState extends State<AccountCreatePage> {
  late IconData _icon;
  late Color _color;
  late Currency? _currency;
  late AccountType _type;
  late double _balance;
  late bool _archived;
  late final TextEditingController _nameInput;

  @override
  void initState() {
    super.initState();

    _icon = widget.account?.icon ?? Icons.hourglass_empty;
    _color = widget.account?.color ?? Colors.blue;
    _currency = widget.account?.currency;
    _type = widget.account?.type ?? AccountType.regular;
    _balance = widget.account?.balance ?? 0;
    _archived = widget.account?.archived ?? false;
    _nameInput = TextEditingController(text: widget.account?.name);
  }

  @override
  Widget build(BuildContext context) {
    final AccountProvider provider = Provider.of<AccountProvider>(context);
    final StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);

    if (_currency == null) {
      _currency = stateProvider.defaultCurrency;
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _color,
          foregroundColor: Colors.white,
          toolbarHeight: 100,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("New account"),
              EntityNameTextInput(nameInput: _nameInput, isUnique: provider.isNotExists)
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  provider.upsert(widget.account, _nameInput.text, _icon, _color, _currency!, _type, _balance);

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
            EntitySettingString(label: "Type", value: _type.name, color: _color, onPressed: () => _showTypeDialog()),
            EntitySettingString(
                label: "Balance",
                value: "${_balance.toString()} ${_currency!.symbol}",
                color: _color,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SimpleNumPad(
                      number: _balance,
                      currency: _currency!,
                      onDone: (value) {
                        setState(() {
                          _balance = value;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),
            EntitySettingString(
                label: "Currency",
                value: _currency!.isoCode,
                color: _color,
                onPressed: () {
                  showCurrencyDialog(
                    context,
                    (currency) {
                      setState(() {
                        _currency = currency;
                      });
                    },
                  );
                },
                subtitle: _currency!.name),
            EntitySetting(
                label: "Icon",
                value: Icon(_icon, color: _color),
                color: _color,
                onPressed: () {
                  showIconDialog(context, _color, _icon, (icon) {
                    setState(() {
                      _icon = icon;
                    });
                  });
                }),
            EntitySetting(
                label: "Color",
                value: Icon(Icons.circle, color: _color),
                color: _color,
                onPressed: () {
                  showColorDialog(context, _color, (color) {
                    setState(() {
                      _color = color;
                    });
                  });
                }),
            EntitySettingBool(
              label: "Archived",
              value: _archived,
              color: _color,
              onPressed: (value) {
                setState(() {
                  _archived = value;
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
            backgroundColor: Theme.of(context).colorScheme.background,
            children: List<Widget>.generate(
                AccountType.values.length,
                (index) => SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          _type = AccountType.values[index];
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
