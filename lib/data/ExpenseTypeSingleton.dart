import 'dart:async';
import 'dart:developer';

import '../database/ExpenseTypeDatabase.dart';
import '../model/ExpenseType.dart';

class ExpenseTypeSingleton {
  static final ExpenseTypeSingleton _singleton =
      new ExpenseTypeSingleton._internal();

  factory ExpenseTypeSingleton() {
    //ExpenseTYpeDatabase.init();

    return _singleton;
  }

  ExpenseTypeSingleton._internal() {
    log('xxxaaa, init singleton');
    db = new ExpenseTypeDatabase();
  }

  ExpenseTypeDatabase db;
  List<ExpenseType> expenseTypeList;

  getList() {
    return expenseTypeList;
  }

  getItem(int id) {
    for (int i = 0; i < expenseTypeList.length; i++) {
      if (expenseTypeList[i].id == id) {
        return expenseTypeList[i];
      }
    }
    return null;
  }

  Future load() async {
    log('xxxaaa, init database type singleton');
    await db.init();
    expenseTypeList = await db.getAllExpenseType();
  }

  Future update(ExpenseType expenseType) async {
    log('xxxaaa, update database type singleton');
    db.updateExpenseType(expenseType);
    return false;
  }

  Future add(ExpenseType expenseType) async {
    log('xxxaaa, add database type singleton');
    expenseTypeList.add(expenseType);
    db.updateExpenseType(expenseType);
    return false;
  }

  Future init(List<ExpenseType> list) async {
    log('xxxaaa, add database type singleton');
        
    list.forEach((type) async {
     expenseTypeList.add(type); 
    });
    await db.addExpenseTypeList(list);
    // return false;
  }
}
