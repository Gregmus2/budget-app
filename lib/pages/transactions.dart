import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

import '../ui/numpad.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionProvider provider =
        Provider.of<TransactionProvider>(context);
    final AccountProvider accountProvider =
        Provider.of<AccountProvider>(context);
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context);

    List<Widget> actions = [];
    if (accountProvider.items.isNotEmpty && categoryProvider.items.isNotEmpty) {
      actions.add(
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TransactionNumPad(
                    currency: CommonCurrencies().euro,
                    // todo replace with default currency from user configuration
                    onDoneFunc: (value, date, from, to, note) {
                      provider.add(note, from, to, value, value, date);
                      Navigator.pop(context);
                    },
                    from: accountProvider.items.last,
                    to: categoryProvider.items.last,
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: actions,
      ),
      body: Row(),
    );
  }
}
