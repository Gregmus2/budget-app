import 'dart:collection';

import 'package:fb/repository.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  final Repository repo;

  UnmodifiableListView<Category> get items => UnmodifiableListView(_categories);

  CategoryProvider(this.repo);

  Future<void> init() async {
    _categories = await repo.listCategories();
  }

  int get length => _categories.length;

  void add(String name, IconData icon, Color color, String currency) {
    Category category = Category(
        id: _categories.length,
        name: name,
        icon: icon,
        color: color,
        currency: currency);
    _categories.add(category);
    repo.createCategory(category);
    notifyListeners();
  }

  Category get(int index) {
    return _categories[index];
  }

  void remove(int index) {
    repo.delete(_categories[index]);
    _categories.removeAt(index);
    notifyListeners();
  }
}
