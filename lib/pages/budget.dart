import 'package:fb/pages/page.dart' as page;
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/budget_card.dart';
import 'package:fb/ui/category_card.dart';
import 'package:fb/ui/date_bar.dart';
import 'package:fb/ui/drawer.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatelessWidget implements page.Page {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context);
    final StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);

    return Scaffold(
      drawer: const BudgetDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        bottom: const DateBar(),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListView(shrinkWrap: true, children: buildBudgetCards(context)),
          GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            crossAxisCount: 4,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            children: buildCategoryCards(context, (category) {
              showModalBottomSheet(
                context: context,
                builder: (context) => SimpleNumPad(
                  number: 0,
                  currency: category.currency,
                  onDone: (value) {
                    budgetProvider.add(
                        category.id, stateProvider.range.start.month, stateProvider.range.start.year, value);
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

  @override
  List<Widget>? getActions(BuildContext context) => null;

  @override
  bool ownAppBar() => true;

  @override
  Icon getIcon(BuildContext context) {
    final StateProvider stateProvider = Provider.of<StateProvider>(context);

    return Icon(Icons.savings, color: stateProvider.isMonthlyRange ? Colors.white : Colors.grey);
  }

  @override
  String getLabel() {
    return 'Budget';
  }
}

List<Widget> buildBudgetCards(BuildContext context) {
  final BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context);
  final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

  return List.generate(budgetProvider.length, (index) {
    final budget = budgetProvider.get(index);
    final category = categoryProvider.getById(budget.category);

    return BudgetCard(category: category, budget: budget.amount, onPressed: () {
      // todo edit budget
    });
  });
}
