import 'package:fb/db/account.dart';
import 'package:fb/db/category.dart';
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
    final TransactionProvider provider = Provider.of<TransactionProvider>(context);
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    final Account DefaultAccount = accountProvider.items.last; // todo replace with last transaction account
    final Category DefaultCategory = categoryProvider.items.last; // todo replace with last transaction category

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    children: [
                      TransactionNumPad(
                        currency: CommonCurrencies().euro, // todo replace with default currency from user configuration
                        onDoneFunc: (value, date, from, to) {
                         print(value);
                         print(date);
                          Navigator.pop(context);
                        },
                        from: DefaultAccount,
                        to: DefaultCategory,
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Row(),
    );
  }
}
