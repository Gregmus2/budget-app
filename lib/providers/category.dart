import 'dart:collection';

import 'package:fb/db/category.dart';
import 'package:fb/db/repository.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  final Repository repo;

  UnmodifiableListView<Category> get items => UnmodifiableListView(_categories);

  CategoryProvider(this.repo);

  Future<void> init() async {
    _categories = await repo.listCategories();
    _categories.sort((a, b) => a.order.compareTo(b.order));
  }

  int get length => _categories.length;

  void add(String name, IconData icon, Color color, Currency currency) {
    Category category = Category(
        id: _categories.length,
        name: name,
        icon: icon,
        color: color,
        currency: currency,
        order: _categories.isNotEmpty ? _categories.last.order + 1 : 0);
    _categories.add(category);
    repo.create(category);
    notifyListeners();
  }

  Category get(int index) {
    return _categories[index];
  }

  List<Category> list() {
    return _categories;
  }

  void update(Category category) {
    final targetCategory = _categories.firstWhere((element) => element.id == category.id);
    _categories[_categories.indexOf(targetCategory)] = category;
    repo.update(category);
    notifyListeners();
  }

  void remove(Category category) {
    _categories.remove(category);
    repo.delete(category);
    notifyListeners();
  }

  void reOrder(int from, int to) {
    if (from == to) {
      return;
    }

    _categories[from].order = _categories[to].order;
    if (to > from) {
      for (var i = from + 1; i <= to; i++) {
        _categories[i].order--;
        repo.update(_categories[i]);
      }
    } else {
      for (var i = to; i < from; i++) {
        _categories[i].order++;
        repo.update(_categories[i]);
      }
    }
    _categories.sort((a, b) => a.order.compareTo(b.order));

    notifyListeners();
  }

  Category getById(int id) {
    return _categories.firstWhere((element) => element.id == id);
  }
}
