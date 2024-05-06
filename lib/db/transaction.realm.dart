// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class TransactionModel extends _TransactionModel
    with RealmEntity, RealmObjectBase, RealmObject {
  TransactionModel(
    ObjectId id,
    String ownerId,
    String note,
    double amountFrom,
    double amountTo,
    int date, {
    ObjectId? fromAccount,
    ObjectId? fromCategory,
    ObjectId? toAccount,
    ObjectId? toCategory,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'fromAccount', fromAccount);
    RealmObjectBase.set(this, 'fromCategory', fromCategory);
    RealmObjectBase.set(this, 'toAccount', toAccount);
    RealmObjectBase.set(this, 'toCategory', toCategory);
    RealmObjectBase.set(this, 'note', note);
    RealmObjectBase.set(this, 'amountFrom', amountFrom);
    RealmObjectBase.set(this, 'amountTo', amountTo);
    RealmObjectBase.set(this, 'date', date);
  }

  TransactionModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => throw RealmUnsupportedSetError();

  @override
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

  @override
  ObjectId? get fromAccount =>
      RealmObjectBase.get<ObjectId>(this, 'fromAccount') as ObjectId?;
  @override
  set fromAccount(ObjectId? value) =>
      RealmObjectBase.set(this, 'fromAccount', value);

  @override
  ObjectId? get fromCategory =>
      RealmObjectBase.get<ObjectId>(this, 'fromCategory') as ObjectId?;
  @override
  set fromCategory(ObjectId? value) =>
      RealmObjectBase.set(this, 'fromCategory', value);

  @override
  ObjectId? get toAccount =>
      RealmObjectBase.get<ObjectId>(this, 'toAccount') as ObjectId?;
  @override
  set toAccount(ObjectId? value) =>
      RealmObjectBase.set(this, 'toAccount', value);

  @override
  ObjectId? get toCategory =>
      RealmObjectBase.get<ObjectId>(this, 'toCategory') as ObjectId?;
  @override
  set toCategory(ObjectId? value) =>
      RealmObjectBase.set(this, 'toCategory', value);

  @override
  String get note => RealmObjectBase.get<String>(this, 'note') as String;
  @override
  set note(String value) => RealmObjectBase.set(this, 'note', value);

  @override
  double get amountFrom =>
      RealmObjectBase.get<double>(this, 'amountFrom') as double;
  @override
  set amountFrom(double value) =>
      RealmObjectBase.set(this, 'amountFrom', value);

  @override
  double get amountTo =>
      RealmObjectBase.get<double>(this, 'amountTo') as double;
  @override
  set amountTo(double value) => RealmObjectBase.set(this, 'amountTo', value);

  @override
  int get date => RealmObjectBase.get<int>(this, 'date') as int;
  @override
  set date(int value) => RealmObjectBase.set(this, 'date', value);

  @override
  Stream<RealmObjectChanges<TransactionModel>> get changes =>
      RealmObjectBase.getChanges<TransactionModel>(this);

  @override
  Stream<RealmObjectChanges<TransactionModel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<TransactionModel>(this, keyPaths);

  @override
  TransactionModel freeze() =>
      RealmObjectBase.freezeObject<TransactionModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'owner_id': ownerId.toEJson(),
      'fromAccount': fromAccount.toEJson(),
      'fromCategory': fromCategory.toEJson(),
      'toAccount': toAccount.toEJson(),
      'toCategory': toCategory.toEJson(),
      'note': note.toEJson(),
      'amountFrom': amountFrom.toEJson(),
      'amountTo': amountTo.toEJson(),
      'date': date.toEJson(),
    };
  }

  static EJsonValue _toEJson(TransactionModel value) => value.toEJson();
  static TransactionModel _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'owner_id': EJsonValue ownerId,
        'fromAccount': EJsonValue fromAccount,
        'fromCategory': EJsonValue fromCategory,
        'toAccount': EJsonValue toAccount,
        'toCategory': EJsonValue toCategory,
        'note': EJsonValue note,
        'amountFrom': EJsonValue amountFrom,
        'amountTo': EJsonValue amountTo,
        'date': EJsonValue date,
      } =>
        TransactionModel(
          fromEJson(id),
          fromEJson(ownerId),
          fromEJson(note),
          fromEJson(amountFrom),
          fromEJson(amountTo),
          fromEJson(date),
          fromAccount: fromEJson(fromAccount),
          fromCategory: fromEJson(fromCategory),
          toAccount: fromEJson(toAccount),
          toCategory: fromEJson(toCategory),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(TransactionModel._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, TransactionModel, 'TransactionModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
      SchemaProperty('fromAccount', RealmPropertyType.objectid, optional: true),
      SchemaProperty('fromCategory', RealmPropertyType.objectid,
          optional: true),
      SchemaProperty('toAccount', RealmPropertyType.objectid, optional: true),
      SchemaProperty('toCategory', RealmPropertyType.objectid, optional: true),
      SchemaProperty('note', RealmPropertyType.string),
      SchemaProperty('amountFrom', RealmPropertyType.double),
      SchemaProperty('amountTo', RealmPropertyType.double),
      SchemaProperty('date', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
