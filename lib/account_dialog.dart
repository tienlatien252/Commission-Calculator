import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'employer_page/employers_list_view.dart';
import 'employer_page/employerSetup.dart';
import 'package:Calmission/services/firebase_auth_service.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/common_widgets/platform_alert_dialog.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';

class AccountDialog extends StatefulWidget {
  AccountDialog({Key key, this.onSignedOut}) : super(key: key);
  final VoidCallback onSignedOut;

  @override
  _AccountDialogState createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  Future<void> _signOut(BuildContext context) async {
    try {
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context);
      final EmployerService employerService =
          Provider.of<EmployerService>(context);

      await auth.signOut();
      await employerService.resetCurrentEmployer();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: "Logout",
      content: "Are You Sure?",
      cancelActionText: "cancel",
      defaultActionText: "logout",
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
      Navigator.pop(context, true);
    }
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
            String email = currentUser.email != null
                ? currentUser.email
                : "example@email.com";
            return Scaffold(
              appBar: AppBar(
                title: Text("Account"),
                backgroundColor: Colors.white,
              ),
              body: Column(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      accountName: Text(displayName),
                      accountEmail: Text(email),
                      currentAccountPicture: accountPicture),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text(
                          'Employers List',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Manage"),
                              Icon(Icons.arrow_right),
                            ],
                          ),
                        onTap: _openEmployersSetting,
                      ),
                    ],
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
                            title: const Text('Setting'),
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
                            onTap: () => _confirmSignOut(context)),
                      ],
                    ),
                  ),
                ],
              ),
            );

          case ConnectionState.waiting:
            return Center(child: PlatformLoadingIndicator());
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
