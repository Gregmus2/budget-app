import 'dart:collection';

import 'package:fb/repository.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  final Repository repo;

  UnmodifiableListView<Category> get items => UnmodifiableListView(_categories);

  CategoryProvider(this.repo);

  Future<void> init() async {
    _categories = await repo.listCategories();
  }

  int get length => _categories.length;

  void add(String name, IconData icon, Color color, Currency currency) {
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

  void update(Category category) {
    final targetCategory = _categories.firstWhere((element) => element.id == category.id);
    _categories[_categories.indexOf(targetCategory)] = category;
    repo.update(category);
    notifyListeners();
  }

  void remove(int index) {
    repo.delete(_categories[index]);
    _categories.removeAt(index);
    notifyListeners();
  }
}
