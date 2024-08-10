import 'package:fb/db/category.dart';
import 'package:fb/db/repository.dart';
import 'package:fb/models/model.dart';
import 'package:fb/models/transfer_target.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:fb/utils/currency.dart';

enum CategoryType { expenses, income }

class Category implements Model, TransferTarget {
  @override
  late final String id;
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
  String? parent;
  CategoryType type;
  List<Category> subCategories = [];

  get activeSubCategories => subCategories.where((element) => !element.archived).toList();

  Category(
      {required this.name,
      required this.icon,
      required this.color,
      required this.currency,
      required this.order,
      required this.type,
      this.archived = false,
      this.parent,
      id}) {
    this.id = id ?? ObjectId().toString();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon_code': icon.codePoint,
      'icon_font': icon.fontFamily,
      'color': color.value,
      'archived': (archived) ? 1 : 0,
      'currency': currency.isoCode,
      'order': order,
      'parent': parent,
      'type': type.index,
    };
  }

  static Category mapDatabase(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: IconData(map['icon_code'], fontFamily: map['icon_font']),
      color: Color(map['color']).withOpacity(1),
      archived: map['archived'] == 1,
      currency: Currency.fromISOCode(map['currency']),
      order: map['order'],
      parent: map['parent']?.toInt(),
      type: CategoryType.values[map['type']],
    );
  }

  static Category mapRealm(CategoryModel category) {
    return Category(
      id: category.id.toString(),
      name: category.name,
      icon: IconData(category.iconCode, fontFamily: category.iconFont),
      color: Color(category.color).withOpacity(1),
      archived: category.archived,
      currency: Currency.fromISOCode(category.currencyCode),
      order: category.order,
      parent: category.parent,
      type: CategoryType.values[category.type],
    );
  }

  @override
  String tableName() {
    return tableCategories;
  }

  bool isSubCategory() {
    return parent != null;
  }

  @override
  CategoryModel toRealmObject(String ownerID) {
    return CategoryModel(
      ObjectId.fromHexString(id),
      ownerID,
      name,
      icon.codePoint,
      color.value,
      archived,
      currency.isoCode,
      order,
      type.index,
      parent: parent,
      iconFont: icon.fontFamily,
    );
  }
}
