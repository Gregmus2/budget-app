// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class AccountModel extends _AccountModel
    with RealmEntity, RealmObjectBase, RealmObject {
  AccountModel(
    ObjectId id,
    String ownerId,
    String name,
    int type,
    int iconCode,
    int color,
    bool archived,
    String currency,
    int order,
    double balance, {
    String? iconFont,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'iconCode', iconCode);
    RealmObjectBase.set(this, 'iconFont', iconFont);
    RealmObjectBase.set(this, 'color', color);
    RealmObjectBase.set(this, 'archived', archived);
    RealmObjectBase.set(this, 'currency', currency);
    RealmObjectBase.set(this, 'order', order);
    RealmObjectBase.set(this, 'balance', balance);
  }

  AccountModel._();

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
  int get type => RealmObjectBase.get<int>(this, 'type') as int;
  @override
  set type(int value) => RealmObjectBase.set(this, 'type', value);

  @override
  int get iconCode => RealmObjectBase.get<int>(this, 'iconCode') as int;
  @override
  set iconCode(int value) => RealmObjectBase.set(this, 'iconCode', value);

  @override
  String? get iconFont =>
      RealmObjectBase.get<String>(this, 'iconFont') as String?;
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
  String get currency =>
      RealmObjectBase.get<String>(this, 'currency') as String;
  @override
  set currency(String value) => RealmObjectBase.set(this, 'currency', value);

  @override
  int get order => RealmObjectBase.get<int>(this, 'order') as int;
  @override
  set order(int value) => RealmObjectBase.set(this, 'order', value);

  @override
  double get balance => RealmObjectBase.get<double>(this, 'balance') as double;
  @override
  set balance(double value) => RealmObjectBase.set(this, 'balance', value);

  @override
  Stream<RealmObjectChanges<AccountModel>> get changes =>
      RealmObjectBase.getChanges<AccountModel>(this);

  @override
  Stream<RealmObjectChanges<AccountModel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<AccountModel>(this, keyPaths);

  @override
  AccountModel freeze() => RealmObjectBase.freezeObject<AccountModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'owner_id': ownerId.toEJson(),
      'name': name.toEJson(),
      'type': type.toEJson(),
      'iconCode': iconCode.toEJson(),
      'iconFont': iconFont.toEJson(),
      'color': color.toEJson(),
      'archived': archived.toEJson(),
      'currency': currency.toEJson(),
      'order': order.toEJson(),
      'balance': balance.toEJson(),
    };
  }

  static EJsonValue _toEJson(AccountModel value) => value.toEJson();
  static AccountModel _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'owner_id': EJsonValue ownerId,
        'name': EJsonValue name,
        'type': EJsonValue type,
        'iconCode': EJsonValue iconCode,
        'iconFont': EJsonValue iconFont,
        'color': EJsonValue color,
        'archived': EJsonValue archived,
        'currency': EJsonValue currency,
        'order': EJsonValue order,
        'balance': EJsonValue balance,
      } =>
        AccountModel(
          fromEJson(id),
          fromEJson(ownerId),
          fromEJson(name),
          fromEJson(type),
          fromEJson(iconCode),
          fromEJson(color),
          fromEJson(archived),
          fromEJson(currency),
          fromEJson(order),
          fromEJson(balance),
          iconFont: fromEJson(iconFont),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AccountModel._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, AccountModel, 'AccountModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.int),
      SchemaProperty('iconCode', RealmPropertyType.int),
      SchemaProperty('iconFont', RealmPropertyType.string, optional: true),
      SchemaProperty('color', RealmPropertyType.int),
      SchemaProperty('archived', RealmPropertyType.bool),
      SchemaProperty('currency', RealmPropertyType.string),
      SchemaProperty('order', RealmPropertyType.int),
      SchemaProperty('balance', RealmPropertyType.double),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
