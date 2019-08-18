import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:Calmission/localization/localization.dart';
import 'utils.dart';

class TroubleSignIn extends StatefulWidget {
  final String email;

  TroubleSignIn(this.email, {Key key}) : super(key: key);

  @override
  _TroubleSignInState createState() => _TroubleSignInState();
}

class _TroubleSignInState extends State<TroubleSignIn> {
  TextEditingController _controllerEmail;

  @override
  initState() {
    super.initState();
    _controllerEmail = TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    _controllerEmail.text = widget.email;
    return Scaffold(
      appBar: AppBar(
        title: Text(FFULocalizations.of(context).recoverPasswordTitle),
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
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: FFULocalizations.of(context).emailLabel),
                ),
                SizedBox(height: 16.0),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      FFULocalizations.of(context).recoverHelpLabel,
                      style: Theme.of(context).textTheme.caption,
                    )),
                //const SizedBox(height: 5.0),
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
              onTap: () => _send(context),
              child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  //margin: EdgeInsets.all(10.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Theme.of(context).accentColor,
                  ),
                  child: Text(
                    FFULocalizations.of(context).sendButtonLabel,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  )),
            ),
          ],
        ),
    );
  }

  _send(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: _controllerEmail.text);
    } catch (exception) {
      showErrorDialog(context, exception);
    }

    showErrorDialog(context,
        FFULocalizations.of(context).recoverDialog(_controllerEmail.text));
  }
}
