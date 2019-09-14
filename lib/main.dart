import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

import 'package:Calmission/splash_page.dart';
import 'package:Calmission/services/firebase_auth_service.dart';
import 'package:Calmission/services/email_secure_store.dart';
import 'package:Calmission/services/employer_service.dart';

void main() => runApp(MyApp());

const String APP_ID = '1:154487703908:android:b6c7c03dd0151198';

/*final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  testDevices: APP_ID != null ? [APP_ID] : null,
  keywords: ['Games', 'Puzzles'],
);*/
 
class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  final String title = "Calmission";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider<FirebaseAuthService>(
            builder: (_) => FirebaseAuthService.instance(),
            //dispose: (_, FirebaseAuthService authService) =>
            //    authService.dispose(),
          ),
          Provider<EmailSecureStore>(
            builder: (_) =>
                EmailSecureStore(flutterSecureStorage: FlutterSecureStorage()),
          ),
          ChangeNotifierProvider<EmployerService>(
              builder: (_) => EmployerService())
        ],
        child: MaterialApp(
            title: 'Commission Calculator',
            theme: ThemeData(
                scaffoldBackgroundColor: Color.fromRGBO(77, 182, 172, 1.0),
                primaryColor: Color.fromRGBO(77, 182, 172, 1.0),
                primaryColorDark: Color.fromRGBO(0, 134, 125, 1.0),
                primaryColorLight: Color.fromRGBO(130, 233, 222, 1.0),
                buttonColor: Color.fromRGBO(255, 233, 125, 1.0),
                accentColor: Color.fromRGBO(255, 183, 77, 1.0),
                textSelectionColor: Color.fromRGBO(200, 135, 25, 1.0)
                //highlightColor: Color.fromRGBO(255, 183, 77, 1.0)
                //selectedRowColor: Color.fromRGBO(255, 183, 77, 1.0),
                //secondaryHeaderColor: Color.fromRGBO(255, 183, 77, 1.0)
                ),
            home: SplashPage(
                //title: title,
                )));
  }
}
