import 'package:flutter/material.dart';
import 'dart:developer';
import '../data/ExpenseSingleton.dart';
import '../model/ExpenseType.dart';
import '../model/Expense.dart';
import './UpdateExpensePage.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ExpenseListPage extends StatefulWidget {
  ExpenseListPage({
    Key key,
    this.title,
    this.hasBackNavigation,
  }) : super(key: key);

  final String title;
  final bool hasBackNavigation;
  //final List<Expense> itemList;

  @override
  ExpenseListState createState() => new ExpenseListState();
}

class ExpenseListState extends State<ExpenseListPage> {
  ExpenseSingleton expenseSingleton;
  List<Expense> _list;

  @override
  void initState() {
    super.initState();
    expenseSingleton = new ExpenseSingleton();

    _list = expenseSingleton.getList();
    debugPrint('xxxaaa, zero item, ' + _list.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: (widget.hasBackNavigation)
          ? new AppBar(
              leading: BackButton(),
            )
          : null,
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            new ExpenseListItem(_list[index]),
        itemCount: _list.length,
      ),
    );
  }
}

class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem(this.item);
  final Expense item;

  goToEditPage(BuildContext context, Expense item) {
    debugPrint('item clicked : ' + item.id.toString());
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new UpdateExpensePage.fromExpense(item)));
  }

  @override
  Widget build(BuildContext context) {
    return _buildItem(context, item);
  }

  Widget _buildItem(BuildContext context, Expense item) {
    //if (item.)
    return new ListTile(
      leading: new Container(
        color: item.type.color,
        width: 25.0,
        height: 25.0,
      ),
      title: new Text(item.cost.toString()),
      subtitle: new Text(new DateFormat('yyyy-MM-dd')
                              .format(item.time)
                              .toString()),
      trailing: new IconButton(
        icon: new Icon(Icons.edit),
        onPressed: () => goToEditPage(context, item),
      ),
      // onTap: goToEditPage(item),
    );
  }
}
