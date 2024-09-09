import 'package:fb/db/model.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';

enum AccountType { regular, debt, savings }

class Account implements Model, TransferTarget {
  @override
  late final String id;
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

  Account(
      {required this.name,
      required this.type,
      required this.icon,
      required this.color,
      required this.currency,
      required this.order,
      this.archived = false,
      this.balance = 0.0,
      id}) {
    this.id = id ?? const UuidV4().generate();
  }

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
      'currency': currency.isoCode,
      'order': order,
      'balance': balance,
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
      currency: Currency.mustFromISOCode(map['currency']),
      order: map['order'],
      balance: map['balance'] ?? 0.0,
    );
  }

  @override
  String tableName() {
    return tableAccounts;
  }
}
