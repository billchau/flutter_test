import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/Expense.dart';

class ExpenseDatabase {
  final String tableExpenseName = "EXPENSE";
  final String columnExpenseId = "ID";
  final String columnExpenseTypeId = "TYPE_ID";
  final String columnExpenseCost = "COST";
  final String columnExpenseDateTime = "DATETIME";

  final String tableETName = "EXPENSE_TYPE";
  final String columnETId = "ID";
  final String columnETColorValue = "COLOR_VALUE";
  final String columnETName = "NAME";

  Database db;
  bool didInit = false;

  Future init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "expense.db");
    log("xxxaaa, db, init database");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute('''
              CREATE TABLE $tableExpenseName (
                  ${columnExpenseId} INTEGER PRIMARY KEY,
                  ${columnExpenseTypeId} INTEGER,
                  ${columnExpenseCost} REAL,
                  ${columnExpenseDateTime} TEXT
                  )''');
        });
        didInit = true;
        await close();
  }


  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> getDb() async{
    if(!didInit) await init();
    return db;
  }

  Future close() async {
    didInit = false;
    db.close();
  }
}