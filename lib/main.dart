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
        child: MaterialApp(
            title: 'Commission Calculator',
            theme: ThemeData(
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
                        return SignInScreen(
                            title: widget.title,
                            header: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 32.0),
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Text("Demo"),
                              ),
                            ),
                            providers: [
                              ProvidersTypes.google,
                              ProvidersTypes.email
                            ]);
                      }

                      if (snapshot.hasData){
                        if(!snapshot.data){
                          return EmployerSetup(title: widget.title);
                        }
                        //store.dispatch(InitEmployersAction());
                        //store.dispatch(ChangeCurrentEmployerAction(store.state.employers[0]));
                        return HomePage(title: widget.title);
                      }
                      return CircularProgressIndicator();
                    },
                  );
                })));
  }

  void _checkCurrentUser() async {
    FirebaseUser _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    if(store.state.currentUser != null){
      store.dispatch(InitEmployersAction());
      //store.dispatch(ChangeCurrentEmployerAction(store.state.employers[0]));
    }

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      store.dispatch(CheckUserAction(user));
      store.dispatch(InitEmployersAction());
    });
  }
}
