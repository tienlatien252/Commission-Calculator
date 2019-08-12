import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'package:Calmission/services/employer_service.dart';

class HomeRootPage extends StatefulWidget {
  HomeRootPage({Key key, this.title, this.onSignedOut})
      : super(key: key);
  final VoidCallback onSignedOut;

  final String title;

  @override
  State<StatefulWidget> createState() => _HomeRootPageState();
}

enum SetupStatus {
  notDetermined,
  notSetup,
  setup,
}

class _HomeRootPageState extends State<HomeRootPage> {
  SetupStatus setupStatus = SetupStatus.notDetermined;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    return _seen;
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen().then((seen) {
      setState(() {
        setupStatus = seen ? SetupStatus.setup : SetupStatus.notSetup;
      });
    });
  }

  _seen() {
    setState(() {
      setupStatus = SetupStatus.setup;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (setupStatus) {
      case SetupStatus.notDetermined:
        return _buildWaitingScreen();
      case SetupStatus.notSetup:
        return EmployerSetup(
          title: widget.title,
          isInitialSetting: true,
          seenSetup: _seen,
        );
      case SetupStatus.setup:
          return HomePage(
            onSignedOut: widget.onSignedOut,
            title: widget.title,
          );
        }
    }
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
//}
