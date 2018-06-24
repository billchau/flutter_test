import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../data/ExpenseSingleton.dart';
import '../data/ExpenseTypeSingleton.dart';
import '../model/Expense.dart';
import '../model/ExpenseType.dart';
import 'ExpenseTypeListPage.dart';

class UpdateExpensePage extends StatefulWidget {
  UpdateExpensePage.fromExpense(Expense expense) {
    this.id = expense.id;
    this.type = expense.type;
    this.time = expense.time;
    this.cost = expense.cost;
    this.hasBackNavigation = true;
  }
  UpdateExpensePage({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;
  final DateTime startDate = DateTime(2018);
  final DateTime endDate = DateTime(2058);
  final DateTime initDate = DateTime.now();

  int id = -1;
  ExpenseType type;
  DateTime time;
  double cost;
  bool hasBackNavigation = false;
  UpdateExpensePageState createState() => new UpdateExpensePageState();
}

class UpdateExpensePageState extends State<UpdateExpensePage> {
  // AddExpenseState
  TextEditingController _amountTextController = new TextEditingController();
  DateTime _selectedDate;
  List<ExpenseType> typeList;
  ExpenseSingleton expenseSingleton;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentType;
  //id == -1 means it's new expense, otherwise, it's just an update
  @override
  void initState() {
    typeList = (new ExpenseTypeSingleton()).getList();
    if (typeList.length > 0) {
      _dropDownMenuItems = getDropDownMenuItems();
      //auto fill in data if not empty
      if (widget.id > -1) {
        _currentType = _dropDownMenuItems[widget.type.id - 1].value;
      } else {
        _currentType = _dropDownMenuItems[0].value;
      }
    }
    expenseSingleton = new ExpenseSingleton();
    if (widget.id != -1) {
      _amountTextController.text = widget.cost.toString();
      _selectedDate = widget.time;
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _amountTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: (widget.hasBackNavigation)
          ? new AppBar(
              title: new Text('Update Expense'),
              leading: BackButton(),
            )
          : null,
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                flex: 1,
                child: new Container(),
              ),
              new Expanded(
                flex: 2,
                child: new DropdownButton(
                  iconSize: 0.0,
                  value: _currentType,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                  // style: new TextStyle(
                  //   decorationColor: Colors.blue,
                  // ),
                ),
              ),
              new Icon(Icons.arrow_drop_down),
              new Expanded(flex: 1, child: new Container()),
            ],
          ),
          new Row(children: <Widget>[
            new Expanded(flex: 1, child: new Container()),
            new Expanded(
                flex: 2,
                child: new RaisedButton(
                    padding: EdgeInsets.all(8.0),
                    textTheme: ButtonTextTheme.primary,
                    color: Colors.blue,
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: new Text(
                      _selectedDate == null
                          ? "select a date"
                          : new DateFormat('yyyy-MM-dd')
                              .format(_selectedDate)
                              .toString(),
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ))),
            new Expanded(flex: 1, child: new Container()),
          ]),
          new Row(children: <Widget>[
            new Expanded(flex: 1, child: new Container()),
            new Expanded(
                flex: 2,
                child: new TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _amountTextController,
                    decoration:
                        new InputDecoration(hintText: "Type the amount"))),
            new Expanded(flex: 1, child: new Container()),
          ]),
          new Row(children: <Widget>[
            new Expanded(flex: 1, child: new Container()),
            new Expanded(
                flex: 2,
                child: new FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  padding: EdgeInsets.all(8.0),
                  color: Colors.blue,
                  child: new Text(
                    (widget.id == -1) ? "Add" : 'Update',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    // _pushNewPage();

                    if (!_amountTextController.text.isEmpty &&
                        _selectedDate != null) {
                      //start update / add
                      if (widget.id == -1) {
                        expenseSingleton
                            .add(new Expense(
                                -1,
                                typeList[int.parse(_currentType) - 1],
                                double.parse(_amountTextController.text),
                                _selectedDate))
                            .then((it) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return new AlertDialog(
                                  // Retrieve the text the user has typed in using our
                                  // TextEditingController
                                  content: new Text('Create Success'),
                                );
                              });
                        });
                      } else {
                        debugPrint('add/update ' +
                            widget.id.toString() +
                            ', ' +
                            typeList[int.parse(_currentType) - 1].toString() +
                            ', ' +
                            double
                                .parse(_amountTextController.text)
                                .toString() +
                            ', ' +
                            _selectedDate.toString());
                        expenseSingleton
                            .update(new Expense(
                                widget.id,
                                typeList[int.parse(_currentType) - 1],
                                double.parse(_amountTextController.text),
                                _selectedDate))
                            .then((it) {
                              _goBack();
                          // showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       return new AlertDialog(
                          //         // Retrieve the text the user has typed in using our
                          //         // TextEditingController
                          //         content: new Text('Update Success'),
                          //         actions: <Widget>[
                          //           new FlatButton(
                          //             child: new Text('OK'),
                          //             // onPressed: () => Navigator.pop(context),
                          //             onPressed: () => _goBack(),
                          //           )
                          //         ],
                          //       );
                          //     });
                        });
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            // Retrieve the text the user has typed in using our
                            // TextEditingController
                            content: new Text("Please input all data"),
                          );
                        },
                      );
                    }
                  },
                )),
            new Expanded(flex: 1, child: new Container()),
          ]),
        ],
      ),
    );
  }

  void changedDropDownItem(String selectedType) {
    print("Selected city $selectedType, we are going to refresh the UI");
    setState(() {
      _currentType = selectedType;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (ExpenseType type in typeList) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: type.id.toString(),
          child: new Container(
            // decoration: new BoxDecoration(color: Colors.blue),
            child: new Text(
              type.name,
              // style: new TextStyle(
              //   color: Colors.white,
              //   fontSize: 24.0,
              // ),
            ),
          )));
    }
    return items;
  }

  _pushNewPage() {
    Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (context) => new ExpenseTypeListPage(
                  hasBackNavigation: true,
                ),
          ),
        );
  }

  _goBack(){
    Navigator.pop(context);
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate == null ? widget.initDate : _selectedDate,
        firstDate: widget.startDate,
        lastDate: widget.endDate);
    print(_selectedDate == null
        ? '_selectedDate null'
        : '1 ' + _selectedDate.toString());
    print(picked == null ? 'pick null' : '2 ' + picked.toString());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  initDb() {}

  updateDb() {}
}
