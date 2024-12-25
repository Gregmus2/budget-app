import 'package:fb/db/model.dart';
import 'package:fb/db/repository.dart';
import 'package:sync_proto_gen/sync.dart';
import 'package:uuid/v4.dart';

class Transaction implements Model {
  @override
  late final String id;
  String note;
  String? fromAccount;
  String? fromCategory;
  String? toAccount;
  String? toCategory;
  double amountFrom;
  double amountTo;
  DateTime date;

  Transaction(
      {required this.note,
      required this.fromAccount,
      required this.fromCategory,
      this.toAccount,
      this.toCategory,
      required this.amountFrom,
      required this.amountTo,
      required this.date,
      id}) {
    this.id = id ?? const UuidV4().generate();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'from_account': fromAccount,
      'from_category': fromCategory,
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
      fromAccount: map['from_account'],
      fromCategory: map['from_category'],
      toAccount: map['to_account'],
      toCategory: map['to_category'],
    );
  }

  @override
  String tableName() {
    return tableTransactions;
  }

  @override
  List<Operation_Entity> relatedEntities() {
    List<Operation_Entity> result = [
      Operation_Entity()
        ..id = id
        ..name = tableTransactions
    ];

    if (fromAccount != null) {
      result.add(Operation_Entity()
        ..id = fromAccount!
        ..name = tableAccounts);
    }
    if (fromCategory != null) {
      result.add(Operation_Entity()
        ..id = fromCategory!
        ..name = tableCategories);
    }
    if (toAccount != null) {
      result.add(Operation_Entity()
        ..id = toAccount!
        ..name = tableAccounts);
    }
    if (toCategory != null) {
      result.add(Operation_Entity()
        ..id = toCategory!
        ..name = tableCategories);
    }

    return result;
  }
}
