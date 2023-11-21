import 'package:fb/db/repository.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

enum CategoryType { expenses, income }

class Category implements Model, TransferTarget {
  @override
  final int id;
  @override
  String name;
  @override
  IconData icon;
  @override
  Color color;
  bool archived;
  @override
  Currency currency;
  int order;
  int? parent;
  CategoryType type;
  List<Category> subCategories = [];

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.currency,
    required this.order,
    required this.type,
    this.archived = false,
    this.parent
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
      'parent': parent,
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
      parent: map['parent']?.toInt(),
      type: CategoryType.values[map['type']],
    );
  }

  @override
  String tableName() {
    return tableCategories;
  }

  bool isSubCategory() {
    return parent != null;
  }
}
