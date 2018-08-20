export 'utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'login_view.dart';
import 'utils.dart';
import '../logic/app_state.dart';
import '../employer_page/employerSetup.dart';
import '../home_page.dart';
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
      this.store})
      : super(key: key);

  final String title;
  final Widget header;
  final List<ProvidersTypes> providers;
  final Color color;
  final Store<AppState> store;

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

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    return _seen;
  }

  void _checkCurrentUser() async {
    FirebaseUser _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) async {
      widget.store.dispatch(CheckUserAction(user));
      widget.store.dispatch(InitEmployersAction(getCurrentEmployer: true));
      bool firstSeen = await checkFirstSeen();

      if (widget.store.state.currentUser != null) {
        if (!firstSeen) {
          Navigator.of(context).pushReplacementNamed('/InitEmployerSetup');
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
          //Navigator.pushNamed(context, '/home');
        }
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
      if (viewModel.currentEmployer == null && _auth.currentUser() != null) {
        return LoadingView(title: widget.title);
      }
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

class LoadingView extends StatelessWidget {
  LoadingView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/*
FutureBuilder(
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
                          return EmployerSetup(title: widget.title, isInitialSetting: true,);
                        }
                        bool loading = store.state.currentEmployer == null;
                        if(loading){
                          //return HomePage(title: widget.title, loading: loading);
                          return LoadingView(title: widget.title);
                        }
                        return HomePage(title: widget.title);
                      }
                      return CircularProgressIndicator();
                    },
                  );
                })*/
