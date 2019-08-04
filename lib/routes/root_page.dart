import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:redux/redux.dart';

//import '../logic/app_state.dart';
import '../login_modules/login_page.dart';
import 'home_root_page.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return SignInScreen(
            onSignedIn: _signedIn,
            title: widget.title,
            header: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    FittedBox(child: Text("Login", style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),)),
                  ],
                ),
              ),
            ));
      case AuthStatus.signedIn:
        return HomeRootPage(
          onSignedOut: _signedOut,
          title: widget.title,
        );
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
