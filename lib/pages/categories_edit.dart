import 'package:fb/pages/category_create.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/ui/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesEditPage extends StatelessWidget {
  const CategoriesEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          return draggableCategoryGrid(
              provider.length,
              (context, index) => GestureDetector(
                    key: ValueKey(index),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryCreatePage(
                                  category: provider.get(index),
                                )),
                      );
                    },
                    child: CategoryCard(
                        progress: 100,
                        color: provider.get(index).color,
                        name: provider.get(index).name,
                        icon: provider.get(index).icon,
                        total: 0,
                        left: 0,
                        currency: provider.get(index).currency),
                  ),
              (oldIndex, newIndex) => provider.reOrder(oldIndex, newIndex));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryCreatePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
