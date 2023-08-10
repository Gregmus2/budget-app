import 'package:fb/db/repository.dart';

class Budget implements Model {
  @override
  final int id;
  int category;
  int month;
  int year;
  double amount;

  Budget({
    required this.id,
    required this.category,
    required this.month,
    required this.year,
    required this.amount,
  });

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

  @override
  String tableName() {
    return tableBudgets;
  }
}
