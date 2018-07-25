import 'package:flutter/material.dart';
import 'dart:async';
import 'Employer.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'logic/middleware.dart';
import 'logic/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'commission_data_view.dart';
import 'logic/app_state.dart';

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
  int _counter = 0;

  Future _signOut(_HomeViewModel viewModel) async {
    await FirebaseAuth.instance.signOut();
    viewModel.onLogout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new StoreBuilder(
        builder: (context, Store<AppState> store) {
          return Center(
              child: ComissionView(date: DateTime.now())
              );
        },
      ),
      floatingActionButton:
          StoreConnector<AppState, _HomeViewModel>(converter: (Store<AppState> store) {
        return _HomeViewModel(
            onLogout: () => store.dispatch(new LogoutAction()),
            employers: store.state.employers,
            currentUser: store.state.currentUser);
      }, builder: (BuildContext context, _HomeViewModel viewModel) {
        return FloatingActionButton(
            onPressed: () => _signOut(viewModel),
            tooltip: "log out",
            child: new Text("Logout"));
      }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
