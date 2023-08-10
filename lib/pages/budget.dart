import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/budget_card.dart';
import 'package:fb/ui/category_card.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context);
    final StateProvider stateProvider = Provider.of<StateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListView(shrinkWrap: true, children: buildBudgetCards(context)),
          GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            children: buildCategoryCards(context, (category) {
              showModalBottomSheet(
                context: context,
                builder: (context) => SimpleNumPad(
                  number: 0,
                  currency: category.currency,
                  onDone: (value) {
                    budgetProvider.add(category.id, stateProvider.month,
                        stateProvider.year, value);
                    Navigator.pop(context);
                  },
                ),
              );
            }, exclude: budgetProvider.getCategories()),
          )
        ],
      ),
    );
  }
}

List<Widget> buildBudgetCards(BuildContext context) {
  final BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context);
  final CategoryProvider categoryProvider =
      Provider.of<CategoryProvider>(context);
  final TransactionProvider transactionProvider =
      Provider.of<TransactionProvider>(context);
  final StateProvider stateProvider = Provider.of<StateProvider>(context);
  Map<int, double> totals = transactionProvider.getMonthlyExpense(
      stateProvider.month, stateProvider.year);

  return List.generate(budgetProvider.length, (index) {
    final budget = budgetProvider.get(index);
    final category = categoryProvider.getById(budget.category);

    return BudgetCard(
        category: category,
        spent: totals[budget.category] ?? 0,
        budget: budget.amount,
        onPressed: () {});
  });
}
