import 'package:flutter/material.dart';
import 'home_page.dart';
import 'flutter_firebase_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    SignInScreen.tag: (context) => SignInScreen(),
    HomePage.tag: (context) => HomePage(title: 'Kodeversitas'),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: SignInScreen(),
      routes: routes,
    );
  }
}
