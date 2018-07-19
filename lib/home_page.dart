import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_page.dart';
import 'Employer.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'app_state/middleware.dart';
import 'app_state/AppState.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  Future<WelcomePage> _signOut() async {
    await FirebaseAuth.instance.signOut();
    return new WelcomePage();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton:
          StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
        return FloatingActionButton(
            onPressed: _signOut,
            tooltip: "log out",
            child: new Text("Logout"));
      }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
