import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'employerSetup.dart';
import 'home_page.dart';
import 'models/employer.dart';
import 'logic/middleware.dart';
import 'logic/app_state.dart';
import 'logic/reducer.dart';
import 'login_modules/login_page.dart';

void main() => runApp(MyApp());

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class UserView {
  final FirebaseUser currentUser;
  final Employer currentEmployer;
  UserView({this.currentUser, this.currentEmployer});
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  final String title = "Commission Calculator";

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final store = new Store<AppState>(reducer,
      initialState: AppState(), middleware: [middleware].toList());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;

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

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    return _seen;
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: new MaterialApp(
            title: 'Commission Calculator',
            theme: new ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: FutureBuilder(
                future: checkFirstSeen(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return StoreConnector<AppState, UserView>(
                    converter: (store) => UserView(
                        currentUser: store.state.currentUser,
                        currentEmployer: store.state.currentEmployer),
                    builder: (context, user) {
                      if (user.currentUser == null) {
                        return new SignInScreen(
                            title: widget.title,
                            header: new Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 32.0),
                              child: new Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: new Text("Demo"),
                              ),
                            ),
                            providers: [
                              ProvidersTypes.google,
                              ProvidersTypes.email
                            ]);
                      }

                      if (snapshot.hasData){
                        if(!snapshot.data){
                          return new EmployerSetup(title: widget.title);
                        }
                        return new HomePage(title: widget.title);
                      }
                      return CircularProgressIndicator();
                    },
                  );
                })));
  }

  // else if (user.currentEmployer == null) {
  //   return new EmployerSetup(title: widget.title);
  // } else {
  //   return new HomePage(title: widget.title);
  // }

  void _checkCurrentUser() async {
    FirebaseUser _currentUser = await _auth.currentUser();
    new Timer(new Duration(milliseconds: 200), () {
      checkFirstSeen();
    });
    _currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      store.dispatch(new CheckUserAction(user));
      store.dispatch(new InitEmployersAction());
    });
  }
}
