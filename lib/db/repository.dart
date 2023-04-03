import 'package:fb/db/account.dart';
import 'package:fb/db/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tableCategories = 'categories';
const String tableAccounts = 'accounts';
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
        join(await getDatabasesPath(), '$tableCategories.db'),
        onCreate: (Database db, int version) async {
      db.execute(migrationScripts[0]);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion + 1; i <= newVersion; i++) {
        db.execute(migrationScripts[i - 1]);
      }
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
