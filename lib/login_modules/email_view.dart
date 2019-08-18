import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:Calmission/localization/localization.dart';
import 'package:Calmission/login_modules/password_view.dart';
import 'package:Calmission/login_modules/sign_up_view.dart';
import 'package:Calmission/login_modules/utils.dart';
import 'package:Calmission/services/validator.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EmailView extends StatefulWidget {

  @override
  _EmailViewState createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

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
                          validator: (String value) => validateEmail(context, value),
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: InputDecoration(
                              labelText:
                                  FFULocalizations.of(context).emailLabel),
                        ),
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
        List<String> providers = await _auth.fetchSignInMethodsForEmail(
            email: _emailController.text);

        print(providers);

        if (providers.isEmpty) {
          bool connected = await Navigator.of(context)
              .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
            return SignUpView(_emailController.text);
          }));

          if (connected) {
            Navigator.pop(context);
          }
        } else if (providers.contains('password')) {
          bool connected = await Navigator.of(context)
              .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
            return PasswordView(email: _emailController.text);
          }));

          if (connected) {
            Navigator.pop(context);
          }
        } else {
          String provider =
              await _showDialogSelectOtherProvider(_emailController.text, providers);
          if (provider.isNotEmpty) {
            Navigator.pop(context, provider);
          }
        }
      } catch (exception) {
        print(exception);
      }
    }
  }

  _showDialogSelectOtherProvider(String email, List<String> providers) {
    var providerName = _providersToString(providers);
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => new AlertDialog(
        content: new SingleChildScrollView(
            child: new ListBody(
          children: <Widget>[
            new Text(FFULocalizations.of(context)
                .allReadyEmailMessage(email, providerName)),
            new SizedBox(
              height: 16.0,
            ),
            new Column(
              children: providers.map((String p) {
                return InkWell(
                  onTap: () => Navigator.of(context).pop(p),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    //margin: EdgeInsets.all(10.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Theme.of(context).accentColor,
                    ),
                    child: Row(
                      children: <Widget>[
                        new Text(_providerStringToButton(p)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        )),
        actions: <Widget>[
          new FlatButton(
            child: new Row(
              children: <Widget>[
                new Text(FFULocalizations.of(context).cancelButtonLabel),
              ],
            ),
            onPressed: () {
              Navigator.of(context).pop('');
            },
          ),
        ],
      ),
    );
  }

  String _providersToString(List<String> providers) {
    return providers.map((String provider) {
      ProvidersTypes type = stringToProvidersType(provider);
      return providersDefinitions(context)[type]?.name;
    }).join(", ");
  }

  String _providerStringToButton(String provider) {
    ProvidersTypes type = stringToProvidersType(provider);
    return providersDefinitions(context)[type]?.label;
  }
}
