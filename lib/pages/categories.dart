import 'package:english_words/english_words.dart';
import 'package:fb/models.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/repository.dart';
import 'package:fb/ui/category.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import 'categories_edit.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.add_shopping_cart,
      Icons.access_alarm,
      Icons.call,
      Icons.laptop
    ];
    List<CategoryStat> categories = [];
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    final Random random = Random();
    // mock data
    for (var i = 0; i < provider.length; i++) {
      int total = random.nextInt(1000);
      categories.add(CategoryStat(
          provider.get(i), total - random.nextInt(total), total, '\$'));
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoriesEditPage()),
                  );
                },
                icon: const Icon(Icons.edit))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            provider.add(Category(
                id: random.nextInt(100),
                name: WordPair.random().asPascalCase,
                icon: icons[random.nextInt(icons.length)],
                color: Color((random.nextDouble() * 0xFFFFFF).toInt())));
          },
          child: const Icon(Icons.add),
        ),
        body: categoryGrid(categories.length, (context, int index) {
          return CategoryCard(
            progress: 100 * categories[index].left / categories[index].total,
            color: categories[index].category.color,
            name: categories[index].category.name,
            left: '${categories[index].left}\$',
            total: '${categories[index].total}\$',
            icon: categories[index].category.icon,
          );
        }) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}