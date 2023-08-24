import 'package:fb/providers/transaction.dart';
import 'package:flutter/material.dart';

class StateProvider extends ChangeNotifier {
  DateTime date = DateTime.now();
  final TransactionProvider transactionProvider;

  StateProvider(this.transactionProvider);

  int get year => date.year;
  int get month => date.month;

  void nextMonth() {
    date = DateTime(date.year, date.month + 1);
    update();
  }

  void previousMonth() {
    date = DateTime(date.year, date.month - 1);
    update();
  }

  void update() {
    transactionProvider.updateDate(date);
    notifyListeners();
  }
}
