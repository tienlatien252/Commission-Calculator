import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'dart:async';

import 'models/employer.dart';
import 'logic/middleware.dart';
import 'logic/app_state.dart';
import 'main.dart';
import 'commission_data_view.dart';
import 'logic/app_state.dart';
import 'models/commission.dart';
import 'today_view.dart';

class _HomeViewModel {
  _HomeViewModel(
      {this.employers,
      this.onGetCurrentEmployer,
      this.currentUser,
      this.onLogout});
  final List<Employer> employers;
  final Function() onGetCurrentEmployer;
  final FirebaseUser currentUser;
  final Function() onLogout;
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children = [
    TodayView(),
    new Container(
        child: new Center(
      child: new Text("History"),
    )),
    new Container(
        child: new Center(
      child: new Text("Calculator"),
    ))
  ];

  Future _signOut(_HomeViewModel viewModel) async {
    await FirebaseAuth.instance.signOut();
    viewModel.onLogout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _children[_currentIndex],
      floatingActionButton: StoreConnector<AppState, _HomeViewModel>(
          converter: (Store<AppState> store) {
        return _HomeViewModel(
            onLogout: () => store.dispatch(new LogoutAction()),
            employers: store.state.employers,
            currentUser: store.state.currentUser);
      }, builder: (BuildContext context, _HomeViewModel viewModel) {
        return FloatingActionButton(
            onPressed: () => _signOut(viewModel),
            tooltip: "log out",
            child: new Text("Logout"));
      }),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.assessment), title: Text('Calculator'))
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
