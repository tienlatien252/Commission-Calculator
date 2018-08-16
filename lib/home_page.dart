import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'dart:async';

import 'models/employer.dart';
import 'logic/app_state.dart';
import 'today_view.dart';
import 'drawer.dart';
import 'add_new_employer_dialog.dart';
import 'edit_data_view.dart';

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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children = [
    TodayView(),
    Container(
        child: Center(
      child: Text("History"),
    )),
    Container(
        child: Center(
      child: Text("Calculator"),
    ))
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<Null> _openEditCommissionDialog(Employer employer) async {
    // TODO implement the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditDataView(title: "Edit Employer");
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget editButton;
    if(_currentIndex == 0){
      editButton = StoreConnector<AppState, _HomeViewModel>(
          converter: (Store<AppState> store) {
        return _HomeViewModel(
            onLogout: () => store.dispatch(new LogoutAction()),
            employers: store.state.employers,
            currentUser: store.state.currentUser);
      }, builder: (BuildContext context, _HomeViewModel viewModel) {
        return FloatingActionButton(
            onPressed: () => _openEditCommissionDialog(null),
            child: Icon(Icons.edit));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MyDrawer(),
      body: _children[_currentIndex],
      floatingActionButton: editButton,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment), title: Text('Calculator'))
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
