import 'package:realm/realm.dart';

part 'budget.g.dart';

@RealmModel()
class _BudgetModel {
  @MapTo("_id")
  @PrimaryKey()
  late final ObjectId id;
  @MapTo("owner_id")
  @Indexed()
  late String ownerId;
  late ObjectId category;
  @Indexed()
  late int month;
  @Indexed()
  late int year;
  late double amount;
}
