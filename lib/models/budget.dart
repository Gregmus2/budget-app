import 'package:fb/db/repository.dart';
import 'package:fb/models/model.dart';
import 'package:realm/realm.dart';

import '../db/budget.dart';

class Budget implements Model {
  @override
  late final String id;
  String category;
  int month;
  int year;
  double amount;

  Budget({required this.category, required this.month, required this.year, required this.amount, id}) {
    this.id = id ?? ObjectId().toString();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'month': month,
      'year': year,
      'amount': amount,
    };
  }

  static Budget mapDatabase(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      category: map['category'],
      month: map['month'],
      year: map['year'],
      amount: map['amount'],
    );
  }

  static Budget mapRealm(BudgetModel category) {
    return Budget(
      id: category.id.toString(),
      category: category.category.toString(),
      month: category.month,
      year: category.year,
      amount: category.amount,
    );
  }

  @override
  String tableName() {
    return tableBudgets;
  }

  @override
  BudgetModel toRealmObject(String ownerID) {
    return BudgetModel(
      ObjectId.fromHexString(id),
      ownerID,
      ObjectId.fromHexString(category),
      month,
      year,
      amount,
    );
  }
}
