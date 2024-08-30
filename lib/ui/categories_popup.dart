import 'package:fb/db/category.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/ui/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySelectionPopup extends StatelessWidget {
  const CategorySelectionPopup({
    super.key,
    required this.onPressed,
  });

  final Function(Category) onPressed;

  @override
  Widget build(BuildContext context) {
    CategoryProvider provider = Provider.of<CategoryProvider>(context, listen: false);
    List<Category> categories = provider.getCategories();

    return SingleChildScrollView(
      child: GridView.count(
          padding: const EdgeInsets.symmetric(vertical: 10),
          crossAxisCount: 4,
          childAspectRatio: 0.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: categories
              .map((category) => CategoryCard(
            key: ValueKey(category.id),
            category: category,
            onPressed: () => onPressed(category),
          ))
              .toList()),
    );
  }
}