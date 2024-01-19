// ignore_for_file: sdk_version_since

import 'dart:collection';

import 'package:fb/db/budget.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/models/category.dart';
import 'package:fb/providers/category.dart';
import 'package:flutter/material.dart';

import '../models/budget.dart';

class BudgetProvider extends ChangeNotifier {
  List<Budget> _budgets = [];
  final Repository repo;

  UnmodifiableListView<Budget> get items => UnmodifiableListView(_budgets);

  BudgetProvider(this.repo);

  Future<void> init() async {
    // todo update budgets every range change
    _budgets = await repo.listBudgets(DateTime.now().month, DateTime.now().year);
  }

  int get length => _budgets.length;

  void add(String category, int month, int year, double amount) {
    Budget budget = Budget(
      category: category,
      month: month,
      year: year,
      amount: amount,
    );
    _budgets.add(budget);
    repo.create(budget);
    notifyListeners();
  }

  Budget get(int index) {
    return _budgets[index];
  }

  List<Budget> list() {
    return _budgets;
  }

  void update(Budget budget) {
    final target = _budgets.firstWhere((element) => element.id == budget.id);
    _budgets[_budgets.indexOf(target)] = budget;
    repo.update(budget);
    notifyListeners();
  }

  void remove(Budget budget) {
    _budgets.remove(budget);
    repo.delete(budget);
    notifyListeners();
  }

  List<String> getCategories() {
    List<String> categories = [];
    for (var budget in _budgets) {
      if (!categories.contains(budget.category)) {
        categories.add(budget.category);
      }
    }

    return categories;
  }

  void deleteAll() {
    _budgets.clear();
    repo.deleteAll<BudgetModel>();
    notifyListeners();
  }

  double? getBudgetAmount(String category, int month, int year) {
    return _budgets
        .where((element) => element.category == category && element.month == month && element.year == year)
        .firstOrNull
        ?.amount;
  }
}
