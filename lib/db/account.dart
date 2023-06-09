import 'package:fb/db/repository.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

enum AccountType { regular, debt, savings }

class Account implements Model, TransferTarget {
  @override
  final int id;
  @override
  String name;
  AccountType type;
  @override
  IconData icon;
  @override
  Color color;
  bool archived;
  @override
  Currency currency;
  int order;
  double balance;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    required this.currency,
    required this.order,
    this.archived = false,
    this.balance = 0.0,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'icon_code': icon.codePoint,
      'icon_font': icon.fontFamily,
      'color': color.value,
      'archived': (archived) ? 1 : 0,
      'currency': currency.code,
      'order': order,
    };
  }

  static Account mapDatabase(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      type: AccountType.values[map['type']],
      icon: IconData(map['icon_code'], fontFamily: map['icon_font']),
      color: Color(map['color']).withOpacity(1),
      archived: map['archived'] == 1,
      currency: Currencies().find(map['currency'] ?? '') ?? CommonCurrencies().euro,
      order: map['order'],
      balance: map['balance'] ?? 0.0,
    );
  }

  @override
  String tableName() {
    return tableAccounts;
  }
}

