import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'email_view.dart';
import 'utils.dart';

class LoginView extends StatefulWidget {
  final List<ProvidersTypes> providers;

  LoginView({
    Key key,
    @required this.providers,
  }) : super(key: key);

  @override
  _LoginViewState createState() =>  _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<ProvidersTypes, ButtonDescription> _buttons;

  _handleEmailSignIn() async {
    String value = await Navigator
        .of(context)
        .push( MaterialPageRoute<String>(builder: (BuildContext context) {
      return  EmailView();
    }));

    if (value != null) {
      _followProvider(value);
    }
  }

  _handleGoogleSignIn() async {
    GoogleSignIn _googleSignIn =  GoogleSignIn();

    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken != null) {
        try {
          FirebaseUser user = await _auth.signInWithGoogle(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          print(user);
        } catch (e) {
          showErrorDialog(context, e.details);
        }
      }
    }
  }

  _handleFacebookSignin() async {
    var facebookLogin =  FacebookLogin();
    FacebookLoginResult result =
        await facebookLogin.logInWithReadPermissions(['email']);
    if (result.accessToken != null) {
      try {
        FirebaseUser user = await _auth.signInWithFacebook(
            accessToken: result.accessToken.token);
        print(user);
      } catch (e) {
        showErrorDialog(context, e.details);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _buttons = {
      ProvidersTypes.facebook:
          providersDefinitions(context)[ProvidersTypes.facebook]
              .copyWith(onSelected: _handleFacebookSignin),
      ProvidersTypes.google:
          providersDefinitions(context)[ProvidersTypes.google]
              .copyWith(onSelected: _handleGoogleSignIn),
      ProvidersTypes.email: providersDefinitions(context)[ProvidersTypes.email]
          .copyWith(onSelected: _handleEmailSignIn),
    };

    return  Container(
        child:  Column(
            children: widget.providers.map((p) {
      return  Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _buttons[p] ??  Container());
    }).toList()));
  }

  void _followProvider(String value) {
    ProvidersTypes provider = stringToProvidersType(value);
    if (provider == ProvidersTypes.facebook) {
      _handleFacebookSignin();
    } else if (provider == ProvidersTypes.google) {
      _handleGoogleSignIn();
    }
  }
}
