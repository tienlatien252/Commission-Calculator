import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'l10n/localization.dart';
import 'trouble_signin.dart';
import 'utils.dart';
import 'package:Calmission/services/firebase_auth_service.dart';
import 'package:Calmission/login_modules/sign_in_manager.dart';
import 'package:Calmission/services/auth_service.dart';


class PasswordView extends StatefulWidget {
  final String email;

  PasswordView({@required this.email, Key key}) : super(key: key);

  @override
  _PasswordViewState createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  TextEditingController _controllerEmail;
  TextEditingController _controllerPassword;

  @override
  initState() {
    super.initState();
    _controllerEmail = TextEditingController(text: widget.email);
    _controllerPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _controllerEmail.text = widget.email;
    return Scaffold(
        appBar: AppBar(
          title: Text(FFULocalizations.of(context).signInTitle),
          elevation: 4.0,
          backgroundColor: Colors.white,
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                        labelText: FFULocalizations.of(context).emailLabel),
                  ),
                  //const SizedBox(height: 5.0),
                  TextField(
                    autofocus: true,
                    controller: _controllerPassword,
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                        labelText: FFULocalizations.of(context).passwordLabel),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                          child: Text(
                            FFULocalizations.of(context).troubleSigningInLabel,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onTap: _handleLostPassword)),
                ],
              ),
            );
          },
        ),
        floatingActionButton: ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: () => _connexion(context),
              child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  //margin: EdgeInsets.all(10.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Theme.of(context).accentColor,
                  ),
                  child: Text(
                    FFULocalizations.of(context).signInLabel,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  )),
            ),
          ],
        ));
  }

  _handleLostPassword() {
    Navigator.of(context)
        .push(new MaterialPageRoute<Null>(builder: (BuildContext context) {
      return TroubleSignIn(_controllerEmail.text);
    }));
  }

  _connexion(BuildContext context) async {
    User user;
    try {
       final FirebaseAuthService _auth = Provider.of<FirebaseAuthService>(context, listen: false);
      user = await _auth.signInWithEmailAndPassword(_controllerEmail.text,  _controllerPassword.text);
      print(user);
    } catch (exception) {
      //TODO improve errors catching
      String msg = FFULocalizations.of(context).passwordInvalidMessage;
      showErrorDialog(context, msg);
    }

    if (user != null) {
      Navigator.of(context).pop(true);
    }
  }
}