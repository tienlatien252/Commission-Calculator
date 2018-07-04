import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  HomePage({Key key, this.title, this.user}) : super(key: key);
  final String title;
  final FirebaseUser user;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future <WelcomePage> _signOut()  async{
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
              widget.user.email,
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _signOut,
        tooltip: 'sign out',
        child: new Text("Logout"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
