import 'package:fb/models/category.dart';
import 'package:fb/models/transfer_target.dart';
import 'package:fb/pages/categories.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/category_card.dart';
import 'package:fb/ui/date_bar.dart';
import 'package:fb/ui/drawer.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesListPage extends StatelessWidget {
  const CategoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const BudgetDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CategoryNavigatorRoutes.categoriesEdit);
              },
              icon: const Icon(Icons.edit, color: Colors.white))
        ],
        foregroundColor: Colors.white,
        bottom: const DateBar(),
      ),
      // this is fucking insane, but for some reason, SingleChildScrollView prevents elements from rerendering
      body: const SingleChildScrollView(child: CategoriesGrid()),
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);

    return GridView.count(
      physics: const ScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 16,
      childAspectRatio: 0.7,
      padding: const EdgeInsets.symmetric(vertical: 10),
      shrinkWrap: true,
      children: List.generate(
        provider.length,
        (index) {
          Category category = provider.getCategory(index)!;

          return CategoryCard(
            key: ValueKey(index),
            category: category,
            onPressed: () {
              _openNumPad(context, category);
            },
          );
        },
      ),
    );
  }

  void _openNumPad(BuildContext context, Category category) {
    final TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    final AccountProvider accountProvider = Provider.of<AccountProvider>(context, listen: false);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TransactionNumPad(
            onDoneFunc: (value, date, from, to, note) {
              transactionProvider.add(note, from, to, value, value, date);
              Navigator.pop(context);
            },
            from: (category.type == CategoryType.expenses ? accountProvider.items.last : category) as TransferTarget,
            to: (category.type == CategoryType.income ? accountProvider.items.last : category) as TransferTarget,
          ),
        ],
      ),
    );
  }
}
