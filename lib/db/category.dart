import 'package:fb/db/repository.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class Category implements Model {
  @override
  final int id;
  String name;
  IconData icon;
  Color color;
  bool archived;
  Currency currency;
  int order;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.currency,
    required this.order,
    this.archived = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon_code': icon.codePoint,
      'icon_font': icon.fontFamily,
      'color': color.value,
      'archived': (archived) ? 1 : 0,
      'currency': currency.code,
      'order': order,
    };
  }

  static Category mapDatabase(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: IconData(map['icon_code'], fontFamily: map['icon_font']),
      color: Color(map['color']).withOpacity(1),
      archived: map['archived'] == 1,
      currency: Currencies().find(map['currency'] ?? '') ?? CommonCurrencies().euro,
      order: map['order'],
    );
  }

  @override
  String tableName() {
    return tableCategories;
  }
}

