import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:Calmission/employer_page/employers_list_view.dart';
import 'package:Calmission/employer_page/employerSetup.dart';
import 'package:Calmission/services/firebase_auth_service.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:Calmission/common_widgets/platform_alert_dialog.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';
import 'package:Calmission/common_widgets/CustomButton.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key, this.onSignedOut}) : super(key: key);
  final VoidCallback onSignedOut;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
    }
  }

  _openEmployersSetting() {
    print("openEmployersSetting");
    Navigator.push(
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
            return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: Text(
                  "Profile & Settings",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              body: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      CustomListTile(
                        onTap: _openEmployersSetting,
                        title: displayName,
                        subtitle: 'Manage Account',
                      ),
                      CustomListTile(
                        onTap: _openEmployersSetting,
                        title: 'Settings',
                        subtitle: 'Languages,',
                      ),
                      CustomListTile(
                        onTap: _openEmployersSetting,
                        title: 'Employers',
                        subtitle: 'Manage',
                      ),
                    ],
                  ),
                  Expanded(
                    child: EmployersListView(
                      isDrawer: true,
                    ),
                  ),
                  Container(
                    //color: Colors.white,
                    child: CustomButtonBar(
                      text: "Logout",
                      onTap: () => _confirmSignOut(context),
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
