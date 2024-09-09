import 'dart:collection';

import 'package:fb/db/account.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> _dryTransactions = [];
  final Repository repo;
  final AccountProvider accountProvider;
  final CategoryProvider categoryProvider;
  final StateProvider stateProvider;

  Set<TransferTarget> _targetFilter = {};

  set targetFilter(Set<TransferTarget> value) {
    _targetFilter = value;
    notifyListeners();
  }

  Set<TransferTarget> get targetFilter => _targetFilter;

  String _search = '';

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  String get search => _search;

  Future<List<Transaction>> get previousItems async {
    final range = getPreviousRange(stateProvider.range, stateProvider.rangeType);
    final transactions = await repo.listTransactions(range); // get latest month
    transactions.sort((a, b) => b.date.compareTo(a.date)); // sort and group by date

    return transactions;
  }

  UnmodifiableListView<Transaction> get items => UnmodifiableListView(_transactions);

  Future<List<Transaction>> get nextItems async {
    final range = getNextRange(stateProvider.range, stateProvider.rangeType);
    final transactions = await repo.listTransactions(range); // get latest month
    transactions.sort((a, b) => b.date.compareTo(a.date)); // sort and group by date

    return transactions;
  }

  TransactionProvider(this.repo, this.accountProvider, this.categoryProvider, this.stateProvider);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final DateTime now = DateTime.now();
    final DateTime start = DateTime(now.year, now.month, prefs.getInt(firstDayOfMonthKey) ?? 1);
    final DateTime end = start.copyWith(month: start.month + 1);
    final range = DateTimeRange(start: start, end: end);
    _transactions = await repo.listTransactions(range); // get latest month
    _transactions.sort((a, b) => b.date.compareTo(a.date)); // sort and group by date
  }

  int get length => _transactions.length;

  Future<void> updateRange() async {
    _transactions = await repo.listTransactions(stateProvider.range); // get latest month
    _transactions.sort((a, b) => b.date.compareTo(a.date)); // sort and group by date

    notifyListeners();
  }

  void silentUpdateRange() async {
    _transactions = await repo.listTransactions(stateProvider.range); // get latest month
    _transactions.sort((a, b) => b.date.compareTo(a.date)); // sort and group by date
  }

  int get dryLength => _dryTransactions.length;

  void addDry(String note, TransferTarget from, TransferTarget to, double amountFrom, double amountTo, DateTime date) {
    Transaction transaction = Transaction(
        note: note,
        fromAccount: (from is Account) ? from.id : null,
        fromCategory: (from is Category) ? from.id : null,
        toAccount: (to is Account) ? to.id : null,
        toCategory: (to is Category) ? to.id : null,
        amountFrom: amountFrom,
        amountTo: amountTo,
        date: date);
    _transactions.add(transaction);
    _dryTransactions.add(transaction);
  }

  Future<void> commitDries() async {
    await repo.createBatch(_dryTransactions);
    _dryTransactions = [];
  }

  Future<void> add(
      String note, TransferTarget from, TransferTarget to, double amountFrom, double amountTo, DateTime date) async {
    addOnly(note, from, to, amountFrom, amountTo, date);
    if (from is Account) {
      accountProvider.addBalance(from, -amountFrom);
    }
    if (to is Account) {
      accountProvider.addBalance(to, amountTo);
    }

    notifyListeners();
  }

  Future<void> addOnly(
      String note, TransferTarget from, TransferTarget to, double amountFrom, double amountTo, DateTime date) async {
    Transaction transaction = Transaction(
        note: note,
        fromAccount: (from is Account) ? from.id : null,
        fromCategory: (from is Category) ? from.id : null,
        toAccount: (to is Account) ? to.id : null,
        toCategory: (to is Category) ? to.id : null,
        amountFrom: amountFrom,
        amountTo: amountTo,
        date: date);
    _transactions.add(transaction);
    repo.create(transaction);
  }

  void update(Transaction transaction) {
    final target = _transactions.firstWhere((element) => element.id == transaction.id);
    _transactions[_transactions.indexOf(target)] = transaction;
    repo.update(transaction);
    notifyListeners();
  }

  void remove(Transaction transaction) {
    _transactions.remove(transaction);
    repo.delete(transaction);
    notifyListeners();
  }

  // todo check if db query would be faster and ?cache
  double getRangeExpenses(String? categoryID) {
    double result = 0;
    for (var i = 0; i < _transactions.length; i++) {
      if (_transactions[i].toCategory != categoryID) {
        continue;
      }

      result += _transactions[i].amountTo;
    }

    return result;
  }

  // todo make it recent, not last
  TransferTarget getRecentFromTarget() {
    if (_transactions.isEmpty) {
      return accountProvider.items.first;
    }

    if (_transactions.last.fromAccount != null) {
      return accountProvider.getById(_transactions.last.fromAccount!);
    }

    return categoryProvider.getByID(_transactions.last.fromCategory!);
  }

  // todo make it recent, not last
  TransferTarget getRecentToTarget() {
    if (_transactions.isEmpty) {
      return categoryProvider.getCategories().first;
    }

    if (_transactions.last.toAccount != null) {
      return accountProvider.getById(_transactions.last.toAccount!);
    }

    return categoryProvider.getByID(_transactions.last.toCategory!);
  }

  void deleteAll() {
    _transactions.clear();
    repo.deleteAll(tableTransactions);
    notifyListeners();
  }
}
