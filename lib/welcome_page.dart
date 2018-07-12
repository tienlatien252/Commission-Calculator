import 'dart:async';
import 'package:flutter/material.dart';
import 'AppState.dart';
import 'home_page.dart';
import 'employerSetup.dart';
import 'login_modules/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class UserView {
  final FirebaseUser currentUser;

  UserView({
    this.currentUser,
  });
}

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => new _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;
  final store = new Store<AppState>(reducer, initialState: AppState());

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
    return StoreProvider(
      store: store,
      child: new StoreConnector<AppState, UserView>(
          converter: (store) => UserView(currentUser: store.state.currentUser),
          builder: (context, user) {
            if (user.currentUser == null) {
              return new SignInScreen(
                title: widget.title,
                header: new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: new Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: new Text("Demo"),
                  ),
                ),
                providers: [ProvidersTypes.google, ProvidersTypes.email],
              );
            } else {
              return new EmployerSetup(title: widget.title);
            }
          }),
    );
  }

  void _checkCurrentUser() async {
    FirebaseUser _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      store.dispatch(new CheckUserAction(user));
    });
  }
}
