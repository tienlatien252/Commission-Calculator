import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'employerSetup.dart';
import 'home_page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Employer.dart';
import 'app_state/middleware.dart';
import 'app_state/AppState.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final store = new Store<AppState>(reducer,
      initialState: AppState(), middleware: [middleware].toList());

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: new MaterialApp(
        title: 'Commission Calculator',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new WelcomePage(title: 'Commission Calculator', store: store),
        routes: <String, WidgetBuilder> { //5
          '/employerSetup': (BuildContext context) => new EmployerSetup(), //6
          '/homePage' : (BuildContext context) => new HomePage() //7
        }
      ),
    );
  }
}
