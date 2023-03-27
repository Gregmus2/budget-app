import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tableCategories = 'categories';
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
];

class Repository {
  late Database db;

  Future init() async {
    db = await openDatabase(
        version: migrationScripts.length,
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), '$tableCategories.db'),
        onCreate: (Database db, int version) async {
      db.execute(migrationScripts[0]);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion + 1; i <= newVersion; i++) {
        db.execute(migrationScripts[i - 1]);
      }
    });
  }

  Future<void> createCategory(Category category) async {
    db.insert(
      tableCategories,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Category>> listCategories() async {
    final List<Map<String, dynamic>> maps = await db.query(tableCategories);

    return List.generate(maps.length, (i) {
      return Category(
          id: maps[i]['id'],
          name: maps[i]['name'],
          icon:
              IconData(maps[i]['icon_code'], fontFamily: maps[i]['icon_font']),
          color: Color(maps[i]['color']).withOpacity(1),
          archived: maps[i]['archived'] == 1,
          currency: Currencies().find(maps[i]['currency'] ?? '') ??
              CommonCurrencies().euro,
          order: maps[i]['order']);
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

class Category implements Model {
  @override
  final int id;
  String name;
  IconData icon;
  Color color;
  bool archived;
  Currency currency;
  int order;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.currency,
    required this.order,
    this.archived = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon_code': icon.codePoint,
      'icon_font': icon.fontFamily,
      'color': color.value,
      'archived': (archived) ? 1 : 0,
      'currency': currency.code,
      'order': order,
    };
  }

  @override
  String tableName() {
    return tableCategories;
  }
}

class Model {
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
