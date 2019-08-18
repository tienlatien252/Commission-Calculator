import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import 'package:Calmission/localization/localization.dart';
import 'package:Calmission/services/validator.dart';
import 'package:Calmission/login_modules/utils.dart';
import 'package:Calmission/services/firebase_auth_service.dart';


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
                        validator: (String value) => validateEmail(context,value),
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
                        validator: (String value) => validateName(context,value),
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
                        validator: (String value) => validatePassword(context,value),
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
            onTap: () => _register(context),
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

  _register(BuildContext context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        final FirebaseAuthService _auth = Provider.of<FirebaseAuthService>(context, listen: false);
        await _auth.register(_emailText, _password);
        try {
          await _auth.updateUserInfo(_nameText);
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
