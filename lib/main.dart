import 'package:flutter/material.dart';
import 'welcome_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new WelcomePage(title: 'Flutter Demo Home Page'),
    );
  }
}