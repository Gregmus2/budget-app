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

    for (var category in _categories) {
      if (category.parent != null) {
        getById(category.parent!).subCategories.add(category);
      }
    }

    for (var category in _categories) {
      category.subCategories.sort((a, b) => a.order.compareTo(b.order));
    }
  }

  int get length => _categories.length;

  Category add(
      String name, IconData icon, Color color, Currency currency, CategoryType type, List<Category> subCategories) {
    Category category = Category(
      id: _categories.length,
      name: name,
      icon: icon,
      color: color,
      currency: currency,
      order: _categories.isNotEmpty ? _categories.last.order + 1 : 0,
      type: type,
    );
    _categories.add(category);
    repo.create(category);

    for (int i = 0; i < subCategories.length; i++) {
      Category subCategory = Category(
        id: _categories.length + 1 + i,
        name: subCategories[i].name,
        icon: subCategories[i].icon,
        color: color,
        currency: currency,
        order: category.subCategories.isNotEmpty ? category.subCategories.last.order + 1 : 0,
        parent: category.id,
        type: type,
      );
      category.subCategories.add(subCategory);
      _categories.add(subCategory);
      // todo update or notify transactions
      repo.create(subCategory);
    }

    notifyListeners();

    return category;
  }

  Category addSubcategory(String name, IconData icon, int parentID) {
    Category parent = getById(parentID);
    Category category = Category(
      id: _categories.length,
      name: name,
      icon: icon,
      color: parent.color,
      currency: parent.currency,
      order: _categories.isNotEmpty ? _categories.last.order + 1 : 0,
      parent: parentID,
      type: parent.type,
    );
    _categories.add(category);
    repo.create(category);
    getById(category.parent!).subCategories.add(category);

    notifyListeners();

    return category;
  }

  Category get(int index) {
    return _categories[index];
  }

  List<Category> list() {
    return _categories;
  }

  void update(Category category) {
    final targetCategory = _categories.firstWhere((element) => element.id == category.id);
    for (var subCategory in targetCategory.subCategories) {
      if (subCategory.color != category.color ||
          subCategory.currency != category.currency ||
          subCategory.type != category.type) {
        subCategory.color = category.color;
        subCategory.currency = category.currency;
        subCategory.type = category.type;
        update(subCategory);
      }
    }
    _categories[_categories.indexOf(targetCategory)] = category;
    repo.update(category);
    notifyListeners();
  }

  void remove(Category category) {
    _categories.remove(category);
    repo.delete(category);
    if (category.parent != null) {
      getById(category.parent!).subCategories.remove(category);
    }
    notifyListeners();
  }

  void reOrderSubCategory(Category category, int from, int to) {
    if (from == to) {
      return;
    }

    category.subCategories[from].order = category.subCategories[to].order;
    if (to > from) {
      for (var i = from + 1; i <= to; i++) {
        category.subCategories[i].order--;
        repo.update(category.subCategories[i]);
      }
    } else {
      for (var i = to; i < from; i++) {
        category.subCategories[i].order++;
        repo.update(category.subCategories[i]);
      }
    }
    category.subCategories.sort((a, b) => a.order.compareTo(b.order));

    notifyListeners();
  }

  void reOrderCategory(int from, int to) {
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
