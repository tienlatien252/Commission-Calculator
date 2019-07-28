import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'l10n/localization.dart';
//import 'password_view.dart';
import 'sign_up_view.dart';
import 'utils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EmailView extends StatefulWidget {
  @override
  _EmailViewState createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Email Is Not Valid';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(FFULocalizations.of(context).welcome),
          backgroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          validator: validateEmail,
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: InputDecoration(
                              labelText:
                                  FFULocalizations.of(context).emailLabel),
                        ),
                        TextFormField(
                            controller: _passwordController,
                            autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                            autocorrect: false,
                            decoration: InputDecoration(
                                labelText:
                                    FFULocalizations.of(context).passwordLabel))
                      ])),
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
                  margin: EdgeInsets.all(10.0),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Theme.of(context).accentColor),
                  child: Text(
                    FFULocalizations.of(context).nextButtonLabel,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  )),
            ),
          ],
        ),
      );

  _connexion(BuildContext context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        ))
            .user;
        if (user != null) {
      Navigator.of(context).pop(true);
    }
      } catch (exception) {
        print(exception);
      }
    }
  }
}
