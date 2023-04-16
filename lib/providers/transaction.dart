import 'dart:collection';

import 'package:fb/db/account.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/db/transaction.dart';
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

  void add(String note, Account from, Account? toAccount, Category? toCategory,
      double amountFrom, double amountTo, DateTime date) {
    Transaction transaction = Transaction(
        id: _transactions.length + 1,
        note: note,
        from: from.id,
        toAccount: (toAccount != null) ? toAccount.id : null,
        toCategory: (toCategory != null) ? toCategory.id : null,
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
}
