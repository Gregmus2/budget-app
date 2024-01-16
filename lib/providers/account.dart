import 'dart:collection';

import 'package:fb/db/repository.dart';
import 'package:fb/models/account.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class AccountProvider extends ChangeNotifier {
  List<Account> _accounts = [];
  final Repository repo;

  UnmodifiableListView<Account> get items => UnmodifiableListView(_accounts);

  AccountProvider(this.repo);

  Future<void> init() async {
    _accounts = await repo.listAccounts();
    _accounts.sort((a, b) => a.order.compareTo(b.order));
  }

  int get length => _accounts.length;

  void upsert(
      Account? account, String name, IconData icon, Color color, Currency currency, AccountType type, double balance) {
    if (account == null) {
      add(name, icon, color, currency, type, balance);

      return;
    }

    account
      ..name = name
      ..icon = icon
      ..color = color
      ..type = type
      ..balance = balance
      ..currency = currency;
    update(account);
  }

  Account add(String name, IconData icon, Color color, Currency currency, AccountType type, double balance) {
    Account account = Account(
        name: name,
        icon: icon,
        color: color,
        currency: currency,
        type: type,
        balance: balance,
        order: _accounts.isNotEmpty ? _accounts.last.order + 1 : 0);
    _accounts.add(account);
    repo.create(account);
    notifyListeners();

    return account;
  }

  Account get(int index) {
    return _accounts[index];
  }

  List<Account> list() {
    return _accounts;
  }

  void update(Account account) {
    final target = _accounts.firstWhere((element) => element.id == account.id);
    _accounts[_accounts.indexOf(target)] = account;
    repo.update(account);
    notifyListeners();
  }

  void addBalance(Account account, double amount) {
    account.balance += amount;
    update(account);
  }

  void remove(Account account) {
    _accounts.remove(account);
    repo.delete(account);
    notifyListeners();
  }

  void reOrder(int from, int to) {
    if (from == to) {
      return;
    }

    _accounts[from].order = _accounts[to].order;
    if (to > from) {
      for (var i = from + 1; i <= to; i++) {
        _accounts[i].order--;
        repo.update(_accounts[i]);
      }
    } else {
      for (var i = to; i < from; i++) {
        _accounts[i].order++;
        repo.update(_accounts[i]);
      }
    }
    _accounts.sort((a, b) => a.order.compareTo(b.order));

    notifyListeners();
  }

  Account getById(String id) {
    return _accounts.firstWhere((element) => element.id == id);
  }

  void deleteAll() {
    _accounts.clear();
    repo.deleteAll(tableAccounts);
    notifyListeners();
  }
}
