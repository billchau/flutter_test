import 'dart:async';
import 'dart:developer';

import '../database/ExpenseDatabase.dart';
import '../model/Expense.dart';
import '../model/ExpenseType.dart';

class ExpenseSingleton {    
  static final ExpenseSingleton _singleton = new ExpenseSingleton._internal();

  factory ExpenseSingleton() {
    return _singleton;
  }

  ExpenseSingleton._internal() {
    log('xxxaaa, init singleton');
    db = new ExpenseDatabase();
  }

  ExpenseDatabase db;
  List<Expense> expenseList;

//1..12, use datetime.july sth instead
  getListFromMonth(int month) {
      if (expenseList.length > 0) {
        return expenseList.where((i) => i.time.month == month).toList();
      }
      return null;
  }

  getListFromType(ExpenseType expenseType){
      if (expenseList.length > 0) {
        return expenseList.where((i) => i.type.id == expenseType.id).toList();
      }
      return null;
  }
  getList() {
    return expenseList;
  }

  // getItem(int id){
  //   for (int i = 0; i < expenseList.length; i ++) {
  //     if (expenseList[i].id == id) {
  //       return expenseList[i];
  //     }
  //   }
  //   return null;
  // }
  getItem(int id){
    if (id > expenseList.length) {
    log('xxxaaa, get singleton id larger than items');  
    } else {
      return expenseList[id - 1];
    }
  }

  Future load() async {
    log('xxxaaa, init database type singleton');
    await db.init();
    expenseList = await db.getAllExpense();
  }

  Future update(Expense expense) async {
    log('xxxaaa, update database type singleton');
     expenseList[expense.id -1].type = expense.type;
     expenseList[expense.id -1].cost = expense.cost;
     expenseList[expense.id -1].time = expense.time;
    db.updateExpense(expense);
    return false;
  }

  Future add(Expense expense) async {
    log('xxxaaa, add database type singleton');

    db.updateExpense(expense);
    expense.id = expenseList.length + 1;
    expenseList.add(expense);

    return false;
  }
}