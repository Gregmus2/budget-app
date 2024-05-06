import 'package:fb/db/account.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/models/model.dart';
import 'package:fb/models/transfer_target.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:realm/realm.dart';

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
    this.id = id ?? ObjectId().toString();
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
      currency: Currencies().find(map['currency'] ?? '') ?? CommonCurrencies().euro,
      order: map['order'],
      balance: map['balance'] ?? 0.0,
    );
  }

  static Account mapRealm(AccountModel category) {
    return Account(
      id: category.id.toString(),
      name: category.name,
      type: AccountType.values[category.type],
      icon: IconData(category.iconCode, fontFamily: category.iconFont),
      color: Color(category.color).withOpacity(1),
      archived: category.archived,
      currency: Currencies().find(category.currency) ?? CommonCurrencies().euro,
      order: category.order,
      balance: category.balance,
    );
  }

  @override
  String tableName() {
    return tableAccounts;
  }

  @override
  AccountModel toRealmObject(String ownerID) {
    return AccountModel(
      ObjectId.fromHexString(id),
      ownerID,
      name,
      type.index,
      icon.codePoint,
      color.value,
      archived,
      currency.isoCode,
      order,
      balance,
      iconFont: icon.fontFamily,
    );
  }
}
