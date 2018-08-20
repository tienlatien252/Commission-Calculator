export 'utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'login_view.dart';
import 'utils.dart';
import '../logic/app_state.dart';
import '../models/employer.dart';

class _LoginViewModel {
  _LoginViewModel({this.currentUser, this.currentEmployer});
  final Employer currentEmployer;
  final FirebaseUser currentUser;
}

class SignInScreen extends StatefulWidget {
  static String tag = 'login-page';
  SignInScreen(
      {Key key,
      this.title,
      this.header,
      this.providers,
      this.color = Colors.white,
      this.store,
      this.onSignedIn})
      : super(key: key);

  final String title;
  final Widget header;
  final List<ProvidersTypes> providers;
  final Color color;
  final Store<AppState> store;
  final VoidCallback onSignedIn;

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Widget get _header => widget.header ?? Container();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;

  List<ProvidersTypes> get _providers =>
      widget.providers ?? [ProvidersTypes.google, ProvidersTypes.email];

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

  void _checkCurrentUser() async {
    FirebaseUser _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) async {
      if(user != null){
        widget.store.dispatch(CheckUserAction(user));
        widget.store.dispatch(InitEmployersAction(getCurrentEmployer: true));
        widget.onSignedIn();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _LoginViewModel>(
        converter: (Store<AppState> store) {
      return _LoginViewModel(
          currentEmployer: store.state.currentEmployer,
          currentUser: store.state.currentUser);
    }, builder: (BuildContext context, _LoginViewModel viewModel) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            elevation: 4.0,
          ),
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(color: widget.color),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _header,
                      Expanded(child: LoginView(providers: _providers))
                    ],
                  ));
            },
          ));
    });
  }
}