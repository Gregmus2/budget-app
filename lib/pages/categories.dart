import 'package:fb/models.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/ui/category.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import '../repository.dart';
import 'categories_edit.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<CategoryStat> categoriesStat = [];
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    final Random random = Random();

    List<Category> categories = provider.list();
    // mock data
    for (var i = 0; i < provider.length; i++) {
      int total = random.nextInt(1000);
      categoriesStat.add(CategoryStat(provider.get(i),
          total - random.nextInt(total), total, provider.get(i).currency.symbol));
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
        body: categoryGrid(categoriesStat.length, (context, int index) {
          return CategoryCard(
            progress: 100 * categoriesStat[index].left / categoriesStat[index].total,
            color: categoriesStat[index].category.color,
            name: categoriesStat[index].category.name,
            left: '${categoriesStat[index].left}${categoriesStat[index].currency}',
            total: '${categoriesStat[index].total}${categoriesStat[index].currency}',
            icon: categoriesStat[index].category.icon,
          );
        }) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
