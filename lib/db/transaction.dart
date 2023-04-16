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
      'to_account': (toAccount != null) ? toAccount : null,
      'to_category': (toCategory != null) ? toCategory : null,
      'amount_from': amountFrom,
      'amount_to': amountTo,
      'date': date.millisecondsSinceEpoch ~/ 1000,
    };
  }

  static Transaction mapDatabase(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      note: map['note'],
      amountFrom: map['amount_from'],
      amountTo: map['amount_to'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000),
      from: map['from'],
      toAccount: map['to_account'],
      toCategory: map['to_category'],
    );
  }

  @override
  String tableName() {
    return tableTransactions;
  }
}
