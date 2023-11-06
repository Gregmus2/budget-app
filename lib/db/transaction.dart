import 'package:fb/db/repository.dart';

class Transaction implements Model {
  @override
  final int id;
  String note;
  int from;
  int? toAccount;
  int? toCategory;
  double amountFrom;
  double amountTo;
  DateTime date;

  Transaction({
    required this.id,
    required this.note,
    required this.from,
    this.toAccount,
    this.toCategory,
    required this.amountFrom,
    required this.amountTo,
    required this.date,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'from': from,
      'to_account': toAccount,
      'to_category': toCategory,
      'amount_from': amountFrom,
      'amount_to': amountTo,
      'date': date.millisecondsSinceEpoch ~/ 1000,
    };
  }

  static Transaction mapDatabase(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      note: map['note'],
      amountFrom: map['amount_from']?.toDouble(),
      amountTo: map['amount_to']?.toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000),
      from: map['from']?.toInt(),
      toAccount: map['to_account']?.toInt(),
      toCategory: map['to_category']?.toInt(),
    );
  }

  @override
  String tableName() {
    return tableTransactions;
  }
}
