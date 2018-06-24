import 'package:flutter/material.dart';
import 'dart:developer';
import '../data/ExpenseTypeSingleton.dart';
import '../model/ExpenseType.dart';

class ExpenseTypeListPage extends StatefulWidget {
  ExpenseTypeListPage({
    Key key,
    this.hasBackNavigation,
  }) : super(key: key);

  final String title;
  final bool hasBackNavigation;

  @override
  ExpenseTypeListState createState() => new ExpenseTypeListState();
}

class ExpenseTypeListState extends State<ExpenseTypeListPage> {
  ExpenseTypeSingleton expenseTypeSingleton;
  List<ExpenseType> _list;
  // List<ExpenseType> typeList = <ExpenseType>[
  //   new ExpenseType.fromARBG(1, 'Food', 255, 255, 0, 0),
  //   new ExpenseType.fromARBG(2, 'Fee', 255, 255, 255, 0),
  //   new ExpenseType.fromARBG(3, 'Tax', 255, 0, 255, 0)
  // ];

  @override
  void initState() {
    super.initState();
    expenseTypeSingleton = new ExpenseTypeSingleton();

    _list = expenseTypeSingleton.getList();
    //       debugPrint('xxxaaa, zero item, ' + _list.length.toString());
    // if (_list.length == 0) {
    //   debugPrint('xxxaaa, zero item, add some');
    //   var result = expenseTypeSingleton.init(this.typeList);
    //         debugPrint('xxxaaa, zero item, add some,  result: ' + result.toString());
    //   _list = expenseTypeSingleton.getList();
    //   // expenseTypeSingleton.init(this.typeList).then((it) {
    //   //   // _list = ex…penseTypeSingleton.getList();
    //   // });

    // } else {
    //   debugPrint('xxxaaa, some item, skip');
    // }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: (widget.hasBackNavigation)
          ? new AppBar(
            title: new Text('Update Expense Type'),
              leading: BackButton(),
            )
          : null,
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            new ExpenseTypeListItem(_list[index]),
        itemCount: _list.length,
      ),
    );
  }
}

class ExpenseTypeListItem extends StatelessWidget {
  const ExpenseTypeListItem(this.item);
  final ExpenseType item;

  goToEditPage(ExpenseType item){
    debugPrint('item clicked : ' + item.id.toString());
  }
  
  Widget _buildItem(ExpenseType item) {
    //if (item.)
    return new ListTile(
      leading: new Container(color: item.color,width: 25.0,height: 25.0,),
      title: new Text(item.name),
      trailing: new IconButton(icon: new Icon(Icons.edit), onPressed: () => goToEditPage(item),),
      // onTap: goToEditPage(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItem(item);
  }
}
