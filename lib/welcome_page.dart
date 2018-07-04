import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_modules/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => new _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;

  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return new SignInScreen(
        title: widget.title,
        header: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: new Padding(
            padding: const EdgeInsets.all(32.0),
            child: new Text("Demo"),
          ),
        ),
        providers: [
          ProvidersTypes.facebook,
          ProvidersTypes.google,
          ProvidersTypes.email
        ],
      );
    } else {
      return new HomePage(title: widget.title, user: _currentUser);
    }
  }

  void _checkCurrentUser() async {
    _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      setState(() {
        _currentUser = user;
      });
    });
  }
}