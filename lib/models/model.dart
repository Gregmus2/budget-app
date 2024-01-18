import 'package:realm/realm.dart';

abstract class Model {
  final String id;

  Model(this.id);

  String tableName() {
    return '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  RealmObject toRealmObject(String ownerID) {
    throw UnimplementedError();
  }
}
