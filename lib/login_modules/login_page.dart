export 'utils.dart';

import 'package:flutter/material.dart';
import 'login_view.dart';
import 'utils.dart';

class SignInScreen extends StatefulWidget {
  static String tag = 'login-page';
  SignInScreen({
    Key key,
    this.title,
    this.header,
    this.providers,
    this.color = Colors.white,
  }) : super(key: key);

  final String title;
  final Widget header;
  final List<ProvidersTypes> providers;
  final Color color;

  @override
  _SignInScreenState createState() =>  _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Widget get _header => widget.header ??  Container();

  List<ProvidersTypes> get _providers =>
      widget.providers ?? [ProvidersTypes.email];

  @override
  Widget build(BuildContext context) =>  Scaffold(
      appBar:  AppBar(
        title:  Text(widget.title),
        elevation: 4.0,
      ),
      body:  Builder(
        builder: (BuildContext context) {
          return  Container(
              padding: const EdgeInsets.all(16.0),
              decoration:  BoxDecoration(color: widget.color),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _header,
                   Expanded(child:  LoginView(providers: _providers))
                ],
              ));
        },
      ));
}
