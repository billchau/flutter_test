import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/ExpenseType.dart';

class ExpenseTypeDatabase {
  static final ExpenseTypeDatabase _singleton =
      new ExpenseTypeDatabase._internal();

  final String tableName = "EXPENSE_TYPE";
  final String columnId = "ID";
  final String columnColorValue = "COLOR_VALUE";
  final String columnName = "NAME";

  Database db;
  bool didInit = false;

  factory ExpenseTypeDatabase() {
    return _singleton;
  }

  ExpenseTypeDatabase._internal();

  expenseTypefromMap(Map<String, dynamic> map) {
    return new ExpenseType(
        map[columnId], map[columnName], map[columnColorValue]);
  }

  expenseTypeToMap(ExpenseType type) {
    Map<String, dynamic> map = new Map();
    if (type != null && type.id != null) {
      map[columnId] = type.id;
    }
    map[columnName] = type.name;
    map[columnColorValue] = type.colorValue;
        log("xxxaaa, db, init database map: " +map.toString());
    return map;
  }

  Future init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "expense.db");
    log("xxxaaa, db, init database");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute('''
              CREATE TABLE IF NOT EXISTS `$tableName` (
                  `${columnId}` INTEGER PRIMARY KEY AUTOINCREMENT,
                  `${columnName}` TEXT,
                  `${columnColorValue}` INTEGER
                  )''');
    }, onOpen: (Database db) async {
      await db.execute('''
              CREATE TABLE IF NOT EXISTS `$tableName` (
                  `${columnId}` INTEGER PRIMARY KEY AUTOINCREMENT,
                  `${columnName}` TEXT,
                  `${columnColorValue}` INTEGER
                  )''');
    });
    didInit = true;
    //await close();
  }

  /// Get all books with ids, will return a list with all the books found
  Future<List<ExpenseType>> getAllExpenseType() async {
    log("xxxaaa, db, getAllExpenseType");
    List<ExpenseType> expenseTypeList = <ExpenseType>[];
    var db = await getDb();
    var result = await db.query('$tableName');
    for (Map<String, dynamic> item in result) {
      expenseTypeList.add(expenseTypefromMap(item));
    }

    await close();
    return expenseTypeList;
  }

  /// Get all books with ids, will return a list with all the books found
  Future<List<ExpenseType>> getExpenseType(List<int> ids) async {
    log("xxxaaa, db, getExpenseType");
    List<ExpenseType> expenseTypeList = <ExpenseType>[];
    var db = await getDb();
    // Building SELECT * FROM TABLE WHERE ID IN (id1, id2, ..., idn)
    var idsString = ids.map((it) => '"$it"').join(',');
    var result = await db
        .rawQuery('SELECT * FROM $tableName WHERE ${columnId} IN ($idsString)');
    for (Map<String, dynamic> item in result) {
      expenseTypeList.add(expenseTypefromMap(item));
    }
    // await close();
    return expenseTypeList;
  }

  Future addExpenseTypeList(List<ExpenseType> list) async {
    // db.transaction((txn) async {
    //   // var batch = txn.batch();
    //   list.forEach((type) async {
    //     await txn.insert(tableName, expenseTypeToMap(type));
    //        log("xxxaaa, db, addExpenseTypeList, add one");
    //   });
    //   // var results = await batch.commit();
    //   // Concurrent modification during iteration
    //   log("xxxaaa, db, addExpenseTypeList, results");
    // });

    var db = await getDb();
    var batch = db.batch();
      list.forEach((type) {
    batch.rawInsert('INSERT OR REPLACE INTO '
        '$tableName(${columnId}, ${columnName}, ${columnColorValue})'
        ' VALUES("${type.id}", "${type.name}", "${type.colorValue}")');
      });
// batch.insert(tableName, expenseTypeToMap(list[0]));
    return await batch.commit();
    // log("xxxaaa, db, int result = " + result.toString());
  }

  Future updateExpenseType(ExpenseType expenseType) async {
    log("xxxaaa, db, updateExpenseType");
    var db = await getDb();

    ///  await db.inTransaction(() async {
    await db.rawInsert('INSERT OR REPLACE INTO '
        '$tableName(${columnId}, ${columnName}, ${columnColorValue})'
        ' VALUES("${expenseType.id}", "${expenseType.name}", "${expenseType.colorValue}")');
    //});
  }

  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> getDb() async {
    if (!didInit) await init();
    return db;
  }

  Future close() async {
    didInit = false;
    db.close();
  }
}
