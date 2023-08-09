import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
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
        children: buildBudgetCards(context),
        /*Flexible(
            child: Container(
              child: GridView.count(
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
                        budgetProvider.add(category.id, stateProvider.month, value);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),
              ),
            ),
          )*/
        // ],
      ),
    );
  }
}

List<Widget> buildBudgetCards(BuildContext context) {
  final BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context);
  final CategoryProvider categoryProvider =
      Provider.of<CategoryProvider>(context);

  // todo show all budgets and then categories icons with unassigned categories

  return List.generate(budgetProvider.length, (index) {
    final category = categoryProvider.get(budgetProvider.get(index).category);
    final budget = budgetProvider.get(index);

    return BudgetCard(
        category: category, spent: 0, budget: budget.amount, onPressed: () {});
  });
}
