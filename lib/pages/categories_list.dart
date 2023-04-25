import 'package:fb/models.dart';
import 'package:fb/pages/categories.dart';
import 'package:fb/pages/category_create.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/ui/category_card.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class CategoriesListPage extends StatelessWidget {
  const CategoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<CategoryStat> categoriesStat = [];
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    final Random random = Random();

    // mock data
    for (var i = 0; i < provider.length; i++) {
      double total = random.nextDouble() * 1000;
      categoriesStat.add(CategoryStat(
          provider.get(i),
          total - random.nextDouble() * total,
          total,
          provider.get(i).currency.symbol));
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, CategoryNavigatorRoutes.categoriesEdit);
                },
                icon: const Icon(Icons.edit))
          ],
        ),
        body: GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10),
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
          children: buildCategoryCards(context, (category) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryCreatePage(
                        category: category,
                      )),
            );
          }),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
