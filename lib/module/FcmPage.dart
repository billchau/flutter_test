import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//reference : https://github.com/flutter/plugins/tree/master/packages/firebase_messaging
class FcmPage extends StatefulWidget {
  @override
  State<FcmPage> createState() => new FcmAndApiState();

}

class FcmAndApiState extends State<FcmPage> {
  String textRespones = 'waiting for response';
  Future<http.Response> _loadApi () async {
// DATA='{"notification": {"body": "this is a body","title": "this is a title"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to": "<FCM TOKEN>"}'
// curl https://fcm.googleapis.com/fcm/send -H "Content-Type:application/json" -X POST -d "$DATA" -H "Authorization: key=<FCM SERVER KEY>"
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
            child: new Text('Send Fcm'),
            onPressed: () => _loadApi(),
          ),
          new FlatButton(
            child: new Text('Send Late Fcm'),
            onPressed: () => _loadApi(),
          ),
          new ListTile(title: new Text(' '),)
        ],
      ),
    );
  }
}