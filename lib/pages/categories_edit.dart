import 'package:fb/pages/category_create.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/ui/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class CategoriesEditPage extends StatelessWidget {
  const CategoriesEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.white),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          return ReorderableGridView.count(
            dragWidgetBuilder: (index, child) => Scaffold(
              backgroundColor: Colors.transparent,
              body: child,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            onReorder: (oldIndex, newIndex) =>
                provider.reOrder(oldIndex, newIndex),
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            mainAxisExtent: 120,
            children: buildCategoryCards(context, (category) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryCreatePage(
                          category: category,
                        )),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoryCreatePage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
