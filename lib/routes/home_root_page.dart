import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import '../employer_page/employerSetup.dart';
import '../home_page.dart';
import '../models/employer.dart';
import '../logic/app_state.dart';

class _HomeRootPageViewModel {
  _HomeRootPageViewModel({this.currentEmployer});
  final Employer currentEmployer;
}

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
        return StoreConnector<AppState, _HomeRootPageViewModel>(converter: (store) {
          return _HomeRootPageViewModel(
              currentEmployer: store.state.currentEmployer);
        }, builder: (BuildContext context, _HomeRootPageViewModel viewModel) {
          if (viewModel.currentEmployer == null) {
            return _buildWaitingScreen();
          }
          return HomePage(
            onSignedOut: widget.onSignedOut,
            title: widget.title,
          );
        });
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
