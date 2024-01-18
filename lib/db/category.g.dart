// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class CategoryModel extends _CategoryModel with RealmEntity, RealmObjectBase, RealmObject {
  CategoryModel(
    ObjectId id,
    String ownerId,
    String name,
    int iconCode,
    int color,
    bool archived,
    String currencyCode,
    int order,
    int type, {
    String? iconFont,
    String? parent,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'iconCode', iconCode);
    RealmObjectBase.set(this, 'iconFont', iconFont);
    RealmObjectBase.set(this, 'color', color);
    RealmObjectBase.set(this, 'archived', archived);
    RealmObjectBase.set(this, 'currencyCode', currencyCode);
    RealmObjectBase.set(this, 'order', order);
    RealmObjectBase.set(this, 'parent', parent);
    RealmObjectBase.set(this, 'type', type);
  }

  CategoryModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;

  @override
  set id(ObjectId value) => throw RealmUnsupportedSetError();

  @override
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;

  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;

  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  int get iconCode => RealmObjectBase.get<int>(this, 'iconCode') as int;

  @override
  set iconCode(int value) => RealmObjectBase.set(this, 'iconCode', value);

  @override
  String? get iconFont => RealmObjectBase.get<String>(this, 'iconFont') as String?;

  @override
  set iconFont(String? value) => RealmObjectBase.set(this, 'iconFont', value);

  @override
  int get color => RealmObjectBase.get<int>(this, 'color') as int;

  @override
  set color(int value) => RealmObjectBase.set(this, 'color', value);

  @override
  bool get archived => RealmObjectBase.get<bool>(this, 'archived') as bool;

  @override
  set archived(bool value) => RealmObjectBase.set(this, 'archived', value);

  @override
  String get currencyCode => RealmObjectBase.get<String>(this, 'currencyCode') as String;

  @override
  set currencyCode(String value) => RealmObjectBase.set(this, 'currencyCode', value);

  @override
  int get order => RealmObjectBase.get<int>(this, 'order') as int;

  @override
  set order(int value) => RealmObjectBase.set(this, 'order', value);

  @override
  String? get parent => RealmObjectBase.get<String>(this, 'parent') as String?;

  @override
  set parent(String? value) => RealmObjectBase.set(this, 'parent', value);

  @override
  int get type => RealmObjectBase.get<int>(this, 'type') as int;

  @override
  set type(int value) => RealmObjectBase.set(this, 'type', value);

  @override
  Stream<RealmObjectChanges<CategoryModel>> get changes => RealmObjectBase.getChanges<CategoryModel>(this);

  @override
  CategoryModel freeze() => RealmObjectBase.freezeObject<CategoryModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CategoryModel._);
    return const SchemaObject(ObjectType.realmObject, CategoryModel, 'CategoryModel', [
      SchemaProperty('id', RealmPropertyType.objectid, mapTo: '_id', primaryKey: true),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id', indexType: RealmIndexType.regular),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('iconCode', RealmPropertyType.int),
      SchemaProperty('iconFont', RealmPropertyType.string, optional: true),
      SchemaProperty('color', RealmPropertyType.int),
      SchemaProperty('archived', RealmPropertyType.bool),
      SchemaProperty('currencyCode', RealmPropertyType.string),
      SchemaProperty('order', RealmPropertyType.int),
      SchemaProperty('parent', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.int),
    ]);
  }
}
