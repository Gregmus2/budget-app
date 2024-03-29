import 'package:fb/models/category.dart';
import 'package:fb/pages/page.dart' as page;
import 'package:fb/providers/budget.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
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
    return Scaffold(
      drawer: const BudgetDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        bottom: const DateBar(),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [BudgetList(), NoBudgetCategoriesList()],
        ),
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

class BudgetList extends StatelessWidget {
  const BudgetList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: List.generate(
        budgetProvider.length,
        (index) {
          final budget = budgetProvider.get(index);

          return BudgetCard(
              category: categoryProvider.getByID(budget.category),
              budget: budget.amount,
              onPressed: () {
                // todo edit budget
              });
        },
      ),
    );
  }
}

class NoBudgetCategoriesList extends StatelessWidget {
  const NoBudgetCategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BudgetProvider budgetProvider = Provider.of<BudgetProvider>(context);
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    List<Category> categories = categoryProvider.getExclude(budgetProvider.getCategories());

    return GridView.count(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: 0.7,
      crossAxisSpacing: 10,
      mainAxisSpacing: 16,
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: List.generate(
          categories.length,
          (index) => CategoryCard(
                key: ValueKey(index),
                category: categories[index],
                onPressed: () {
                  _openNumPad(budgetProvider, context, categories[index]);
                },
              )),
    );
  }

  void _openNumPad(BudgetProvider budgetProvider, BuildContext context, Category category) {
    final StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) => SimpleNumPad(
        number: 0,
        currency: category.currency,
        onDone: (value) {
          budgetProvider.add(category.id, stateProvider.range.start.month, stateProvider.range.start.year, value);
          Navigator.pop(context);
        },
      ),
    );
  }
}
