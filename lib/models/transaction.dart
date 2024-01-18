import 'package:fb/db/repository.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/models/model.dart';
import 'package:realm/realm.dart';

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
    this.id = id ?? ObjectId().toString();
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
      fromAccount: map['from_account']?.toInt(),
      fromCategory: map['from_category']?.toInt(),
      toAccount: map['to_account']?.toInt(),
      toCategory: map['to_category']?.toInt(),
    );
  }

  static Transaction mapRealm(TransactionModel model) {
    return Transaction(
      id: model.id.toString(),
      note: model.note,
      amountFrom: model.amountFrom,
      amountTo: model.amountTo,
      date: DateTime.fromMillisecondsSinceEpoch(model.date * 1000),
      fromAccount: model.fromAccount?.toString(),
      fromCategory: model.fromCategory?.toString(),
      toAccount: model.toAccount?.toString(),
      toCategory: model.toCategory?.toString(),
    );
  }

  @override
  String tableName() {
    return tableTransactions;
  }

  @override
  TransactionModel toRealmObject(String ownerID) {
    return TransactionModel(
      ObjectId.fromHexString(id),
      ownerID,
      note,
      amountFrom,
      amountTo,
      date.millisecondsSinceEpoch ~/ 1000,
      fromAccount: fromAccount == null ? null : ObjectId.fromHexString(fromAccount!),
      fromCategory: fromCategory == null ? null : ObjectId.fromHexString(fromCategory!),
      toAccount: toAccount == null ? null : ObjectId.fromHexString(toAccount!),
      toCategory: toCategory == null ? null : ObjectId.fromHexString(toCategory!),
    );
  }
}
