import 'package:sync_proto_gen/sync.dart';

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

  List<Operation_Entity> relatedEntities() {
    return [];
  }
}
