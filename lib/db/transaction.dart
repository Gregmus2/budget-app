import 'package:realm/realm.dart';

part 'transaction.realm.dart';

@RealmModel()
class _TransactionModel {
  @MapTo("_id")
  @PrimaryKey()
  late final ObjectId id;
  @MapTo("owner_id")
  late String ownerId;
  late ObjectId? fromAccount;
  late ObjectId? fromCategory;
  late ObjectId? toAccount;
  late ObjectId? toCategory;
  late String note;
  late double amountFrom;
  late double amountTo;
  late int date;
}
