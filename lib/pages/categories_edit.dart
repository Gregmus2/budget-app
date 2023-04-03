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
        builder: (context, value, child) {
          return draggableCategoryGrid(
              value.length,
              (context, index) => GestureDetector(
                    key: ValueKey(index),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryCreatePage(
                                  category: value.get(index),
                                )),
                      );
                    },
                    child: CategoryCard(
                        progress: 100,
                        color: value.get(index).color,
                        name: value.get(index).name,
                        icon: value.get(index).icon,
                        total: 0,
                        left: 0,
                        currency: value.get(index).currency),
                  ),
              (oldIndex, newIndex) => value.reOrder(oldIndex, newIndex));
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
