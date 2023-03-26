import 'package:fb/pages/category_create.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/ui/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesEditPage extends StatefulWidget {
  const CategoriesEditPage({super.key});

  @override
  State<CategoriesEditPage> createState() => _CategoriesEditPageState();
}

class _CategoriesEditPageState extends State<CategoriesEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<CategoryProvider>(
        builder: (context, value, child) => categoryGrid(
            value.length,
            (context, index) => GestureDetector(
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
                      icon: value.get(index).icon),
                )),
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
