import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//reference : https://flutter.io/cookbook/networking/fetch-data/
/*
Api sample websiet
http://jsonapi.org/examples/
https://reqres.in
*/
class ApiPage extends StatefulWidget {
  @override
  State<ApiPage> createState() => new ApiState();

}

class ApiState extends State<ApiPage> {
  String textRespones = 'waiting for response';
  Future<http.Response> _loadApi () async {
    
    final response = await http.get('https://reqres.in/api/users?page=2');
    setState(() { textRespones = response.body.toString(); });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new FlatButton(
            child: new Text('click to load api'),
            onPressed: () => _loadApi(),
          ),
          new ListTile(title: new Text(textRespones))
        ],
      ),
    );
  }
}