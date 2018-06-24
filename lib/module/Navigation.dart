
// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import '../model/ExpenseType.dart';
import 'ExpenseTypeListPage.dart';
import 'ExpenseListPage.dart';
import 'UpdateExpensePage.dart';
import 'VideoPage.dart';
import 'ApiPage.dart';
import 'FcmPage.dart';

//reference : https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/bottom_navigation_demo.dart
class NavigationIconView {
  NavigationIconView({
    Widget icon,
    String title,
    Color color,
    TickerProvider vsync,
  })  : _icon = icon,
        _color = color,
        _title = title,
        item = new BottomNavigationBarItem(
          icon: icon,
          title: new Text(title),
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(
      BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: new IconTheme(
          data: new IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: new Semantics(
            label: 'Placeholder for $_title tab',
            child: _icon,
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class BottomNavigationDemo extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  _BottomNavigationDemoState createState() => new _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  String appBarTitle = "";
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon:  new ImageIcon(new AssetImage("assets/bot_nav_main.png")),
        title: 'Expense',
        color: Colors.deepPurple,
        vsync: this,
      ),
      new NavigationIconView(
        icon: new ImageIcon(new AssetImage("assets/bot_nav_types.png")),
        title: 'Type',
        color: Colors.deepOrange,
        vsync: this,
      ),
      new NavigationIconView(
        icon: new ImageIcon(new AssetImage("assets/bot_nav_history.png")),
        title: 'History',
        color: Colors.teal,
        vsync: this,
      ),
      new NavigationIconView(
        icon: new ImageIcon(new AssetImage("assets/bot_nav_analysis.png")),
        title: 'Analysis',
        color: Colors.indigo,
        vsync: this,
      ),
      new NavigationIconView(
        icon: new ImageIcon(new AssetImage("assets/bot_nav_more.png")),
        title: 'More',
        color: Colors.pink,
        vsync: this,
      ),
          new NavigationIconView(
        icon: new ImageIcon(new AssetImage("assets/bot_nav_more.png")),
        title: 'FCM',
        color: Colors.pink,
        vsync: this,
      )
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }


  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });
    if (_currentIndex == 0) {
      this.appBarTitle = 'Add Expense';
      return new UpdateExpensePage();

     // home: new ExpenseTypeListPage(title: 'expense type', itemList: this.typeList),
    } else if (_currentIndex == 1) {
      this.appBarTitle = 'Expense Type';
      return new ExpenseTypeListPage(hasBackNavigation: false,);
    } else if (_currentIndex == 2) {
      this.appBarTitle = 'Expense History';

      return new ExpenseListPage(title: 'expense', hasBackNavigation: false,);
    } else if ( _currentIndex == 3) {
      return new ApiPage();
    } else if ( _currentIndex == 4) {
      return new VideoPage();
    } else if ( _currentIndex == 5) {
      return new FcmPage();
    }
    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text(appBarTitle),
        // actions: <Widget>[
        //   new PopupMenuButton<BottomNavigationBarType>(
        //     onSelected: (BottomNavigationBarType value) {
        //       setState(() {
        //         _type = value;
        //       });
        //     },
        //     itemBuilder: (BuildContext context) =>
        //         <PopupMenuItem<BottomNavigationBarType>>[
        //           const PopupMenuItem<BottomNavigationBarType>(
        //             value: BottomNavigationBarType.fixed,
        //             child: const Text('Fixed'),
        //           ),
        //           const PopupMenuItem<BottomNavigationBarType>(
        //             value: BottomNavigationBarType.shifting,
        //             child: const Text('Shifting'),
        //           )
        //         ],
        //   )
        // ],
      ),
      body: new Center(child: _buildTransitionsStack()),
      bottomNavigationBar: botNavBar,
    );
  }
}
