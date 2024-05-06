import 'package:realm/realm.dart';

part 'budget.realm.dart';

@RealmModel()
class _BudgetModel {
  @MapTo("_id")
  @PrimaryKey()
  late final ObjectId id;
  @MapTo("owner_id")
  late String ownerId;
  late ObjectId category;
  late int month;
  late int year;
  late double amount;
}
