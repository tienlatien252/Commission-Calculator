import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'employer_page/employers_list_view.dart';
import 'employer_page/employerSetup.dart';

class AccountDialog extends StatefulWidget {
  AccountDialog({Key key, this.onSignedOut}) : super(key: key);
  final VoidCallback onSignedOut;

  @override
  _AccountDialogState createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  _signOut() {
    Navigator.pop(context, true);
  }

  _openSetting() {
    print("openSetting");
  }

  _openEmployersSetting() {
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
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            FirebaseUser currentUser = snapshot.data;
            String displayName = currentUser.displayName == null
                ? 'Name'
                : currentUser.displayName;
            Widget accountPicture = currentUser.photoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(currentUser.photoUrl),
                  )
                : Icon(Icons.account_circle);
            return Scaffold(
              appBar: AppBar(
                title: Text("Account"),
              ),
              body: Column(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
                      accountName: Text(displayName),
                      accountEmail: Text(currentUser.email),
                      currentAccountPicture: accountPicture),
                  ListTile(
                    title: const Text(
                      'Employers List',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  Expanded(
                    child: EmployersListView(
                      isDrawer: true,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('Manage Employers'),
                            onTap: () {
                              _openEmployersSetting();
                            }),
                        // ListTile(
                        //     leading: const Icon(Icons.settings),
                        //     title: const Text('Settings'),
                        //     onTap: () {
                        //       _openSetting();
                        //     }),
                        ListTile(
                            leading: const Icon(Icons.exit_to_app),
                            title: const Text('Logout'),
                            onTap: _signOut),
                      ],
                    ),
                  ),

                  //ListView(children: [
                  // Column(children: [
                  //   UserAccountsDrawerHeader(
                  //       accountName: Text(displayName),
                  //       accountEmail: Text(currentUser.email),
                  //       currentAccountPicture: accountPicture),
                  //   ListTile(
                  //     title: const Text(
                  //       'Employers List',
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold, fontSize: 20.0),
                  //     ),
                  //   ),
                  //   EmployersListView(
                  //     isDrawer: true,
                  //   ),
                  // ]),
                  // Column(
                  //   children: <Widget>[
                  //     ListTile(
                  //         leading: const Icon(Icons.edit),
                  //         title: const Text('Manage Employers'),
                  //         onTap: () {
                  //           _openEmployersSetting();
                  //         }),
                  //     ListTile(
                  //         leading: const Icon(Icons.settings),
                  //         title: const Text('Settings'),
                  //         onTap: () {
                  //           _openSetting();
                  //         }),
                  //     ListTile(
                  //         leading: const Icon(Icons.exit_to_app),
                  //         title: const Text('Logout'),
                  //         onTap: _signOut),
                  //   ],
                  // )
                  //])
                ],
              ),
            );

          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return Text('Result: ${snapshot.data}');
        }
      },
    );
  }
}
