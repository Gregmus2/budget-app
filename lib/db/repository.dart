import 'package:fb/db/account.dart';
import 'package:fb/db/budget.dart';
import 'package:fb/db/category.dart';
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
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          icon_code INT,
          icon_font TEXT,
          color INT,
          archived BOOL,
          currency TEXT,
          "order" INT
        )''',
  '''
  CREATE TABLE $tableAccounts(
          id INTEGER PRIMARY KEY, 
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
          id INTEGER PRIMARY KEY, 
          note TEXT,
          "from" INT,
          to_account INT,
          to_category INT,
          amount_from REAL,
          amount_to REAL,
          date INT,
          FOREIGN KEY ("from") REFERENCES $tableAccounts(id) ON DELETE CASCADE,
          FOREIGN KEY (to_account) REFERENCES $tableAccounts(id) ON DELETE CASCADE,
          FOREIGN KEY (to_category) REFERENCES $tableCategories(id) ON DELETE CASCADE
        )
  ''',
  '''
  CREATE TABLE $tableBudgets(
          id INTEGER PRIMARY KEY, 
          category INT,
          month INT,
          amount REAL,
          FOREIGN KEY (category) REFERENCES $tableCategories(id) ON DELETE CASCADE
        )
  ''',
  '''
  ALTER TABLE $tableBudgets ADD COLUMN year INT
  ''',
  '''
  ALTER TABLE $tableCategories ADD COLUMN parent INT REFERENCES $tableCategories(id) ON DELETE CASCADE
  ''',
  '''
  ALTER TABLE $tableCategories ADD COLUMN type INT DEFAULT 0
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
        join(await getDatabasesPath(), '$tableCategories.db'), onCreate: (Database db, int version) async {
      for (var element in migrationScripts) {
        db.execute(element);
      }
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion + 1; i <= newVersion; i++) {
        db.execute(migrationScripts[i - 1]);
      }
    },
    onConfigure: (Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    });
  }

  Future<void> create(Model model) async {
    db.insert(
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
    db.update(
      model.tableName(),
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> delete(Model model) async {
    db.delete(
      model.tableName(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}

abstract class Model {
  final int id;

  Model(this.id);

  String tableName() {
    return '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }
}
