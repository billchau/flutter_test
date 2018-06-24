// Copyright 2017 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';

import 'data/ExpenseSingleton.dart';
import 'data/ExpenseTypeSingleton.dart';
import 'model/ExpenseType.dart';
import 'module/UpdateExpensePage.dart';
import 'module/Navigation.dart';
import 'module/ExpenseTypeListPage.dart';

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(new App());

class App extends StatefulWidget {
  State<App> createState() => new AppState();
}

class AppState extends State<App> {
  // This widget is the root of your application.
  ExpenseTypeSingleton expenseTypeSingleton;
  ExpenseSingleton expenseSingleton;
  bool init = true;

  List<ExpenseType> typeList = <ExpenseType>[
    new ExpenseType.fromARBG(1, 'Food', 255, 255, 0, 0),
    new ExpenseType.fromARBG(2, 'Fee', 255, 255, 255, 0),
    new ExpenseType.fromARBG(3, 'Tax', 255, 0, 255, 0)
  ];

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    log('xxxaaa, initState');
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);

 _firebaseMessaging.configure(
       onMessage: (Map<String, dynamic> message) {
         print("onMessage: $message");
         _showNotification();
       },
       onLaunch: (Map<String, dynamic> message) {
         print("onLaunch: $message");
         _showNotification();
       },
       onResume: (Map<String, dynamic> message) {
         print("onResume: $message");
         _showNotification();
       },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);

      print("Push Messaging token: $token");
    });
    expenseTypeSingleton = new ExpenseTypeSingleton();
    expenseSingleton = new ExpenseSingleton();
    expenseTypeSingleton.load().then((it) {
      debugPrint('xxxaaa, complete init type');
      List<ExpenseType> _list = expenseTypeSingleton.getList();
      debugPrint('xxxaaa, zero item, ' + _list.length.toString());

      if (_list.length == 0) {
        debugPrint('xxxaaa, zero item, add some');
        var result = expenseTypeSingleton.init(this.typeList).then((it) {
          expenseSingleton.load().then((et) {
            setState(() {
              debugPrint('xxxaaa, complete init expense');
              _list = expenseTypeSingleton.getList();
              debugPrint('xxxaaa, zero item, add some,  result: ' +
                  _list.length.toString());
              init = false;
            });
          });
        });

        // expenseTypeSingleton.init(this.typeList).then((it) {
        //   // _list = ex…penseTypeSingleton.getList();
        // });
      } else {
        debugPrint('xxxaaa, some item, skip');
        expenseSingleton.load().then((et) {
          setState(() {
            debugPrint('xxxaaa, complete init expense');

            init = false;
          });
        });
      }
    });

    // expenseSingleton.load().then((et) {
    //     setState(() {
    //       debugPrint('xxxaaa, complete init expense');

    //       init = false;
    //     });
    //   });
  }

  Future _showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name', 'your_channel_description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    } else {
      debugPrint('notification payload: xxx');
    }
    // await Navigator.push(
    //   context,
    //   new MaterialPageRoute(builder: (context) => (payload)),
    // );
}
  @override
  Widget build(BuildContext context) {
    return init
        ? new Container()
        : new MaterialApp(
            title: 'Flutter Demo',
            theme: new ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
              // counter didn't reset back to zero; the application is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: BottomNavigationDemo(),
            //home: new AddExpense(title: 'add expense',),
            // home: new ExpenseTypeListPage(title: 'expense type', itemList: this.typeList),
          );
  }
}
