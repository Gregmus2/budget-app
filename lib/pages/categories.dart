import 'package:fb/models/category.dart';
import 'package:fb/models/transfer_target.dart';
import 'package:fb/pages/category_create.dart';
import 'package:fb/pages/page.dart' as page;
import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/category_card.dart';
import 'package:fb/ui/date_bar.dart';
import 'package:fb/ui/drawer.dart';
import 'package:fb/ui/numpad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class CategoriesPage extends StatefulWidget implements page.Page {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();

  @override
  List<Widget>? getActions(BuildContext context) => null;

  @override
  bool ownAppBar() => true;

  @override
  Icon getIcon(BuildContext _) {
    return const Icon(Icons.list, color: Colors.white);
  }

  @override
  String getLabel() {
    return 'Categories';
  }
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _isEditing = false;
  bool _isArchived = false;
  bool _isIncome = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: _isEditing ? null : const BudgetDrawer(),
      appBar: _appBar(context),
      body: CategoriesGrid(
        archived: _isArchived,
        type: _isIncome ? CategoryType.income : CategoryType.expenses,
        onPressed: (context, category) =>
            _isEditing ? _navigateToCategoryCreate(context, category) : _openNumPad(context, category),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FloatingActionButton(
            heroTag: 'archive',
            onPressed: () {
              setState(() {
                _isArchived = !_isArchived;
              });
            },
            backgroundColor: _isArchived ? colorScheme.primary : Colors.grey,
            child: const Icon(Icons.archive_rounded, color: Colors.white),
          ),
          if (_isEditing)
            FloatingActionButton(
              heroTag: 'add',
              onPressed: () {
                _navigateToCategoryCreate(context, null);
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
        ]),
      ),
    );
  }

  void _navigateToCategoryCreate(BuildContext context, Category? category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryCreatePage(category: category)),
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

  AppBar _appBar(BuildContext context) {
    return  AppBar(
      foregroundColor: Colors.white,
      leading: _isEditing
          ? IconButton(
          onPressed: () => setState(() => _isEditing = false),
          icon: const Icon(Icons.arrow_back, color: Colors.white))
          : null,
      bottom: _isEditing ? null : const DateBar(),
      actions: _isEditing
          ? null
          : [
        IconButton(
            onPressed: () => setState(() => _isEditing = true),
            icon: const Icon(Icons.edit, color: Colors.white)),
      ],
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
              onPressed: () => setState(() {
                _isIncome = false;
              }),
              child: Text(
                'Expenses',
                style: TextStyle(fontSize: 15, color: _isIncome ? Colors.grey : null),
              )),
          const SizedBox(width: 20),
          TextButton(
              onPressed: () => setState(() {
                _isIncome = true;
              }),
              child: Text('Income',
                  style: TextStyle(fontSize: 15, color: _isIncome ? Colors.greenAccent : Colors.grey))),
        ],
      ),
      centerTitle: true,
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  final Function(BuildContext, Category) onPressed;
  final bool archived;
  final CategoryType? type;

  const CategoriesGrid({
    super.key,
    required this.onPressed,
    required this.archived,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    final List<Category> categories = provider.getCategories(archived: archived, type: type);

    return ReorderableGridView.builder(
        onReorder: (oldIndex, newIndex) => provider.reOrderCategory(categories[oldIndex], categories[newIndex]),
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
          mainAxisExtent: 120,
        ),
        padding: const EdgeInsets.only(top: 10),
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, index) => CategoryCard(
              key: ValueKey(categories[index].id),
              category: categories[index],
              onPressed: () => onPressed(context, categories[index]),
            ));
  }
}
