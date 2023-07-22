import 'dart:collection';

import 'package:fb/db/repository.dart';
import 'package:flutter/material.dart';

import '../db/budget.dart';

class BudgetProvider extends ChangeNotifier {
  List<Budget> _budgets = [];
  final Repository repo;

  UnmodifiableListView<Budget> get items => UnmodifiableListView(_budgets);

  BudgetProvider(this.repo);

  Future<void> init() async {
    _budgets = await repo.listBudgets(DateTime.now().month);
  }

  int get length => _budgets.length;

  void add(int category, int month, double amount) {
    Budget budget = Budget(
      id: _budgets.length,
      category: category,
      month: month,
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
}