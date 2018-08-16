import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'home_page.dart';
import 'logic/app_state.dart';
import 'models/employer.dart';
import 'add_new_employer_dialog.dart';
import 'employers_list_view.dart';

class _EmployersViewModel {
  _EmployersViewModel(
      {this.employers, this.onGetCurrentEmployer, this.currentUser, this.onGetEmployers});
  final List<Employer> employers;
  final Function() onGetCurrentEmployer;
  final Function(List<Employer>) onGetEmployers;
  final FirebaseUser currentUser;
}

class EmployerSetup extends StatefulWidget {
  EmployerSetup({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EmployerSetupState createState() => _EmployerSetupState();
}

class _EmployerSetupState extends State<EmployerSetup> {
  Future<Null> _openAddEmployerDialog() async {
    // TODO implement the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddEmployerView(title: "Add Employer");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Employer\'s setup"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 100.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Add A New Employer'),
                      onPressed: _openAddEmployerDialog,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: EmployersListView(),
              )
            ],
          ),
        ),
        floatingActionButton: NextButton(title: widget.title));
  }
}

class NextButton extends StatefulWidget {
  NextButton({Key key, this.user, this.title, this.employers}) : super(key: key);
  final FirebaseUser user;
  final String title;
  final List<Employer> employers;

  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  _saveEmployersAndGoNext(_EmployersViewModel viewModel) async {
    if (viewModel.employers == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Please add at least one employer"),
          ));
      return;
    }
    viewModel.onGetCurrentEmployer();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(title: widget.title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _EmployersViewModel>(converter: (store) {
      return _EmployersViewModel(
          onGetCurrentEmployer: () => store.dispatch(
              ChangeCurrentEmployerAction(store.state.employers[0])),
          employers: store.state.employers,
          currentUser: store.state.currentUser);
    }, builder: (BuildContext context, _EmployersViewModel viewModel) {
      return RaisedButton(
        onPressed: () => _saveEmployersAndGoNext(viewModel),
        child: Text("Next"),
      );
    }); // This trailing c
  }
}
