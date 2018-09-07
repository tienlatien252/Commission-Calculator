import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'l10n/localization.dart';
import 'password_view.dart';
import 'sign_up_view.dart';
import 'utils.dart';

class EmailView extends StatefulWidget {
  @override
  _EmailViewState createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  final TextEditingController _controllerEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _emailText;

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
                    child: TextFormField(
                        validator: validateEmail,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: FFULocalizations.of(context).emailLabel),
                        onSaved: (String value) {
                          _emailText = value;
                        }),
                  ),
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
                    color: Theme.of(context).accentColor.withAlpha(100),
                  ),
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
        final FirebaseAuth auth = FirebaseAuth.instance;
        List<String> providers =
            await auth.fetchProvidersForEmail(email: _emailText);
        print(providers);

        if (providers.isEmpty) {
          bool connected = await Navigator.of(context)
              .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
            return SignUpView(_emailText);
          }));

          if (connected) {
            Navigator.pop(context);
          }
        } else if (providers.contains('password')) {
          bool connected = await Navigator.of(context)
              .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
            return PasswordView(_emailText);
          }));

          if (connected) {
            Navigator.pop(context);
          }
        } else {
          String provider = await _showDialogSelectOtherProvider(
              _emailText, providers);
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
                    return new RaisedButton(
                      child: new Row(
                        children: <Widget>[
                          new Text(_providerStringToButton(p)),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(p);
                      },
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
