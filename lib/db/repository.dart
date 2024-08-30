import 'package:fb/db/account.dart';
import 'package:fb/db/budget.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/model.dart';
import 'package:fb/db/transaction.dart' as model;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tableCategories = 'categories';
const String tableAccounts = 'accounts';
const String tableTransactions = 'transactions';
const String tableBudgets = 'budgets';
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
  '''
];

class Repository {
  late Database db;

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
    await db.insert(
      model.tableName(),
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
    await db.update(
      tableTransactions,
      {
        'from_category': to.id,
      },
      where: 'from_category = ?',
      whereArgs: [from.id],
    );
    db.update(
      tableTransactions,
      {
        'to_category': to.id,
      },
      where: 'to_category = ?',
      whereArgs: [from.id],
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
    await db.update(
      model.tableName(),
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> delete(Model model) async {
    await db.delete(
      model.tableName(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteAll(String table) async {
    await db.delete(table);
  }

  Future<void> createBatch(List<Model> models) async {
    Batch batch = db.batch();
    for (var model in models) {
      batch.insert(model.tableName(), model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }
}
