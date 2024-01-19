import 'package:fb/models/category.dart';
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
          return const CategoryEditList();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToCategoryCreate(context, null);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// todo make it the same page with list, but with conditional actions
class CategoryEditList extends StatelessWidget {
  const CategoryEditList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CategoryProvider provider = Provider.of<CategoryProvider>(context);

    return SingleChildScrollView(
      child: ReorderableGridView.count(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          onReorder: (oldIndex, newIndex) => provider.reOrderCategory(oldIndex, newIndex),
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
          mainAxisExtent: 120,
          children: List.generate(
            provider.length,
            (index) {
              Category? category = provider.getCategory(index);

              return CategoryCard(
                key: ValueKey(index),
                category: category!,
                onPressed: () {
                  _navigateToCategoryCreate(context, category);
                },
              );
            },
          )),
    );
  }
}

void _navigateToCategoryCreate(BuildContext context, Category? category) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CategoryCreatePage(category: category)),
  );
}
