import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'employer_page/employerSetup.dart';
import 'home_page.dart';
import 'models/employer.dart';
import 'logic/middleware.dart';
import 'logic/app_state.dart';
import 'logic/reducer.dart';
import 'login_modules/login_page.dart';
import 'root_page.dart';

void main() => runApp(MyApp());

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class UserView {
  final FirebaseUser currentUser;
  final Employer currentEmployer;
  UserView({this.currentUser, this.currentEmployer});
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  final String title = "Commission Calculator";

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final store = Store<AppState>(reducer,
      initialState: AppState(), middleware: [middleware].toList());

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
            routes: <String, WidgetBuilder>{
              '/InitEmployerSetup': (BuildContext context) => EmployerSetup(
                    title: widget.title,
                    isInitialSetting: true,
                  ),
              '/loading': (BuildContext context) =>
                  LoadingView(title: widget.title),
              '/home': (BuildContext context) => HomePage(title: widget.title),
            },
            title: 'Commission Calculator',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: RootPage(
              store: store,
              title: widget.title,
            )));
  }
}

class LoadingView extends StatelessWidget {
  LoadingView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
