import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tableCategories = 'categories';

class Repository {
  late Database db;

  Future init() async {
    db = await openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), '$tableCategories.db'),
        onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        '''CREATE TABLE $tableCategories(
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          icon_code INT,
          icon_font TEXT,
          color INT,
          archived BOOL
        )''',
      );
    }, version: 1);
  }

  Future<void> createCategory(Category category) async {
    await db.insert(
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
        icon: IconData(maps[i]['icon_code'], fontFamily: maps[i]['icon_font']),
        color: Color(maps[i]['color']),
        archived: maps[i]['archived'] == 1,
      );
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
}

class Category implements Model {
  @override
  final int id;
  final String name;
  final IconData icon;
  final Color color;
  final bool archived;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
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
      'archived': archived,
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
