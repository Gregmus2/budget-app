import 'dart:collection';

import 'package:fb/repository.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  final Repository repo;

  UnmodifiableListView<Category> get items => UnmodifiableListView(_categories);

  CategoryProvider(this.repo) {
    repo.listCategories().then((value) {
      _categories = value;
    });
  }

  int get length => _categories.length;

  void add(Category category) {
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
