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

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: _isEditing ? null : const BudgetDrawer(),
      appBar: _isEditing ? _editAppBar(context) : _listAppBar(context, () => setState(() => _isEditing = true)),
      // todo show archived categories separately
      body: CategoriesGrid(
        archived: _isArchived,
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
            child: const Icon(Icons.archive_rounded, color: Colors.white), // todo if archived show somehow it
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

  AppBar _editAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      leading: IconButton(
          onPressed: () => setState(() => _isEditing = false), icon: const Icon(Icons.arrow_back, color: Colors.white)),
    );
  }

  AppBar _listAppBar(BuildContext context, VoidCallback onPressed) {
    return AppBar(
      actions: [IconButton(onPressed: onPressed, icon: const Icon(Icons.edit, color: Colors.white))],
      foregroundColor: Colors.white,
      bottom: const DateBar(),
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  final Function(BuildContext, Category) onPressed;
  final bool archived;

  const CategoriesGrid({
    super.key,
    required this.onPressed,
    required this.archived,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    final List<Category> categories = provider.getCategories(archived: archived);

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
