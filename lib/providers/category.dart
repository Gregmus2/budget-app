import 'package:fb/db/category.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/models/category.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  List<Category> _subCategories = [];
  final Repository repo;

  CategoryProvider(this.repo);

  Future<void> init() async {
    final all = repo.listCategories();
    _categories = all.where((element) => element.parent == null && !element.archived).toList();
    _categories.sort((a, b) => a.order.compareTo(b.order));
    _subCategories = all.where((element) => element.parent != null).toList();
    _subCategories.sort((a, b) => a.order.compareTo(b.order));

    for (var subCategory in _subCategories) {
      getByID(subCategory.parent!).subCategories.add(subCategory);
    }
    for (var category in _categories) {
      category.subCategories.sort((a, b) => a.order.compareTo(b.order));
    }
  }

  void upsert(Category? category, String name, IconData icon, Color color, Currency currency, CategoryType type,
      List<Category> subCategories, bool archived) {
    if (category == null) {
      add(name, icon, color, currency, type, subCategories, archived);

      return;
    }

    // todo handle deleted subcategories
    List<Category> subCategoriesToAdd = [];
    for (var subCategory in subCategories) {
      final targetSubcategories = _subCategories.where((element) => element.id == subCategory.id);
      if (targetSubcategories.isNotEmpty) {
        if (subCategory.name != targetSubcategories.first.name || subCategory.icon != targetSubcategories.first.icon) {
          updateSubCategory(subCategory);
        }
      } else {
        subCategoriesToAdd.add(subCategory);
      }
    }
    for (var subCategory in subCategoriesToAdd) {
      addSubcategory(subCategory.id, subCategory.name, subCategory.icon, category.id);
    }

    category
      ..name = name
      ..icon = icon
      ..color = color
      ..type = type
      ..archived = archived
      ..currency = currency;
    updateCategory(category);

    notifyListeners();
  }

  Category add(
      String name, IconData icon, Color color, Currency currency, CategoryType type, List<Category> subCategories, bool archived) {
    Category category = Category(
      name: name,
      icon: icon,
      color: color,
      currency: currency,
      order: _categories.isNotEmpty ? _categories.last.order + 1 : 0,
      type: type,
      archived: archived,
    );
    _categories.add(category);
    repo.create(category);

    for (int i = 0; i < subCategories.length; i++) {
      Category subCategory = Category(
        name: subCategories[i].name,
        icon: subCategories[i].icon,
        color: color,
        currency: currency,
        order: category.subCategories.isNotEmpty ? category.subCategories.last.order + 1 : 0,
        parent: category.id,
        type: type,
      );
      category.subCategories.add(subCategory);
      _subCategories.add(subCategory);
      repo.create(subCategory);
    }

    notifyListeners();

    return category;
  }

  Category addSubcategory(String id, String name, IconData icon, String parentID) {
    Category parent = getByID(parentID);
    Category subCategory = Category(
      id: id,
      name: name,
      icon: icon,
      color: parent.color,
      currency: parent.currency,
      order: parent.subCategories.isNotEmpty ? parent.subCategories.last.order + 1 : 0,
      parent: parentID,
      type: parent.type,
    );
    _subCategories.add(subCategory);
    repo.create(subCategory);
    getByID(subCategory.parent!).subCategories.add(subCategory);

    notifyListeners();

    return subCategory;
  }

  List<Category> getCategories({bool archived = false}) {
    return _categories.where((element) => element.archived == archived).toList();
  }

  void updateCategory(Category category) {
    final targetCategory = _categories.firstWhere((element) => element.id == category.id);
    for (var subCategory in targetCategory.subCategories) {
      if (subCategory.color != category.color ||
          subCategory.currency != category.currency ||
          subCategory.type != category.type) {
        subCategory.color = category.color;
        subCategory.currency = category.currency;
        subCategory.type = category.type;
        updateSubCategory(subCategory);
      }
    }
    _categories[_categories.indexOf(targetCategory)] = category;
    repo.update(category);
  }

  void updateSubCategory(Category category) {
    final targetCategory = _subCategories.firstWhere((element) => element.id == category.id);
    _subCategories[_subCategories.indexOf(targetCategory)] = category;
    repo.update(category);
  }

  void remove(Category category) {
    _categories.remove(category);
    _subCategories.remove(category);
    for (var subCategory in category.subCategories) {
      _removeSubcategory(subCategory);
    }

    repo.delete(category);
    if (category.parent != null) {
      getByID(category.parent!).subCategories.remove(category);
    }

    notifyListeners();
  }

  void _removeSubcategory(Category subCategory) {
    _subCategories.remove(subCategory);
    repo.delete(subCategory);
  }

  // todo check if subcategories have the same order when reorder. It can be the case when they added on different devices offline
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

  // todo check if categories have the same order when reorder. It can be the case when they added on different devices offline
  void reOrderCategory(Category fromCategory, toCategory) {
    if (fromCategory.id == toCategory.id) {
      return;
    }

    int from = _categories.indexOf(fromCategory);
    int to = _categories.indexOf(toCategory);

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

  Category getByID(String id) {
    return _categories.firstWhere((element) => element.id == id, orElse: () {
      return _subCategories.firstWhere((element) => element.id == id);
    });
  }

  bool isNotExists(String name) {
    return !_categories.any((element) => element.name == name);
  }

  bool isSubCategoryNotExists(String name, String parentID) {
    return !_subCategories.any((element) => element.name == name && element.parent == parentID);
  }

  bool isNotEmpty() {
    return _categories.isNotEmpty;
  }

  Category? findCategoryByName(String name) {
    return _categories.where((element) => element.name == name).firstOrNull;
  }

  Category? findSubcategoryByName(String name, String parentID) {
    return _subCategories.where((element) => element.name == name).firstOrNull;
  }

  List<Category> getExclude(List<String> exclude) {
    return _categories.where((element) => !exclude.contains(element.id)).toList();
  }

  void deleteAll() {
    _categories.clear();
    _subCategories.clear();
    repo.deleteAll<CategoryModel>();
    notifyListeners();
  }

  void convertToCategory(Category subCategory) {
    subCategory.parent = null;
    repo.update(subCategory);
    _subCategories.remove(subCategory);
    _categories.add(subCategory);
    notifyListeners();
  }
}
