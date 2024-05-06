// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class BudgetModel extends _BudgetModel
    with RealmEntity, RealmObjectBase, RealmObject {
  BudgetModel(
    ObjectId id,
    String ownerId,
    ObjectId category,
    int month,
    int year,
    double amount,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'month', month);
    RealmObjectBase.set(this, 'year', year);
    RealmObjectBase.set(this, 'amount', amount);
  }

  BudgetModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => throw RealmUnsupportedSetError();

  @override
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

  @override
  ObjectId get category =>
      RealmObjectBase.get<ObjectId>(this, 'category') as ObjectId;
  @override
  set category(ObjectId value) => RealmObjectBase.set(this, 'category', value);

  @override
  int get month => RealmObjectBase.get<int>(this, 'month') as int;
  @override
  set month(int value) => RealmObjectBase.set(this, 'month', value);

  @override
  int get year => RealmObjectBase.get<int>(this, 'year') as int;
  @override
  set year(int value) => RealmObjectBase.set(this, 'year', value);

  @override
  double get amount => RealmObjectBase.get<double>(this, 'amount') as double;
  @override
  set amount(double value) => RealmObjectBase.set(this, 'amount', value);

  @override
  Stream<RealmObjectChanges<BudgetModel>> get changes =>
      RealmObjectBase.getChanges<BudgetModel>(this);

  @override
  Stream<RealmObjectChanges<BudgetModel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<BudgetModel>(this, keyPaths);

  @override
  BudgetModel freeze() => RealmObjectBase.freezeObject<BudgetModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'owner_id': ownerId.toEJson(),
      'category': category.toEJson(),
      'month': month.toEJson(),
      'year': year.toEJson(),
      'amount': amount.toEJson(),
    };
  }

  static EJsonValue _toEJson(BudgetModel value) => value.toEJson();
  static BudgetModel _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'owner_id': EJsonValue ownerId,
        'category': EJsonValue category,
        'month': EJsonValue month,
        'year': EJsonValue year,
        'amount': EJsonValue amount,
      } =>
        BudgetModel(
          fromEJson(id),
          fromEJson(ownerId),
          fromEJson(category),
          fromEJson(month),
          fromEJson(year),
          fromEJson(amount),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(BudgetModel._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, BudgetModel, 'BudgetModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
      SchemaProperty('category', RealmPropertyType.objectid),
      SchemaProperty('month', RealmPropertyType.int),
      SchemaProperty('year', RealmPropertyType.int),
      SchemaProperty('amount', RealmPropertyType.double),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
