import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/Expense.dart';

//reference : https://github.com/tekartik/sqflite
class ExpenseDatabase {
  static final ExpenseDatabase _singleton = new ExpenseDatabase._internal();

  final String tableName = "EXPENSE";
  final String columnId = "ID";
  final String columnTypeId = "TYPE_ID";
  final String columnCost = "COST";
  final String columnDateTime = "CREATE_TIME";

  Database db;
  bool didInit = false;

  factory ExpenseDatabase() {
    return _singleton;
  }

  ExpenseDatabase._internal();

  expensefromMap(Map<String, dynamic> map) {
    return new Expense.fromDatabase(
        map[columnId], map[columnTypeId], map[columnCost], map[columnDateTime]);
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
                  `${columnTypeId}` INTEGER,
                  `${columnCost}` REAL,
                  `${columnDateTime}` TEXT
                  )''');
    }, onOpen: (Database db) async {
      await db.execute('''
              CREATE TABLE IF NOT EXISTS `$tableName` (
                    `${columnId}` INTEGER PRIMARY KEY AUTOINCREMENT,
                    `${columnTypeId}` INTEGER,
                    `${columnCost}` REAL,
                    `${columnDateTime}` TEXT
                    )''');
    });
    didInit = true;
    // await close();
  }

  /// Get all books with ids, will return a list with all the books found
  Future<List<Expense>> getAllExpense() async {
    log("xxxaaa, db, getAllExpenseType");
    List<Expense> expenseTypeList = <Expense>[];
    var db = await getDb();
    var result = await db.query('$tableName');
    for (Map<String, dynamic> item in result) {
      expenseTypeList.add(expensefromMap(item));
    }

    await close();
    return expenseTypeList;
  }

  /// Get all books with ids, will return a list with all the books found
  Future<List<Expense>> getExpense(List<int> ids) async {
    log("xxxaaa, db, getExpenseType");
    List<Expense> expenseList = <Expense>[];
    var db = await getDb();
    // Building SELECT * FROM TABLE WHERE ID IN (id1, id2, ..., idn)
    var idsString = ids.map((it) => '"$it"').join(',');
    var result = await db
        .rawQuery('SELECT * FROM $tableName WHERE ${columnId} IN ($idsString)');
    for (Map<String, dynamic> item in result) {
      expenseList.add(expensefromMap(item));
    }
    // await close();
    return expenseList;
  }

  Future updateExpense(Expense expense) async {
    log("xxxaaa, db, updateExpenseType");
    var db = await getDb();
    if (expense.id == -1) {
      await db.rawInsert('INSERT OR REPLACE INTO '
          '$tableName(${columnTypeId}, ${columnCost}, ${columnDateTime})'
          ' VALUES("${expense.type.id}", "${expense.cost}", "${expense.time.toString()}")');
    } else {
      await db.rawInsert('INSERT OR REPLACE INTO '
          '$tableName(${columnId}, ${columnTypeId}, ${columnCost}, ${columnDateTime})'
          ' VALUES("${expense.id}", "${expense.type.id}", "${expense.cost}", "${expense.time.toString()}")');
    }
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
