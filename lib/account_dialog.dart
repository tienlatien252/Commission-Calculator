import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'models/employer.dart';
import 'logic/app_state.dart';
import 'main.dart';
import 'employer_page/employers_list_view.dart';
import 'employer_page/employerSetup.dart';

class _DrawerViewModel {
  _DrawerViewModel(
      {this.employers,
      this.onGetCurrentEmployer,
      this.currentUser,
      this.onLogout});
  final List<Employer> employers;
  final Function() onGetCurrentEmployer;
  final FirebaseUser currentUser;
  final Function() onLogout;
}

class AccountDialog extends StatefulWidget {
  AccountDialog({Key key}) : super(key: key);

  @override
  _AccountDialogState createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  Future _signOut(_DrawerViewModel viewModel) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', false);

    viewModel.onLogout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  _openSetting(_DrawerViewModel viewModel) {
    print("openSetting");
  }

  _openEmployersSetting(_DrawerViewModel viewModel) {
    print("openEmployersSetting");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => EmployerSetup(
              title: 'Manage Employers', isInitialSetting: false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _DrawerViewModel>(
        converter: (Store<AppState> store) {
      return _DrawerViewModel(
          onLogout: () => store.dispatch(new LogoutAction()),
          employers: store.state.employers,
          currentUser: store.state.currentUser);
    }, builder: (BuildContext context, _DrawerViewModel viewModel) {
      String displayName = viewModel.currentUser.displayName == null
          ? 'Name'
          : viewModel.currentUser.displayName;
      Widget accountPicture = viewModel.currentUser.photoUrl != null
          ? CircleAvatar(
              //backgroundColor: Colors.amber,
              child: Image.network(viewModel.currentUser.photoUrl),)
          : Icon(Icons.account_circle); //FlutterLogo(size: 42.0);
      return Scaffold(
        appBar: AppBar(
          title: Text("Account"),
        ),
        body: ListView(
          children: <Widget>[
            Column(children: [
              Column(children: [
                UserAccountsDrawerHeader(
                    accountName: Text(displayName),
                    accountEmail: Text(viewModel.currentUser.email),
                    currentAccountPicture: accountPicture),
                ListTile(
                    title: const Text('Employers List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                    ),
                EmployersListView(
                  isDrawer: true,
                ),
              ]),
              Column(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Manage Employers'),
                      onTap: () {
                        _openEmployersSetting(viewModel);
                      }),
                  ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        _openSetting(viewModel);
                      }),
                  ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Logout'),
                      onTap: () {
                        Navigator.pop(context);
                        _signOut(viewModel);
                      }),
                ],
              )
            ])
          ],
        ),
      );
    });
  }
}
