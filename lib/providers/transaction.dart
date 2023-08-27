import 'dart:collection';

import 'package:fb/db/account.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/category.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  final Repository repo;
  final AccountProvider accountProvider;

  UnmodifiableListView<Transaction> get items => UnmodifiableListView(_transactions);

  TransactionProvider(this.repo, this.accountProvider);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final DateTime now = DateTime.now();
    final DateTime start = DateTime(now.year, now.month, prefs.getInt(firstDayOfMonthKey) ?? 1);
    final DateTime end = start.copyWith(month: start.month + 1);
    _transactions = await repo.listTransactions(DateTimeRange(start: start, end: end)); // get latest month
    _transactions.sort((a, b) => b.date.compareTo(a.date)); // sort and group by date
  }

  int get length => _transactions.length;

  Future<void> updateRange(DateTimeRange range) async {
    _transactions = await repo.listTransactions(range); // get latest month
    _transactions.sort((a, b) => b.date.compareTo(a.date)); // sort and group by date
    notifyListeners();
  }

  void add(String note, Account from, TransferTarget to, double amountFrom, double amountTo, DateTime date) {
    Transaction transaction = Transaction(
        id: _transactions.length + 1,
        note: note,
        from: from.id,
        toAccount: (to is Account) ? to.id : null,
        toCategory: (to is Category) ? to.id : null,
        amountFrom: amountFrom,
        amountTo: amountTo,
        date: date);
    _transactions.add(transaction);
    repo.create(transaction);

    accountProvider.addBalance(from, -amountFrom);
    if (to is Account) {
      accountProvider.addBalance(to, amountTo);
    }

    notifyListeners();
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
  Map<int, double> getRangeExpenses() {
    Map<int, double> monthlyExpense = {};
    for (var i = 0; i < _transactions.length; i++) {
      if (_transactions[i].toCategory == null) {
        continue;
      }

      if (monthlyExpense.containsKey(_transactions[i].toCategory)) {
        monthlyExpense[_transactions[i].toCategory!] =
            monthlyExpense[_transactions[i].toCategory]! + _transactions[i].amountTo;
      } else {
        monthlyExpense[_transactions[i].toCategory!] = _transactions[i].amountTo;
      }
    }

    return monthlyExpense;
  }
}
