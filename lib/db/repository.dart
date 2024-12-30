import 'dart:convert';

import 'package:fb/db/account.dart';
import 'package:fb/db/budget.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/model.dart';
import 'package:fb/db/transaction.dart' as model;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sync_proto_gen/sync.dart';
import 'package:sqflite_common/src/sql_builder.dart';

const String tableCategories = 'categories';
const String tableAccounts = 'accounts';
const String tableTransactions = 'transactions';
const String tableBudgets = 'budgets';
const String tableOperations = 'operations';
const migrationScripts = [
  '''CREATE TABLE $tableCategories(
          id BLOB PRIMARY KEY, 
          name TEXT, 
          icon_code INT,
          icon_font TEXT,
          color INT,
          archived BOOL,
          currency TEXT,
          "order" INT,
          type INT DEFAULT 0,
          parent BLOB REFERENCES $tableCategories(id) ON DELETE CASCADE
        )''',
  '''
  CREATE TABLE $tableAccounts(
          id BLOB PRIMARY KEY, 
          name TEXT,
          type INT,
          icon_code INT,
          icon_font TEXT,
          color INT,
          archived BOOL,
          currency TEXT,
          "order" INT,
          balance REAL
        )
  ''',
  '''
  CREATE TABLE $tableTransactions(
          id BLOB PRIMARY KEY, 
          note TEXT,
          from_account BLOB REFERENCES $tableAccounts(id) ON DELETE CASCADE,
          from_category BLOB REFERENCES $tableCategories(id) ON DELETE CASCADE,
          to_account BLOB REFERENCES $tableAccounts(id) ON DELETE CASCADE,
          to_category BLOB REFERENCES $tableCategories(id) ON DELETE CASCADE,
          amount_from REAL,
          amount_to REAL,
          date INT
        )
  ''',
  '''
  CREATE TABLE $tableBudgets(
          id BLOB PRIMARY KEY, 
          category BLOB REFERENCES $tableCategories(id) ON DELETE CASCADE,
          month INT,
          amount REAL,
          year INT
        )
  ''',
  // todo store temporary data in tables and send them to the server when online
  '''
  CREATE TABLE $tableOperations(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          operation_type TEXT NOT NULL,
          sql TEXT NOT NULL,
          args TEXT,
          related_entities TEXT NOT NULL
        ) 
  '''
];

// todo SQLLite optimizations (PRAGMA journal_mode=WAL;PRAGMA synchronous = NORMAL;)
// todo create sqllite indexes
// todo consider WITHOUT ROWID
class Repository {
  late Database db;

  Repository();

  Future init() async {
    db = await openDatabase(
        version: migrationScripts.length,
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'main.db'), onCreate: (Database db, int version) async {
      for (var element in migrationScripts) {
        db.execute(element);
      }
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion + 1; i <= newVersion; i++) {
        db.execute(migrationScripts[i - 1]);
      }
    }, onConfigure: (Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    });
  }

  Future<void> create(Model model) async {
    final builder = SqlBuilder.insert(model.tableName(), model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await db.rawInsert(builder.sql, builder.arguments);

    db.insert(
      tableOperations,
      createOperation(Operation_OperationType.OPERATION_CREATE, builder.sql, builder.arguments, model.relatedEntities()),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, Object?> createOperation(Operation_OperationType operationType, String sql, List<Object?>? args, List<Operation_Entity> relatedEntities) {
    return {
      'operation_type': operationType.toString(),
      'sql': sql,
      'args': jsonEncode(args),
      'related_entities': jsonEncode(relatedEntities)
    };
  }

  Future<List<Category>> listCategories() async {
    final List<Map<String, dynamic>> maps = await db.query(tableCategories);

    return List.generate(maps.length, (i) {
      return Category.mapDatabase(maps[i]);
    });
  }

  Future<List<Account>> listAccounts() async {
    final List<Map<String, dynamic>> maps = await db.query(tableAccounts);

    return List.generate(maps.length, (i) {
      return Account.mapDatabase(maps[i]);
    });
  }

  Future<void> updateTransferTargets(Category from, Category to) async {
    final builder = SqlBuilder.update(
      tableTransactions,
      {
        'from_category': to.id,
      },
      where: 'from_category = ?',
      whereArgs: [from.id],
    );
    await db.rawUpdate(builder.sql, builder.arguments);

    db.insert(
      tableOperations,
      createOperation(Operation_OperationType.OPERATION_UPDATE, builder.sql, builder.arguments, [
        Operation_Entity()
          ..id = from.id
          ..name = tableCategories,
        Operation_Entity()
          ..id = to.id
          ..name = tableCategories
      ]),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final builder2 = SqlBuilder.update(
      tableTransactions,
      {
        'to_category': to.id,
      },
      where: 'to_category = ?',
      whereArgs: [from.id],
    );
    db.rawUpdate(builder2.sql, builder2.arguments);

    db.insert(
      tableOperations,
      createOperation(Operation_OperationType.OPERATION_UPDATE, builder2.sql, builder2.arguments, [
        Operation_Entity()
          ..id = from.id
          ..name = tableCategories,
        Operation_Entity()
          ..id = to.id
          ..name = tableCategories
      ]),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<model.Transaction>> listTransactions(DateTimeRange range) async {
    final List<Map<String, dynamic>> maps = await db.query(tableTransactions,
        where: 'date >= ? AND date <= ?',
        whereArgs: [range.start.millisecondsSinceEpoch ~/ 1000, range.end.millisecondsSinceEpoch ~/ 1000],
        orderBy: 'date DESC');

    return List.generate(maps.length, (i) {
      return model.Transaction.mapDatabase(maps[i]);
    });
  }

  Future<List<Budget>> listBudgets(int month, int year) async {
    final List<Map<String, dynamic>> maps =
        await db.query(tableBudgets, where: 'month = ? AND year = ?', whereArgs: [month, year]);

    return List.generate(maps.length, (i) {
      return Budget.mapDatabase(maps[i]);
    });
  }

  Future<void> update(Model model) async {
    final builder = SqlBuilder.update(
      model.tableName(),
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    await db.rawUpdate(builder.sql, builder.arguments);

    db.insert(
      tableOperations,
      createOperation(Operation_OperationType.OPERATION_UPDATE, builder.sql, builder.arguments, model.relatedEntities()),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(Model model) async {
    final builder = SqlBuilder.delete(model.tableName(), where: 'id = ?', whereArgs: [model.id]);
    await db.rawDelete(builder.sql, builder.arguments);

    db.insert(
      tableOperations,
      createOperation(Operation_OperationType.OPERATION_DELETE, builder.sql, builder.arguments, model.relatedEntities()),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteAll(String table) async {
    await db.delete(table);

    db.insert(
      tableOperations,
      createOperation(Operation_OperationType.OPERATION_DELETE, "DELETE FROM $table", [], []),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> createBatch(List<Model> models) async {
    Batch batch = db.batch();
    for (var model in models) {
      final builder = SqlBuilder.insert(model.tableName(), model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      batch.rawInsert(builder.sql, builder.arguments);

      batch.insert(
        tableOperations,
        createOperation(Operation_OperationType.OPERATION_CREATE, builder.sql, builder.arguments, model.relatedEntities()),
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Operation>> getOperations() async {
    final List<Map<String, dynamic>> maps = await db.query(tableOperations);

    return List.generate(maps.length, (i) {
      List<Operation_Entity> relatedEntities = jsonDecode(maps[i]['related_entities']);

      return Operation(
        args: maps[i]['args'],
        sql: maps[i]['sql'],
        type: Operation_OperationType.valueOf(maps[i]['operation_type']),
        relatedEntities: relatedEntities
      );
    });
  }

  Future<void> applyOperations(List<Operation> operations) async {
    Batch batch = db.batch();
    for (var operation in operations) {
      batch.rawInsert(operation.sql, jsonDecode(operation.args));
    }

    await batch.commit(noResult: true);
  }
}
