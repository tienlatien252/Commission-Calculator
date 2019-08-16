import 'package:Calmission/home_page.dart';
import 'package:Calmission/services/employer_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Calmission/login_modules/login_page.dart';
import 'package:Calmission/services/auth_service.dart';
import 'package:Calmission/services/firebase_auth_service.dart';
import 'package:Calmission/employer_page/employerSetup.dart';
import 'package:Calmission/common_widgets/platform_loading_indicator.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth = Provider.of<FirebaseAuthService>(context);
    return StreamBuilder<User>(
      stream: auth.onCheckCurrentUser,
      builder: (_, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            return SignInScreen(
              title: "Calmission",
            );
          }
          EmployerService employerService =
              Provider.of<EmployerService>(context);
          return FutureBuilder(
              future: employerService.getPersistedData(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!employerService.seenSetup) {
                    return EmployerSetup(isInitialSetting: true);
                  }
                  return HomePage(
                    title: "Calmission",
                  );
                }
                return Scaffold(
                  body: Center(
                    child: PlatformLoadingIndicator(),
                  ),
                );
              });
        } else {
          return Scaffold(
            body: Center(
              child: PlatformLoadingIndicator(),
            ),
          );
        }
      },
    );
  }
}
