import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'models/employer.dart';
import 'today_view.dart';
import 'logic/app_state.dart';
import 'drawer.dart';
import 'history_page/history_view.dart';
import 'account_dialog.dart';

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
    HistoryView(),
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

  void _openAddEntryDialog() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new AccountDialog();
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          StoreConnector<AppState, _HomeViewModel>(converter: (store) {
            return _HomeViewModel(currentUser: store.state.currentUser);
          }, builder: (BuildContext context, _HomeViewModel viewModel) {
            Widget accountIcon = Icon(Icons.account_circle);
            if (viewModel.currentUser.photoUrl != null) {
              accountIcon = CircleAvatar(
                backgroundImage: NetworkImage(viewModel.currentUser.photoUrl),
                maxRadius: 16.0,
              );
            }
            return IconButton(
              icon: accountIcon,
              onPressed: _openAddEntryDialog,
            );
          }),
        ],
      ),
      //drawer: MyDrawer(),
      body: _children[_currentIndex],
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
