import 'package:fb/db/repository.dart';

class Budget implements Model {
  @override
  final int id;
  int category;
  int month;
  double amount;

  Budget({
    required this.id,
    required this.category,
    required this.month,
    required this.amount,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'month': month,
      'amount': amount,
    };
  }

  static Budget mapDatabase(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      category: map['category'],
      month: map['month'],
      amount: map['amount'],
    );
  }

  @override
  String tableName() {
    return tableBudgets;
  }
}
