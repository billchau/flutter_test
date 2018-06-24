import '../data/ExpenseTypeSingleton.dart';
import 'BaseModel.dart';
import 'ExpenseType.dart';

class Expense extends BaseModel {
  int id;
  ExpenseType type;
  double cost;
  DateTime time;

  Expense(this.id, this.type, this.cost, this.time);

  Expense.fromDatabase(this.id, typeId, this.cost, dateTimeString) {
    type = (new ExpenseTypeSingleton()).getItem(typeId);
    time = DateTime.parse(dateTimeString);
  }
}