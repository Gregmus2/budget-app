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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _isEditing ? null : const BudgetDrawer(),
      appBar: _isEditing ? _editAppBar(context) : _listAppBar(context, () => setState(() => _isEditing = true)),
      // for some reason, SingleChildScrollView prevents elements from rerendering
      // todo show archived categories separately (ideally to render them only when open spoiler)
      body: SingleChildScrollView(
          child: CategoriesGrid(
        onPressed: (context, category) =>
            _isEditing ? _navigateToCategoryCreate(context, category) : _openNumPad(context, category),
      )),
      floatingActionButton: _isEditing
          ? FloatingActionButton(
              onPressed: () {
                _navigateToCategoryCreate(context, null);
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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

  const CategoriesGrid({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);

    return ReorderableGridView.count(
      onReorder: (oldIndex, newIndex) => provider.reOrderCategory(oldIndex, newIndex),
      physics: const ScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 16,
      childAspectRatio: 0.7,
      mainAxisExtent: 120,
      padding: const EdgeInsets.only(top: 10),
      shrinkWrap: true,
      children: List.generate(
        provider.length,
        (index) {
          Category category = provider.getCategory(index)!;

          return CategoryCard(
            key: ValueKey(index),
            category: category,
            onPressed: () => onPressed(context, category),
          );
        },
      ),
    );
  }
}
