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
              (context, index) => CategoryCard(
                  progress: 100,
                  color: value.get(index).color,
                  name: value.get(index).name,
                  icon: value.get(index).icon)),
        ));
  }
}