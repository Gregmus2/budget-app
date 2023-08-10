import 'dart:collection';

import 'package:fb/db/account.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:flutter/material.dart';

import '../db/category.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  final Repository repo;

  UnmodifiableListView<Transaction> get items =>
      UnmodifiableListView(_transactions);

  TransactionProvider(this.repo);

  Future<void> init() async {
    final DateTime now = DateTime.now();
    _transactions =
        await repo.listTransactions(now.year, now.month); // get latest month
    _transactions
        .sort((a, b) => b.date.compareTo(a.date)); // sort and group by date
  }

  int get length => _transactions.length;

  void add(String note, Account from, TransferTarget to, double amountFrom,
      double amountTo, DateTime date) {
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
    notifyListeners();
  }

  Transaction get(int index) {
    return _transactions[index];
  }

  List<Transaction> list() {
    return _transactions;
  }

  void update(Transaction transaction) {
    final target =
        _transactions.firstWhere((element) => element.id == transaction.id);
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
  Map<int, double> getMonthlyExpense(int month, int year) {
    Map<int, double> monthlyExpense = {};
    for (var i = 0; i < _transactions.length; i++) {
      if (_transactions[i].date.month != month ||
          _transactions[i].date.year != year ||
          _transactions[i].toCategory == null) {
        continue;
      }

      if (monthlyExpense.containsKey(_transactions[i].toCategory)) {
        monthlyExpense[_transactions[i].toCategory!] =
            monthlyExpense[_transactions[i].toCategory]! + _transactions[i].amountTo;
      } else {
        monthlyExpense[_transactions[i].toCategory!] =
            _transactions[i].amountTo;
      }
    }

    return monthlyExpense;
  }
}
