import 'package:realm/realm.dart';

part 'account.g.dart';

@RealmModel()
class _AccountModel {
  @MapTo("_id")
  @PrimaryKey()
  late final ObjectId id;
  @MapTo("owner_id")
  @Indexed()
  late String ownerId;
  late String name;
  late int type;
  late int iconCode;
  late String? iconFont;
  late int color;
  late bool archived;
  late String currency;
  late int order;
  late double balance;
}
