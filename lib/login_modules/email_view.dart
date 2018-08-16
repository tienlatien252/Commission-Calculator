import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'l10n/localization.dart';
import 'password_view.dart';
import 'sign_up_view.dart';
import 'utils.dart';

class EmailView extends StatefulWidget {
  @override
  _EmailViewState createState() =>  _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  final TextEditingController _controllerEmail =  TextEditingController();

  @override
  Widget build(BuildContext context) =>  Scaffold(
        appBar:  AppBar(
          title:  Text(FFULocalizations.of(context).welcome),
          elevation: 4.0,
        ),
        body:  Builder(
          builder: (BuildContext context) {
            return  Padding(
              padding: const EdgeInsets.all(16.0),
              child:  Column(
                children: <Widget>[
                   TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration:  InputDecoration(
                        labelText: FFULocalizations.of(context).emailLabel),
                  ),
                ],
              ),
            );
          },
        ),
        persistentFooterButtons: <Widget>[
           ButtonBar(
            alignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
               FlatButton(
                  onPressed: () => _connexion(context),
                  child:  Row(
                    children: <Widget>[
                       Text(FFULocalizations.of(context).nextButtonLabel),
                    ],
                  )),
            ],
          )
        ],
      );

  _connexion(BuildContext context) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      List<String> providers =
          await auth.fetchProvidersForEmail(email: _controllerEmail.text);
      print(providers);

      if (providers.isEmpty) {
        bool connected = await Navigator
            .of(context)
            .push( MaterialPageRoute<bool>(builder: (BuildContext context) {
          return  SignUpView(_controllerEmail.text);
        }));

        if (connected) {
          Navigator.pop(context);
        }
      } else if (providers.contains('password')) {
        bool connected = await Navigator
            .of(context)
            .push( MaterialPageRoute<bool>(builder: (BuildContext context) {
          return  PasswordView(_controllerEmail.text);
        }));

        if (connected) {
          Navigator.pop(context);
        }
      } else {
        String provider = await _showDialogSelectOtherProvider(
            _controllerEmail.text, providers);
        if (provider.isNotEmpty) {
          Navigator.pop(context, provider);
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  _showDialogSelectOtherProvider(String email, List<String> providers) {
    var providerName = _providersToString(providers);
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) =>  AlertDialog(
            content:  SingleChildScrollView(
                child:  ListBody(
              children: <Widget>[
                 Text(FFULocalizations
                    .of(context)
                    .allReadyEmailMessage(email, providerName)),
                 SizedBox(
                  height: 16.0,
                ),
                 Column(
                  children: providers.map((String p) {
                    return  RaisedButton(
                      child:  Row(
                        children: <Widget>[
                           Text(_providerStringToButton(p)),
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
               FlatButton(
                child:  Row(
                  children: <Widget>[
                     Text(FFULocalizations.of(context).cancelButtonLabel),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
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
