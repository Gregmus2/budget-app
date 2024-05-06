import 'package:realm/realm.dart';

part 'category.realm.dart';

@RealmModel()
class _CategoryModel {
  @MapTo("_id")
  @PrimaryKey()
  late final ObjectId id;
  @MapTo("owner_id")
  late String ownerId;
  late String name;
  late int iconCode;
  late String? iconFont;
  late int color;
  late bool archived;
  late String currencyCode;
  late int order;
  late String? parent;
  late int type;
}
