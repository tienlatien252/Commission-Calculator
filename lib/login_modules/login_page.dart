export 'utils.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'utils.dart';
import 'package:Calmission/services/firebase_auth_service.dart';
import 'package:Calmission/common_widgets/platform_exception_alert_dialog.dart';
import 'package:Calmission/login_modules/email_view.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';

class SignInScreen extends StatelessWidget {
  static String tag = 'login-page';
  SignInScreen({
    Key key,
    this.title,
    this.header,
    this.color = Colors.white,
  }) : super(key: key);

  final String title;
  final Widget header;
  final Color color;
  List<ProvidersTypes> get _providers =>
      [ProvidersTypes.google, ProvidersTypes.email, ProvidersTypes.anonymous];

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth = Provider.of<FirebaseAuthService>(context);
    return SignInPage._(
      providers: _providers,
      isLoading: auth.status == Status.Authenticating,
      color: color,
      title: title,
    );
  }
}

class SignInPage extends StatelessWidget {
  // TODO: findout why he used SignInPage._() instead of SignInPage()
  SignInPage._({
    Key key,
    this.isLoading,
    this.title,
    this.color,
    @required this.providers,
  }) : super(key: key);

  Map<ProvidersTypes, ButtonDescription> _buttons;
  final List<ProvidersTypes> providers;
  final String title;
  final bool isLoading;
  final Color color;

  Future<void> _showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: "Strings.signInFailed",
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final FirebaseAuthService _auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await _auth.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final FirebaseAuthService _auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await _auth.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final FirebaseAuthService _auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await _auth.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) {
          return EmailView();
        }, //(_) => EmailPasswordSignInPageBuilder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              Image.asset('assets/icon-retangle.png'),
              SizedBox(
                width: 5.0,
              ),
              Text(title),
            ],
          ),
          elevation: 4.0,
        ),
        backgroundColor: Colors.grey[200],
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Expanded(child: _buildSignIn(context))],
        ));
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: PlatformLoadingIndicator(),
      );
    }
    return Text(
      "Logo Place Holder",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    _buttons = {
      ProvidersTypes.facebook:
          providersDefinitions(context)[ProvidersTypes.facebook]
              .copyWith(onSelected: () => _signInWithFacebook(context)),
      ProvidersTypes.google:
          providersDefinitions(context)[ProvidersTypes.google]
              .copyWith(onSelected: () => _signInWithGoogle(context)),
      ProvidersTypes.email: providersDefinitions(context)[ProvidersTypes.email]
          .copyWith(onSelected: () => _signInWithEmailAndPassword(context)),
      ProvidersTypes.anonymous:
          providersDefinitions(context)[ProvidersTypes.anonymous]
              .copyWith(onSelected: () => _signInAnonymously(context)),
    };
    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: color),
        child: Column(children: <Widget>[
          _buildHeader(),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: providers.map((p) {
                  return Container(
                      // decoration: ShapeDecoration(
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15.0)),
                      //   color: Theme.of(context).accentColor.withAlpha(100),
                      // ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _buttons[p] ?? Container());
                }).toList()),
          )
        ]));
  }
}
