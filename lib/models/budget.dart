import 'package:fb/db/repository.dart';
import 'package:fb/models/model.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:uuid/uuid.dart';

class Budget implements Model {
  @override
  late final String id;
  String category;
  int month;
  int year;
  double amount;

  Budget({required this.category, required this.month, required this.year, required this.amount, id}) {
    this.id = id ?? const Uuid().v4();
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
      id: hex(map['id']),
      category: map['category'],
      month: map['month'],
      year: map['year'],
      amount: map['amount'],
    );
  }

  @override
  String tableName() {
    return tableBudgets;
  }
}
