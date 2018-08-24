import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'employer_page/employerSetup.dart';
import 'home_page.dart';
import 'models/employer.dart';
import 'logic/middleware.dart';
import 'logic/app_state.dart';
import 'logic/reducer.dart';
import 'routes/root_page.dart';

void main() => runApp(MyApp());

const String APP_ID = '1:154487703908:android:b6c7c03dd0151198';

final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  testDevices: APP_ID != null ? [APP_ID] : null,
  keywords: ['Games', 'Puzzles'],
);

class UserView {
  final FirebaseUser currentUser;
  final Employer currentEmployer;
  UserView({this.currentUser, this.currentEmployer});
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  final String title = "Commission Calculator";

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final store = Store<AppState>(reducer,
      initialState: AppState(), middleware: [middleware].toList());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
            routes: <String, WidgetBuilder>{
              '/InitEmployerSetup': (BuildContext context) => EmployerSetup(
                    title: widget.title,
                    isInitialSetting: true,
                  ),
              '/loading': (BuildContext context) =>
                  LoadingView(title: widget.title),
              '/home': (BuildContext context) => HomePage(title: widget.title),
            },
            title: 'Commission Calculator',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.grey[200],
              primaryColorDark: Color.fromRGBO(0, 147, 196, 1.0),
              primaryColorLight: Color.fromRGBO(139, 246, 255, 1.0),
              primaryColor: Color.fromRGBO(79, 195, 247, 1.0),
            ),
            home: RootPage(
              store: store,
              title: widget.title,
            )));
  }
}

class LoadingView extends StatelessWidget {
  LoadingView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
