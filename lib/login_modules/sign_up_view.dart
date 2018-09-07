import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'l10n/localization.dart';
import 'utils.dart';

class SignUpView extends StatefulWidget {
  final String email;

  SignUpView(this.email, {Key key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();

  String _emailText;
  String _nameText;
  String _password;

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Email Is Not Valid';
    else
      return null;
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validatePassword(String value) {
    Pattern numberPattern = r'[0-9]';
    RegExp numberRegex = new RegExp(numberPattern);
    Pattern lowerCasePattern = r'[a-z]';
    RegExp lowerCasRegex = new RegExp(lowerCasePattern);
    Pattern upperCasePattern = r'[A-Z]';
    RegExp upperCasRegex = new RegExp(upperCasePattern);
    if (value.length < 6) {
      return "Password must contain at least six characters";
    }
    if (!numberRegex.hasMatch(value)) {
      return 'Password must contain at least one number (0-9)';
    }
    if (!lowerCasRegex.hasMatch(value) && !upperCasRegex.hasMatch(value)) {
      return 'Password must contain at least one letter';
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    _emailText = widget.email;
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Information"),
        elevation: 4.0,
        backgroundColor: Colors.white,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        initialValue: _emailText,
                        validator: validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText:
                                FFULocalizations.of(context).emailLabel),
                        onSaved: (String value) {
                          _emailText = value;
                        }),
                    const SizedBox(height: 8.0),
                    TextFormField(
                        validator: validateName,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        autofocus: true,
                        decoration: InputDecoration(
                            labelText:
                                FFULocalizations.of(context).nameLabel),
                        onSaved: (String value) {
                          _nameText = value;
                        }),
                    const SizedBox(height: 8.0),
                    TextFormField(
                        validator: validatePassword,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText:
                                FFULocalizations.of(context).passwordLabel),
                        onSaved: (String value) {
                          _password = value;
                        }),
                  ],
                )),
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
                  FFULocalizations.of(context).saveLabel,
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                )),
          ),
        ],
      ),
    );
  }

  _connexion(BuildContext context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      FirebaseAuth _auth = FirebaseAuth.instance;
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailText,
          password: _password,
        );
        try {
          var userUpdateInfo = UserUpdateInfo();
          userUpdateInfo.displayName = _nameText;
          await _auth.updateProfile(userUpdateInfo);
          Navigator.pop(context, true);
        } catch (e) {
          showErrorDialog(context, e.details);
        }
      } on PlatformException catch (e) {
        print(e.details);
        //TODO improve errors catching
        String msg = FFULocalizations.of(context).passwordLengthMessage;
        showErrorDialog(context, msg);
      }
    }
  }
}
