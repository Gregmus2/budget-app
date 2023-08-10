import 'package:fb/pages/categories.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/category_card.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesListPage extends StatelessWidget {
  const CategoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context);
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context);

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, CategoryNavigatorRoutes.categoriesEdit);
                },
                icon: const Icon(Icons.edit, color: Colors.white))
          ],
          foregroundColor: Colors.white,
        ),
        body: GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10),
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
          children: buildCategoryCards(context, (category) {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TransactionNumPad(
                    currency: category.currency,
                    onDoneFunc: (value, date, from, to, note) {
                      transactionProvider.add(note, from, to, value, value, date);
                      Navigator.pop(context);
                    },
                    from: accountProvider.items.last,
                    to: category,
                  ),
                ],
              ),
            );
          }),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
